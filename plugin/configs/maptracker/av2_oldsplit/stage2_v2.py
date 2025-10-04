_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py'
]

model = dict(
    add_pose_noise=False,  # do not add noise during finetuning
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage2_v2'
load_from = 'work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain/latest.pth'