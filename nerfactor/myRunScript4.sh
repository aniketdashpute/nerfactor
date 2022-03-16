scene='pinecone'
gpus='2'
# proj_root='/data/vision/billf/intrinsic/sim'
proj_root='/mnt/WD6TB/adashpute/nerfactor/'
# repo_dir="$proj_root/code/nerfactor"
repo_dir="$proj_root"
# viewer_prefix='http://vision38.csail.mit.edu' # or just use ''
viewer_prefix=''

data_root="$proj_root/data/selected/$scene"
if [[ "$scene" == scan* ]]; then
    # DTU scenes
    imh='256'
else
    imh='512'
fi
if [[ "$scene" == ficus* || "$scene" == hotdog_probe_16-00_latlongmap ]]; then
    lr='1e-4'
else
    lr='5e-4'
fi
trained_nerf="$proj_root/output/train/${scene}_nerf/lr$lr"
occu_thres='0.5'

echo "----- Scene is: " $scene " ------"

if [[ "$scene" == pinecone* || "$scene" == scan* ]]; then
    # pinecone and DTU scenes
    scene_bbox='-0.3,0.3,-0.3,0.3,-0.3,0.3'
elif [[ "$scene" == vasedeck* ]]; then
    scene_bbox='-0.2,0.2,-0.4,0.4,-0.5,0.5'
else
    # We don't need to bound the synthetic scenes
    scene_bbox=''
fi
out_root="$proj_root/output/surf/$scene"
mlp_chunk='50000' # bump this up until GPU gets OOM for faster computation
REPO_DIR="$repo_dir" bash "$repo_dir/nerfactor/geometry_from_nerf_run.sh" "$gpus" --data_root="$data_root" --trained_nerf="$trained_nerf" --out_root="$out_root" --imh="$imh" --scene_bbox="$scene_bbox" --occu_thres="$occu_thres" --mlp_chunk="$mlp_chunk"