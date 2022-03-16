## Required only once for BRDF priors

gpus='0'

# I. Learning BRDF Priors (training and validation)
proj_root='/mnt/WD6TB/adashpute/nerfactor/'
#proj_root='/data/vision/billf/intrinsic/sim'
repo_dir="$proj_root"
data_root="$proj_root/data/brdf_merl_npz/ims512_envmaph16_spp1"
outroot="$proj_root/output/train/merl"
viewer_prefix= "" #'http://vision38.csail.mit.edu' # or just use ''
#REPO_DIR="$repo_dir" bash "$repo_dir/nerfactor/trainvali_run.sh" "$gpus" --config='brdf.ini' --config_override="data_root=$data_root,outroot=$outroot,viewer_prefix=$viewer_prefix"

# II. Exploring the Learned Space (validation and testing)
ckpt="$outroot/lr1e-2/checkpoints/ckpt-22"
REPO_DIR="$repo_dir" bash "$repo_dir/nerfactor/explore_brdf_space_run.sh" "$gpus" --ckpt="$ckpt"