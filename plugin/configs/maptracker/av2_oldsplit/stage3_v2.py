_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    add_pose_noise=False,  # do not add noise during finetuning
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v2'
load_from = 'work_dirs/stage2_v2/latest.pth'