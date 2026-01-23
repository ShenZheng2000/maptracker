# Installation
pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.9.0/index.html
pip install av2==0.2.1

# Dataset Preparation
# Step1: download the dataset like how author did

# Step2: Generate annotation files for Argoverse2 dataset., BUT based on CVPR'24 geosplit
python tools/data_converter/argoverse_converter.py --data-root ./datasets/argoverse2_geosplit

# Step3: Generate the tracking ground truth by
python tools/tracking/prepare_gt_tracks.py plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py  --out-dir tracking_gts/argoverse2_geosplit --visualize

bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage1_1_21_v1.py 8

bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage2_1_21_v1.py 8

# TODO: skip for now, since bad stage 2 results! 
# bash ./tools/dist_train.sh plugin/configs/maptracker/av2_oldsplit/stage3_1_21_v1.py 8
 
# TODO: if train with 7 GPUs, need to change num_gpus in all configs. otherwise, we train with 7/8 total iters!!!

# # Training
# # Stage 1: BEV pretraining with semantic segmentation losses:
# CUDA_VISIBLE_DEVICES=1 \
#     bash ./tools/dist_train.sh \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain.py \
#     1 \
#     --work-dir work_dirs/debug_stage1_bev_pretrain

# # TODO: check this result before move on to stage 3! 
# # Stage 2: Vector module warmup with a large batch size while freezing the BEV module:
# CUDA_VISIBLE_DEVICES=1,2,3,4,5,6,7 \
#     bash ./tools/dist_train.sh \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py \
#     7 \
#     --work-dir work_dirs/debug_stage2_warmup

# # Stage 3: Joint finetuning:
# CUDA_VISIBLE_DEVICES=1 \
#     bash ./tools/dist_train.sh \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py \
#     1 \
#     --work-dir work_dirs/debug_stage3_joint_finetune

# # Evaluation
# CUDA_VISIBLE_DEVICES=1,2,3,4,5,6,7 \
#     bash tools/dist_test.sh \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py \
#     work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth \
#     7 --eval --eval-options save_semantic=True