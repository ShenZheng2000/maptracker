_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

model = dict(
    add_test_pose_noise=True,  # add noise during testing (to simulate noisy pose input at test time
    rot_std=0.32,
    trans_std=1.00,
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_test_noise_r032_t100'
load_from = 'work_dirs/stage2_v2/latest.pth'