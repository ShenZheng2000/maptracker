_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

# Ref: https://github.com/woodfrog/maptracker/issues/4

load_from = "work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain/latest.pth" # NOTE: train from scratch

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v7_nostage2'