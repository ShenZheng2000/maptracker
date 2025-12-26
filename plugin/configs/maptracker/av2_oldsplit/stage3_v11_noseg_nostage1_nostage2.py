_base_ = [
    'stage3_v11_noseg.py'
]

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v11_noseg_nopretrain' # NOTE: use new folder
load_from = None # NOTE: train from scratch