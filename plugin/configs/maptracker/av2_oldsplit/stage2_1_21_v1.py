_base_ = [
    'maptracker_av2_oldsplit_5frame_span10_stage2_warmup.py'
]

# overwrite PKL paths everywhere
new_val_pkl = '/scratch/shenzhen/datasets/argoverse2_geosplit/av2_map_infos_val.pkl'
new_train_pkl = '/scratch/shenzhen/datasets/argoverse2_geosplit/av2_map_infos_train.pkl'

# dataset overrides for geo-split
data = dict(
    train=dict(
        ann_file=new_train_pkl,
    ),
    val=dict(
        ann_file=new_val_pkl,
        eval_config=dict(
            ann_file=new_val_pkl,   # <--- must override here too
        ),
    ),
    test=dict(
        ann_file=new_val_pkl,
        eval_config=dict(
            ann_file=new_val_pkl,   # <--- must override here too
        ),
    ),
)

# also override top-level eval_config (for safety)
eval_config = dict(
    ann_file=new_val_pkl
)

# and match_config if required
match_config = dict(
    ann_file=new_val_pkl,
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage2_1_21_v1'
load_from = 'work_dirs/stage1_1_21_v1/latest.pth'