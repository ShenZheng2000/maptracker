_base_ = [
    'maptracker_av2_oldsplit_5frame_span10_stage1_bev_pretrain.py'
]

# dataset overrides for geo-split
data = dict(
    train=dict(
        ann_file='./datasets/argoverse2_geosplit/av2_map_infos_train.pkl',
    ),
    val=dict(
        ann_file='./datasets/argoverse2_geosplit/av2_map_infos_val.pkl',
    ),
    test=dict(
        ann_file='./datasets/argoverse2_geosplit/av2_map_infos_val.pkl',
    ),
)

eval_config = dict(
    ann_file='./datasets/argoverse2_geosplit/av2_map_infos_val.pkl'
)

match_config = dict(
    ann_file='./datasets/argoverse2_geosplit/av2_map_infos_val.pkl'
)