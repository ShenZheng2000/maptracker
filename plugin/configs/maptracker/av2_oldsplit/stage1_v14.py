_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain.py'
]

model = dict(
    backbone_cfg=dict(
        disable_prop_bev_feat=True,
    ),
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage1_v14'