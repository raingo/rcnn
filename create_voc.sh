


base_dir=datasets/ILSVRC2014

#name=exp-baseline
#n_neg=10000
#n_pos=10000000
name=sanity-check
n_neg=100
n_pos=100
output_dir=datasets/VOCdevkit2007/data/$name

sets=(train val test)

cwd=`pwd`

anno_dir=$output_dir/Annotations
sets_dir=$output_dir/ImageSets/Main
jpg_dir=$output_dir/JPEGImages

rm -Rf $anno_dir
rm -Rf $sets_dir
rm -Rf $jpg_dir

mkdir -p $anno_dir
mkdir -p $sets_dir
mkdir -p $jpg_dir

meta_det_txt=$base_dir/ILSVRC2014_devkit/data/meta-det.txt
det_lists_dir=$base_dir/ILSVRC2014_devkit/data/det_lists

# train set
for cls in `cat $output_dir/cls-list.txt` 
do
    cls_id=`cat $meta_det_txt | grep $cls | awk -F'\t' '{print $1}'`
    echo $cls $cls_id
    cat $det_lists_dir/train_pos_$cls_id.txt | sort -R | head -$n_pos >> $sets_dir/train.txt
    cat $det_lists_dir/train_neg_$cls_id.txt | sort -R | head -$n_neg >> $sets_dir/train.txt
done

echo linking train set
./link_files.sh $base_dir/ILSVRC2014_DET_train $sets_dir/train.txt JPEG $jpg_dir
./link_files.sh $base_dir/ILSVRC2014_DET_bbox_train $sets_dir/train.txt xml $anno_dir 2>&1 /dev/null

# val set
echo linking val set
cat $det_lists_dir/val.txt | awk '{print $1}' | sort -R | head -$n_pos > $sets_dir/val.txt
./link_files.sh $base_dir/ILSVRC2013_DET_val $sets_dir/val.txt JPEG $jpg_dir 
./link_files.sh $base_dir/ILSVRC2013_DET_bbox_val $sets_dir/val.txt xml $anno_dir 2>&1 /dev/null

# test set
echo linking test set
cat $det_lists_dir/test.txt | awk '{print $1}' | sort -R | head -$n_pos > $sets_dir/test.txt
./link_files.sh $base_dir/ILSVRC2013_DET_test $sets_dir/test.txt JPEG $jpg_dir

# post-processing
echo post-processing
find $anno_dir -type l -exec test ! -e {} \; -delete
cat $sets_dir/train.txt $sets_dir/val.txt > $sets_dir/trainval.txt


find $sets_dir -type f | xargs wc