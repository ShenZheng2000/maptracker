_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    disable_seg_dice_loss=True,
)

work_dir = 'work_dirs/stage3_v9'
load_from = 'work_dirs/stage2_v9/latest.pth'