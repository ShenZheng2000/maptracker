_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py'
]

model = dict(
    disable_seg_dice_loss=True,
)

work_dir = 'work_dirs/stage2_v9'
load_from = 'work_dirs/stage1_v9/latest.pth'