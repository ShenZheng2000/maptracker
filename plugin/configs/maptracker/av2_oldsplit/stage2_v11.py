# NOTE: inherit from single-frame setting (no temporal information at all)
_base_ = [
    'stage2_v10.py'
]

embed_dims = 512
num_points = 20

# # NOTE: use this for quick debug
# evaluation = dict(interval=300)

model = dict(
    backbone_cfg=dict(
        transformer=dict(
            encoder=dict(
                num_layers=1, # NOTE: 2 -> 1
            )
        )
    ),
    head_cfg=dict(
        transformer=dict(
            decoder=dict(
                transformerlayers=dict(
                    # NOTE: attn_cfgs and operation_order has been changed
                    attn_cfgs=[
                        dict(
                            type='MultiheadAttention',
                            embed_dims=embed_dims,
                            num_heads=8,
                            attn_drop=0.1,
                            proj_drop=0.1,
                        ),
                        dict(
                            type='CustomMSDeformableAttention',
                            embed_dims=embed_dims,
                            num_heads=8,
                            num_levels=1,
                            num_points=num_points,
                            dropout=0.1,
                        ),
                    ],
                    operation_order=('self_attn', 'norm', 'cross_attn', 'norm',
                                    'ffn', 'norm')
                )
            )
        )
    ),
)

work_dir = 'work_dirs/stage2_v11'
load_from = 'work_dirs/stage1_v11/latest.pth'