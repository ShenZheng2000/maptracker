_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

data = dict(
    val=dict(add_pose_noise_all=True, rot_std=0.08, trans_std=0.25),
    test=dict(add_pose_noise_all=True, rot_std=0.08, trans_std=0.25),
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_test_noise_all_r008_t025'
load_from = 'work_dirs/stage2_v2/latest.pth'