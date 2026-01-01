_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py'
]

model = dict(
    backbone_cfg=dict(
        disable_warped_history_fusion=True,
    ),
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage2_v13'
load_from = 'work_dirs/stage1_v13/latest.pth'