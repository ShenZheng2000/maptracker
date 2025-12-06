# # Evaluation with mAP
# bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# bash tools/dist_test.sh plugin/configs/maptracker/nuscenes_oldsplit/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune.py work_dirs/maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_v9.py work_dirs/stage3_v9/latest.pth 8 --eval --eval-options save_semantic=True

# # Evaluation with mAP (with pose noise for all during testing)
# bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_test_noise_all_r008_t025.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_test_noise_all_r004_t0125.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True
# bash tools/dist_test.sh plugin/configs/maptracker/av2_oldsplit/stage3_test_noise_all_r002_t00625.py work_dirs/maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune/latest.pth 8 --eval --eval-options save_semantic=True


# Evaluation with C-mAP (TODO: debug this part. what went wrong?)
# exp_name=maptracker_argoverse2_geosplit_5frame_span10_stage3_joint_finetune
# exp_name=stage3_v3
# exp_name=stage3_v2
# exp_name=stage3_v4

# exp_name=stage3_v5
# exp_name=stage3_v6
# exp_name=stage3_v7
# exp_name=stage3_v8
# exp_name=stage3_v9
# exp_name=stage3_v10
exp_name=stage3_v11
CUDA_VISIBLE_DEVICES=1 python tools/tracking/prepare_pred_tracks.py plugin/configs/maptracker/av2_oldsplit/${exp_name}.py --result_path ./work_dirs/${exp_name}/submission_vector.json
CUDA_VISIBLE_DEVICES=1 python tools/tracking/calculate_cmap.py plugin/configs/maptracker/av2_oldsplit/${exp_name}.py --result_path ./work_dirs/${exp_name}/pos_predictions_5.pkl

# exp_name=maptracker_nusc_oldsplit_5frame_span10_stage3_joint_finetune
# python tools/tracking/prepare_pred_tracks.py plugin/configs/maptracker/nuscenes_oldsplit/${exp_name}.py --result_path ./work_dirs/${exp_name}/submission_vector.json
# python tools/tracking/calculate_cmap.py plugin/configs/maptracker/nuscenes_oldsplit/${exp_name}.py --result_path ./work_dirs/${exp_name}/pos_predictions_5.pkl