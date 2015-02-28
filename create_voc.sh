
#base_dir=`pwd`/datasets/ILSVRC2014
base_dir=`pwd`/datasets/COCO/ILSVRC2014

#name=coco-baseline
name=coco-full-100
#name=sanity-check

output_dir=`pwd`/datasets/VOCdevkit2007/data/$name

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

max_pos=100
neg_to_pos_ratio=7

if [ 1 == 1 ]
then

    # train set
    for cls in `cat $output_dir/cls-list.txt`
    do
        cls_id=`cat $meta_det_txt | grep -P "$cls\t" | awk -F'\t' '{print $1}'`
        cat $det_lists_dir/train_pos_$cls_id.txt | sort -R | head -$max_pos >> $sets_dir/train.$cls_id.txt
        n_pos=`cat $sets_dir/train.$cls_id.txt | wc -l`
        n_neg=`echo $n_pos '*' $neg_to_pos_ratio | bc`
        echo $cls $cls_id $n_pos $n_neg
        echo "ignore negative images"
        #cat $det_lists_dir/train_neg_$cls_id.txt | sort -R  | head -$n_neg >> $sets_dir/train.txt
        cat $sets_dir/train.$cls_id.txt >> $sets_dir/train.txt
    done

    cat $sets_dir/train.txt | sort | uniq > $sets_dir/train-uniq.txt
    cat $sets_dir/train-uniq.txt | sort -R > $sets_dir/train.txt

    echo linking train set
    ./link_files.sh $base_dir/ILSVRC2014_DET_train $sets_dir/train.txt jpg $jpg_dir
    ./link_files.sh $base_dir/ILSVRC2014_DET_bbox_train $sets_dir/train.txt xml $anno_dir #2>&1 /dev/null

fi

# val set
echo generating val set

cls_list="dummy"

for cls in `cat $output_dir/cls-list.txt`
do
    cls_list=$cls_list"\|"$cls
done

echo $cls_list

python remove_blacklist.py $det_lists_dir/../ILSVRC2014_det_validation_blacklist.txt $det_lists_dir/val.txt  > $sets_dir/val-val.txt

n_cls=`cat $output_dir/cls-list.txt | wc -l`
max_val_pos=`echo $max_pos '*' $n_cls | bc`
echo $max_val_pos

cat $sets_dir/val-val.txt | xargs -L 1 -I {} grep -l "$cls_list" $base_dir/ILSVRC2013_DET_bbox_val/'{}'.xml | sort -R |head -$max_val_pos |xargs -L 1 basename | rev | cut -c 5- | rev > $sets_dir/val-pos.txt
n_pos=`cat $sets_dir/val-pos.txt | wc -l`
n_neg=`echo $n_pos '*' $neg_to_pos_ratio | bc `

echo val $n_pos $n_neg

cat $sets_dir/val-val.txt | xargs -L 1 -I {} grep -L "$cls_list" $base_dir/ILSVRC2013_DET_bbox_val/'{}'.xml | sort -R | head -$n_neg | xargs -L 1 basename | rev | cut -c 5- | rev > $sets_dir/val-neg.txt

cat $sets_dir/val-pos.txt $sets_dir/val-neg.txt > $sets_dir/val.txt
echo linking val set

./link_files.sh $base_dir/ILSVRC2013_DET_val $sets_dir/val.txt jpg $jpg_dir
./link_files.sh $base_dir/ILSVRC2013_DET_bbox_val $sets_dir/val.txt xml $anno_dir #2>&1 /dev/null

# test set
if [ 0 == 1 ]
then
    echo linking test set
    #cat $det_lists_dir/test.txt | awk '{print $1}' | sort -R | head -$n_pos > $sets_dir/test.txt
    ./link_files.sh $base_dir/ILSVRC2013_DET_test $sets_dir/test.txt jpg $jpg_dir
fi

# post-processing
echo post-processing
find $anno_dir -type l -exec test ! -e {} \; -delete
cat $sets_dir/train.txt $sets_dir/val.txt > $sets_dir/trainval.txt
find $sets_dir -type f | xargs -L 1 wc
