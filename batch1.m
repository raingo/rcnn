

caffe('set_device', 0);
rcnn_exp_cache_features('train');
rcnn_exp_cache_features('val');
%rcnn_exp_cache_features('test_1');
%rcnn_exp_cache_features('test_2');
do_train;
%email_notify(sprintf('rcnn cache features done: %s', mfilename));
