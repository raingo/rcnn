#!/bin/sh
# vim ft=sh

model_dir=./data/rcnn_models/voc_exp-baseline_train/
mkdir -p $model_dir
rm -f $model_dir/*
ln -s /homes/ycli/rcnn_model2.mat $model_dir/rcnn_model.mat
ln -s /homes/ycli/finetune_exp-baseline_train-iter-80K_iter_80000.caffemodel $model_dir

rm -f external/caffe
ln -s /homes/ycli/caffe/ external/
