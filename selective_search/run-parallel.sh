#!/bin/bash
# vim ft=sh

tmp_dir=$1
n_tasks=`cat $tmp_dir/tasks.list | wc -l`
n_processes=$n_tasks

seq $n_tasks | parallel --ungroup -j$n_processes ./selective_search/parallal_sub.sh $tmp_dir
