#!/bin/sh
# vim ft=sh

model_dir=./data/rcnn_models/voc_exp-baseline_train/
ln -s /homes/ycli/rcnn_model2.mat $model_dir/
ln -s /homes/ycli/finetune_exp-baseline_train-iter-80K_iter_80000.caffemodel $model_dir
