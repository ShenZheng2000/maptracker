_base_ = [
    'stage3_v11.py'
]

# NOTE: disable all seg-related losses
model = dict(
    disable_seg_loss=True,
    disable_seg_dice_loss=True,
)


# checkpoint from stage2
work_dir = 'work_dirs/stage3_v11_noseg' # NOTE: use new folder
load_from = 'work_dirs/stage2_v11/latest.pth' # NOTE: use old ckpt