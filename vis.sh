# TODO: change out_dir later, if using different models

# nuScenes (predictions, vis_global)
# python tools/visualization/vis_global.py \
#     plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path work_dirs/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune/pos_predictions.pkl \
#     --out_dir vis_global/nuscenes_geosplit/maptracker \
#     --option vis-pred  \
#     --per_frame_result 1

# nuScenes (GT, vis_global)
# python tools/visualization/vis_global.py \
#     plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path /scratch/shenzhen/datasets/nuscenes/nuscenes_map_infos_val_gt_tracks.pkl \
#     --out_dir vis_global/nuscenes_geosplit/gt  \
#     --option vis-gt \
#     --per_frame_result 0

# # nuScenes (predictions, vis_local)
# python tools/visualization/vis_per_frame.py \
#     plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path work_dirs/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune/pos_predictions.pkl \
#     --out_dir vis_local/nuscenes_geosplit/maptracker \
#     --option vis-pred

# # nuScenes (GT, vis_local)
# python tools/visualization/vis_per_frame.py \
#     plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path /scratch/shenzhen/datasets/nuscenes/nuscenes_map_infos_val_gt_tracks.pkl \
#     --out_dir vis_local/nuscenes_geosplit/gt  \
#     --option vis-gt

# Argoverse2 (predictions, vis_global)
# python tools/visualization/vis_global.py \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/pos_predictions.pkl \
#     --out_dir vis_global/argoverse2_geosplit/maptracker \
#     --option vis-pred  \
#     --per_frame_result 1

# # Argoverse2 (GT, vis_global)
# python tools/visualization/vis_global.py \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path /scratch/shenzhen/datasets/argoverse2_geosplit/av2_map_infos_val_gt_tracks.pkl \
#     --out_dir vis_global/argoverse2_geosplit/gt  \
#     --option vis-gt \
#     --per_frame_result 0

# # Argoverse2 (predictions, vis_local)
# python tools/visualization/vis_per_frame.py \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/pos_predictions.pkl \
#     --out_dir vis_local/argoverse2_geosplit/maptracker \
#     --option vis-pred

# # Argoverse2 (GT, vis_local)
# python tools/visualization/vis_per_frame.py \
#     plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py \
#     --data_path /scratch/shenzhen/datasets/argoverse2_geosplit/av2_map_infos_val_gt_tracks.pkl \
#     --out_dir vis_local/argoverse2_geosplit/gt  \
#     --option vis-gt