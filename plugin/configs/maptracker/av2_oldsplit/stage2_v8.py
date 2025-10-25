_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage2_warmup.py'
]

model = dict(
    skip_prepare_track_queries=True, # NOTE: no tracking
    use_memory=False,
)

# checkpoint: load from Stage 1 (geo-split pretrain)
work_dir = 'work_dirs/stage2_v8'
load_from = 'work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage1_bev_pretrain/latest.pth'