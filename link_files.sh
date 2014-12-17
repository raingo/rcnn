
base_dir=$1
list=$2
ext=$3
output_dir=$4

cat $list | xargs -L 1 dirname | sort | uniq | xargs -L 1 -I {} mkdir -p $output_dir/'{}'
cat $list | xargs -L 1 -I {} ln -s $base_dir/'{}'.$ext $output_dir/'{}'.$ext

