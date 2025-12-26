_base_ = [
    'stage3_v11_noseg.py'
]

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v11_noseg_nostage2' # NOTE: use new folder
load_from = "work_dirs/stage1_v11/latest.pth" # NOTE: train from stage 1 checkpoint