_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    skip_prepare_track_queries=True, # NOTE: no tracking
    use_memory=False,
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v8'
load_from = 'work_dirs/stage2_v8/latest.pth'