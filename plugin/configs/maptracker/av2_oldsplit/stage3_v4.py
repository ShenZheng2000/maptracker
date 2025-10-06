_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    history_steps=0,
    test_time_history_steps=0,
    backbone_cfg=dict(
        history_steps=0,
    )
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v4'
load_from = 'work_dirs/stage2_v4/latest.pth'