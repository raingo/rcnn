

src_dir=$1
dst_dir=$2

cd $src_dir
find . -type d | xargs -L 1 -I {} mkdir -p $dst_dir/'{}'
find . -type f | xargs -L 1 -I {} ln -s $src_dir/'{}' $dst_dir/'{}'

