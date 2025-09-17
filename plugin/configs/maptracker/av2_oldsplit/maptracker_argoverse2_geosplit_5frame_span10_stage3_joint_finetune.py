_base_ = [
    'maptracker_av2_oldsplit_5frame_span10_stage3_joint_finetune.py'
]

# overwrite PKL paths everywhere
new_val_pkl = './datasets/argoverse2_geosplit/av2_map_infos_val.pkl'
new_train_pkl = './datasets/argoverse2_geosplit/av2_map_infos_train.pkl'

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

# checkpoint from stage2 (but now in geosplit work_dir)
work_dir = '/ssd1/shenzhen/maptracker/work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune'
load_from = '/ssd1/shenzhen/maptracker/work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup/latest.pth'