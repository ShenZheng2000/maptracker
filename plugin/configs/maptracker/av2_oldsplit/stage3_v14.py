_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    backbone_cfg=dict(
        disable_prop_bev_feat=True,
    ),
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v14'
load_from = 'work_dirs/stage2_v14/latest.pth'