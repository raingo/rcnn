#!/bin/bash
# vim ft=sh


tmp_dir=$1
worker_id=$2

matlab --singleCompThread <<< "worker_id = $worker_id; base_dir = '$tmp_dir'; parallel_sub;" &> $tmp_dir/parallel-$worker_id.log
