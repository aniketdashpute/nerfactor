## Run this script only once (when you download the repo),
## Don't have to do it again ever

proj_root='/mnt/WD6TB/adashpute/nerfactor'
repo_dir="$proj_root"
indir="$proj_root/data/brdf_merl/brdfs"
ims='512'
outdir="$proj_root/data/brdf_merl_npz/ims${ims}_envmaph16_spp1"
REPO_DIR="$repo_dir" bash "$repo_dir"/data_gen/merl/make_dataset_run.sh "$indir" "$ims" "$outdir"