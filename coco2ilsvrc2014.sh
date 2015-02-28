#!/bin/bash
# vim ft=sh

coco_dir=`pwd`/datasets/COCO
ilsvrc_dir=$coco_dir/ILSVRC2014

mkdir -p $ilsvrc_dir

rm -Rf $ilsvrc_dir/ILSVRC2014_DET_train
rm -Rf $coco_dir/val2014 $ilsvrc_dir/ILSVRC2013_DET_val
rm -Rf $ilsvrc_dir/ILSVRC2014_DET_bbox_train/
rm -Rf $ilsvrc_dir/ILSVRC2013_DET_bbox_val/
rm -Rf $ilsvrc_dir/ILSVRC2014_devkit/data/det_lists

ln -s $coco_dir/train2014 $ilsvrc_dir/ILSVRC2014_DET_train
ln -s $coco_dir/val2014 $ilsvrc_dir/ILSVRC2013_DET_val

mkdir -p $ilsvrc_dir/ILSVRC2014_DET_bbox_train
mkdir -p $ilsvrc_dir/ILSVRC2013_DET_bbox_val
mkdir -p $ilsvrc_dir/ILSVRC2014_devkit/data/det_lists


python coco2ilsvrc2014.py $coco_dir/instances_train2014.json $ilsvrc_dir/ILSVRC2014_DET_bbox_train train $ilsvrc_dir/ILSVRC2014_devkit/data/
python coco2ilsvrc2014.py $coco_dir/instances_val2014.json $ilsvrc_dir/ILSVRC2013_DET_bbox_val val $ilsvrc_dir/ILSVRC2014_devkit/data/
