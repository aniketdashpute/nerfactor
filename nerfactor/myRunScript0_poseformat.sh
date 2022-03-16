## This script should be run once you get the poses file (poses_output.npy) from LLFF (using COLMAP)
## Give the path of that folder here and then this script will convert it into required format

scene='cat2'
proj_root='/mnt/WD6TB/adashpute/nerfactor'
# proj_root='/data/vision/billf/intrinsic/sim'
repo_dir="$proj_root"
# repo_dir="$proj_root/code/nerfactor"
scene_dir="$proj_root/../LLFF/data/$scene"
h='256'
n_vali='2'
outroot="$proj_root/data/cat2_proc/${scene}"
REPO_DIR="$repo_dir" bash "$repo_dir/data_gen/nerf_real/make_dataset_run.sh" --scene_dir="$scene_dir" --h="$h" --n_vali="$n_vali" --outroot="$outroot"