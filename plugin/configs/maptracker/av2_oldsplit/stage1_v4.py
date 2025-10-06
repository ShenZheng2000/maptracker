_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain.py'
]

model = dict(
    history_steps=0,
    test_time_history_steps=0,
    backbone_cfg=dict(
        history_steps=0,
    )
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage1_v4'