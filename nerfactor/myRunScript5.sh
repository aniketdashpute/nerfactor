scene='hotdog_2163'
gpus='1'
model='nerfactor'
overwrite='True'
scene='pinecone'
gpus='0'
#proj_root='/data/vision/billf/intrinsic/sim'
proj_root='/mnt/WD6TB/adashpute/nerfactor/'
#repo_dir="$proj_root/code/nerfactor"
repo_dir="$proj_root"
viewer_prefix="" #'http://vision38.csail.mit.edu' # or just use ''

# I. Shape Pre-Training
data_root="$proj_root/data/selected/$scene"
if [[ "$scene" == scan* ]]; then
    # DTU scenes
    imh='256'
else
    imh='512'
fi
if [[ "$scene" == pinecone || "$scene" == vasedeck || "$scene" == scan* ]]; then
    # Real scenes: NeRF & DTU
    near='0.1'; far='2'
else
    near='2'; far='6'
fi
if [[ "$scene" == pinecone || "$scene" == vasedeck || "$scene" == scan* ]]; then
    # Real scenes: NeRF & DTU
    use_nerf_alpha='True'
else
    use_nerf_alpha='False'
fi
surf_root="$proj_root/output/surf/$scene"
shape_outdir="$proj_root/output/train/${scene}_shape"
REPO_DIR="$repo_dir" bash "$repo_dir/nerfactor/trainvali_run.sh" "$gpus" --config='shape.ini' --config_override="data_root=$data_root,imh=$imh,near=$near,far=$far,use_nerf_alpha=$use_nerf_alpha,data_nerf_root=$surf_root,outroot=$shape_outdir,viewer_prefix=$viewer_prefix,overwrite=$overwrite"

# II. Joint Optimization (training and validation)
shape_ckpt="$shape_outdir/lr1e-2/checkpoints/ckpt-2"
brdf_ckpt="$proj_root/output/train/merl/lr1e-2/checkpoints/ckpt-50"
if [[ "$scene" == pinecone || "$scene" == vasedeck || "$scene" == scan* ]]; then
    # Real scenes: NeRF & DTU
    xyz_jitter_std=0.001
else
    xyz_jitter_std=0.01
fi
test_envmap_dir="$proj_root/data/envmaps/for-render_h16/test"
shape_mode='finetune'
outroot="$proj_root/output/train/${scene}_$model"
REPO_DIR="$repo_dir" bash "$repo_dir/nerfactor/trainvali_run.sh" "$gpus" --config="$model.ini" --config_override="data_root=$data_root,imh=$imh,near=$near,far=$far,use_nerf_alpha=$use_nerf_alpha,data_nerf_root=$surf_root,shape_model_ckpt=$shape_ckpt,brdf_model_ckpt=$brdf_ckpt,xyz_jitter_std=$xyz_jitter_std,test_envmap_dir=$test_envmap_dir,shape_mode=$shape_mode,outroot=$outroot,viewer_prefix=$viewer_prefix,overwrite=$overwrite"

# III. Simultaneous Relighting and View Synthesis (testing)
ckpt="$outroot/lr5e-3/checkpoints/ckpt-10"
if [[ "$scene" == pinecone || "$scene" == vasedeck || "$scene" == scan* ]]; then
    # Real scenes: NeRF & DTU
    color_correct_albedo='false'
else
    color_correct_albedo='true'
fi
REPO_DIR="$repo_dir" bash "$repo_dir/nerfactor/test_run.sh" "$gpus" --ckpt="$ckpt" --color_correct_albedo="$color_correct_albedo"