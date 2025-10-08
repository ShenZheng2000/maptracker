_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

data = dict(
    val=dict(add_pose_noise_all=True, rot_std=0.02, trans_std=0.0625),
    test=dict(add_pose_noise_all=True, rot_std=0.02, trans_std=0.0625),
)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_test_noise_all_r002_t00625'
load_from = 'work_dirs/stage2_v2/latest.pth'