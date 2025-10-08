_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

data = dict(
    val=dict(add_pose_noise_all=True, rot_std=0.04, trans_std=0.125),
    test=dict(add_pose_noise_all=True, rot_std=0.04, trans_std=0.125),
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_test_noise_all_r004_t0125'
load_from = 'work_dirs/stage2_v2/latest.pth'