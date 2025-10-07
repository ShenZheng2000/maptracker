_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py'
]

history_steps = 0

model = dict(
    # history_steps=0,
    # test_time_history_steps=0,
    backbone_cfg=dict(
        history_steps=history_steps,
        transformer=dict(
            encoder=dict(
                history_steps=history_steps,
            ),
        ),
    ),
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage2_v4'
load_from = 'work_dirs/stage1_v4/latest.pth'