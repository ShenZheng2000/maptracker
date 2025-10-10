_base_ = [
    'maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py'
]

# Ref: https://github.com/woodfrog/maptracker/issues/4

load_from = None # NOTE: train from scratch

num_gpus = 8
batch_size = 4 # NOTE: double batch size from 2 to 4
num_iters_per_epoch = 27243 // (num_gpus * batch_size)
num_epochs = 20
num_epochs_interval = num_epochs // 5
total_iters = num_epochs * num_iters_per_epoch

data = dict(
    samples_per_gpu=batch_size,
)

evaluation = dict(interval=num_epochs_interval*num_iters_per_epoch)
checkpoint_config = dict(interval=(num_epochs_interval * num_iters_per_epoch) // 2)

runner = dict(
    type='MyRunnerWrapper', max_iters=num_epochs * num_iters_per_epoch)

# checkpoint from stage2
work_dir = 'work_dirs/stage3_v5'