#!/bin/sh
# vim ft=sh


base_dir=`pwd`/datasets/ILSVRC2014

find $base_dir -name '*.JPEG' | xargs identify > real-size.txt
find $base_dir -name '*.xml'
