_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    use_memory=False, # NOTE: no memory in Stage 3
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v3'
load_from = 'work_dirs/stage2_v3/latest.pth'