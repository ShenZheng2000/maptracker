from .base_dataset import BaseMapDataset
from .map_utils.av2map_extractor import AV2MapExtractor
from mmdet.datasets import DATASETS
import numpy as np
from .visualize.renderer import Renderer
from time import time
import mmcv
from pyquaternion import Quaternion

import pickle
import os
from ..models.mapers.utils import add_noise_to_pose
from scipy.spatial.transform import Rotation as R
import torch

@DATASETS.register_module()
class AV2Dataset(BaseMapDataset):
    """Argoverse2 map dataset class.

    Args:
        ann_file (str): annotation file path
        cat2id (dict): category to class id
        roi_size (tuple): bev range
        eval_config (Config): evaluation config
        meta (dict): meta information
        pipeline (Config): data processing pipeline config,
        interval (int): annotation load interval
        work_dir (str): path to work dir
        test_mode (bool): whether in test mode
    """

    def __init__(self, add_pose_noise_all=False, rot_std=0.08, trans_std=0.25, **kwargs):
        super().__init__(**kwargs)
        self.map_extractor = AV2MapExtractor(self.roi_size, self.id2map)

        self.renderer = Renderer(self.cat2id, self.roi_size, 'av2')

        self.add_pose_noise_all = add_pose_noise_all
        self.rot_std = rot_std
        self.trans_std = trans_std

    def load_annotations(self, ann_file):
        """Load annotations from ann_file.

        Args:
            ann_file (str): Path of the annotation file.

        Returns:
            list[dict]: List of annotations.
        """
        
        start_time = time()
        ann = mmcv.load(ann_file)
        self.id2map = ann['id2map']
        samples = ann['samples']

        # if 'newsplit' not in ann_file:
        if ('newsplit' not in ann_file) and ('geosplit' not in ann_file) and ('mapchange' not in ann_file):
            if 'val' in ann_file:
                # For the old split testing, we make sure that the test set matches exactly with the MapTR codebase
                # NOTE: simply sort&sampling will produce slightly different results compared to MapTR's samples
                # so we have to directly use the saved meta information from MapTR codebase to get the samples
                maptr_meta_path = os.path.join(os.path.dirname(ann_file), 'maptrv2_val_samples_info.pkl')
                with open(maptr_meta_path, 'rb') as f:
                    maptr_meta = pickle.load(f)
                maptr_unique_tokens = [x['token'] for x in maptr_meta['samples_meta']]

                unique_token2samples = {}
                for sample in samples:
                    unique_token2samples[f'{sample["log_id"]}_{sample["token"]}'] = sample

                samples = [unique_token2samples[x] for x in maptr_unique_tokens]
            else:
                # For the old split training, we follow MapTR's data loading, which
                # sorts the samples based on the token, then do sub-sampling
                samples = list(sorted(samples, key=lambda e: e['token']))
                samples = samples[::self.interval]
        else:
            # For the new split, we simply follow StreamMapNet, do not sort based on the token
            # In this way, the intervals between consecutive frames are uniform...
            samples = samples[::self.interval]

        # Since the sorted order copied from MapTR does not strictly enforce that
        # samples of the same scene are consecutive, need to re-arrange
        scene_name2idx = {}
        for idx, sample in enumerate(samples):
            scene = sample['log_id']
            if scene not in scene_name2idx:
                scene_name2idx[scene] = []
            scene_name2idx[scene].append(idx)

        samples_rearrange = []
        for scene_name in scene_name2idx:
            scene_sample_ids = scene_name2idx[scene_name]
            for sample_id in scene_sample_ids:
                samples_rearrange.append(samples[sample_id])
        
        samples = samples_rearrange

        print(f'collected {len(samples)} samples in {(time() - start_time):.2f}s')
        self.samples = samples

    def load_matching(self, matching_file):
        with open(matching_file, 'rb') as pf:
            data = pickle.load(pf)
        total_samples = 0
        for scene_name, info in data.items():
            total_samples += len(info['sample_ids'])

        assert total_samples == len(self.samples), 'Matching info not matched with data samples'
        self.matching_meta = data
        print(f'loaded matching meta for {len(data)} scenes')

    def get_sample(self, idx):
        """Get data sample. For each sample, map extractor will be applied to extract 
        map elements. 

        Args:
            idx (int): data index

        Returns:
            result (dict): dict of input
        """

        sample = self.samples[idx]
        log_id = sample['log_id']

        # map_geoms = self.map_extractor.get_map_geom(log_id, sample['e2g_translation'], 
        #         sample['e2g_rotation'])

        # (2025-10-07) add noise only inside this branch
        if self.add_pose_noise_all:
            rot = R.from_matrix(sample['e2g_rotation'])
            trans = torch.tensor(sample['e2g_translation'], dtype=torch.float32)

            noisy_rot, noisy_trans = add_noise_to_pose(
                rot, trans, rot_std=self.rot_std, trans_std=self.trans_std
            )

            # print debug info
            # if idx < 5:
            #     print(f"\n[POSE NOISE DEBUG] idx={idx} | scene={sample['scene_name']}")
            #     print(f"  rot_std={self.rot_std:.3f}, trans_std={self.trans_std:.3f}")
            #     print(f"  Original trans: {trans.tolist()}")
            #     print(f"  Noisy trans: {noisy_trans.tolist()}")
            #     print(f"  Δtrans: {(noisy_trans - trans).tolist()}")
            #     orig_euler = rot.as_euler('zxy', degrees=True)
            #     noisy_euler = noisy_rot.as_euler('zxy', degrees=True)
            #     print(f"  Δrot (deg): {np.round((noisy_euler - orig_euler), 3).tolist()}")

            # both extractor & model expect 3×3 rotation matrix
            rot_mat = np.array(noisy_rot.as_matrix(), dtype=float)
            map_geoms = self.map_extractor.get_map_geom(log_id, noisy_trans.numpy(), rot_mat)

            used_trans = noisy_trans.numpy()
            used_rot = rot_mat

        else:
            # ✅ untouched original path
            map_geoms = self.map_extractor.get_map_geom(
                log_id, sample['e2g_translation'], sample['e2g_rotation'])
            used_trans = sample['e2g_translation']
            used_rot = sample['e2g_rotation']


        map_label2geom = {}
        for k, v in map_geoms.items():
            if k in self.cat2id.keys():
                map_label2geom[self.cat2id[k]] = v
        
        ego2img_rts = []
        for c in sample['cams'].values():
            extrinsic, intrinsic = np.array(
                c['extrinsics']), np.array(c['intrinsics'])
            ego2cam_rt = extrinsic
            viewpad = np.eye(4)
            viewpad[:intrinsic.shape[0], :intrinsic.shape[1]] = intrinsic
            ego2cam_rt = (viewpad @ ego2cam_rt)
            ego2img_rts.append(ego2cam_rt)


        # pdb.set_trace()

        input_dict = {
            'token': sample['token'],
            'img_filenames': [c['img_fpath'] for c in sample['cams'].values()],
            # intrinsics are 3x3 Ks
            'cam_intrinsics': [c['intrinsics'] for c in sample['cams'].values()],
            # extrinsics are 4x4 tranform matrix, NOTE: **ego2cam**
            'cam_extrinsics': [c['extrinsics'] for c in sample['cams'].values()],
            'ego2img': ego2img_rts,
            'map_geoms': map_label2geom, # {0: List[ped_crossing(LineString)], 1: ...}

            # 'ego2global_translation': sample['e2g_translation'],
            # 'ego2global_rotation': sample['e2g_rotation'].tolist(), 
            
            # (2025-10-07) add noise only inside this branch
            'ego2global_translation': used_trans,
            'ego2global_rotation': used_rot.tolist(),

            'sample_idx': sample['modified_sample_idx'],
            'scene_name': sample['scene_name'],
            'lidar_path': sample['lidar_fpath']
        }

        return input_dict