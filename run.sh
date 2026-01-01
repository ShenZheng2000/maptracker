# # Installation
# pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.9.0/index.html
# pip install av2==0.2.1

# # Dataset Preparation
# # Step1: download the dataset like how author did
# # symlink nuScenes data (change the source path accordingly)
# ln -s /ssd0/shenzhen/NuScenes/nuscenes ./datasets/nuscenes

# # Step2: Generate annotation files for Argoverse2 dataset., BUT based on CVPR'24 geosplit
# python tools/data_converter/argoverse_converter.py --data-root /scratch/shenzhen/datasets/argoverse2_geosplit
# python tools/data_converter/argoverse_converter.py --data-root /scratch/shenzhen/datasets/mapchange_geosplit
# python tools/data_converter/argoverse_converter.py --data-root /scratch/shenzhen/datasets/mapchange

# # NOTE:  geosplit file will be in original folder with original name (i.e. overwrites)
# python tools/data_converter/nuscenes_converter.py --data-root ./datasets/nuscenes --geosplit

# # Step3: Generate the tracking ground truth (NOTE: remove --visualize to save time)
# python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/argoverse2_geosplit
# python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/nuscenes
# python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/mapchange
# python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_geosplit_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/mapchange_geosplit

# # Training
# # Stage 1: BEV pretraining with semantic segmentation losses:
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage1_bev_pretrain.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_geosplit_5frame_span10_stage1_bev_pretrain.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_5frame_span10_stage1_bev_pretrain.py 8


# # Stage 2: Vector module warmup with a large batch size while freezing the BEV module:
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage2_warmup.py 8'
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_geosplit_5frame_span10_stage2_warmup.py 8 
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_5frame_span10_stage2_warmup.py 8

# # Stage 3: Joint finetuning:
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5fr5ame_span10_stage3_joint_finetune.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_geosplit_5frame_span10_stage3_joint_finetune.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/maptracker_mapchange_5frame_span10_stage3_joint_finetune.py 8


# V2
# # Stage 2 (NO pose noise for MapTracker or vector_memory)
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v2.py 8

# # Stage 3 (NO pose noise for MapTracker or vector_memory) => resume from interrupted training
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v2.py 8

# # Stage 3 (NO **TEST** pose noise for MapTracker or vector_memory)
# PORT=29501 bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_test_noise_r008_t025.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# PORT=29501 bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_test_noise_r016_t050.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# PORT=29501 bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_test_noise_r032_t100.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# PORT=29501 bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_v8.py work_dirs/stage3_v8/latest.pth 8 --eval --eval-options save_semantic=True


# V3
# Stage 2 (No vector memory)
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v3.py 8

# Stage 3 (No vector memory)
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v3.py 8

# V4
# Stage 1 (No bev memory) => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v4.py 8

# Stage 2 (No bev memory) => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v4.py 8

# Stage 3 (No bev memory) => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v4.py 8


# V5 
# Stage 3 ONLY, double bs => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v5.py 8

# V6
# Stage 1 (No bev memory) => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v6.py 8

# Stage 2 (No bev memory) => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v6.py 8

# # Stage 3 (No bev memory) => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v6.py 8

# V7
# Stage 3 ONLY, original bs => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v7.py 8

# V7_nostage2
# Stage 3 ONLY, original bs => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v7_nostage2.py 8

# V8
# skip_prepare_track_queries => DONE
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v8.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v8.py 8

# V9
# Disable seg loss and dice loss
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v9.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v9.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v9.py 8

# V10
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v10.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v10.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v10.py 8

# V11
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v11.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v11.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v11.py 8

# V11_noseg
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v11_noseg.py 8

# v11_noseg_nostage1_nostage2
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v11_noseg_nostage1_nostage2.py

# v11_noseg_nostage2
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v11_noseg_nostage2.py 8

# V13
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v13.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v13.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v13.py 8

# V14
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_v14.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_v14.py 8
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_v14.py 8