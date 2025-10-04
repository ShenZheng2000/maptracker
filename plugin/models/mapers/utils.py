import numpy as np
import torch
from scipy.spatial.transform import Rotation as R

def add_noise_to_pose(rot, trans, rot_std=0.08, trans_std=0.25):
    rot_euler = rot.as_euler('zxy')

    # 0.08 mean is around 5-degree, 3-sigma is 15-degree
    # noise_euler = np.random.randn(*list(rot_euler.shape)) * 0.08
    noise_euler = np.random.randn(*list(rot_euler.shape)) * rot_std
    rot_euler += noise_euler
    noisy_rot = R.from_euler('zxy', rot_euler)

    # error within 0.25 meter
    # noise_trans = torch.randn_like(trans) * 0.25
    noise_trans = torch.randn_like(trans) * trans_std

    # handle 1D or 2D translation
    if noise_trans.ndim == 1:     # shape (3,)
        noise_trans[2] = 0
    elif noise_trans.ndim == 2:   # shape (N, 3)
        noise_trans[:, 2] = 0

    noisy_trans = trans + noise_trans

    return noisy_rot, noisy_trans