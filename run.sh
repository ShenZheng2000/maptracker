# Installation
pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.9.0/index.html
pip install av2==0.2.1

# Dataset Preparation
# Step1: download the dataset like how author did
# symlink nuScenes data (change the source path accordingly)
ln -s /ssd0/shenzhen/NuScenes/nuscenes ./datasets/nuscenes

# Step2: Generate annotation files for Argoverse2 dataset., BUT based on CVPR'24 geosplit
python tools/data_converter/argoverse_converter.py --data-root ./datasets/argoverse2_geosplit
# NOTE:  geosplit file will be in original folder with original name (i.e. overwrites)
python tools/data_converter/nuscenes_converter.py --data-root ./datasets/nuscenes --geosplit

# Step3: Generate the tracking ground truth by
python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/argoverse2_geosplit --visualize
python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/nuscenes --visualize

# train maptracker on 8 GPUs
# Later: retrain streammapnet on 8 GPUs (nuscenes and av2). 

# Training
# Stage 1: BEV pretraining with semantic segmentation losses:
bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain.py 8
bash ./tools/dist_train.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage1_bev_pretrain.py 8

# Stage 2: Vector module warmup with a large batch size while freezing the BEV module:
bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py 8
bash ./tools/dist_train.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage2_warmup.py 8

# Stage 3: Joint finetuning:
bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py 8
bash ./tools/dist_train.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py 8

# Evaluation
bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
bash tools/dist_test.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py work_dirs/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True