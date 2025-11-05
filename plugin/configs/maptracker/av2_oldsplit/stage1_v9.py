_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain.py'
]

model = dict(
    disable_seg_dice_loss=True,
)

work_dir = 'work_dirs/stage1_v9'