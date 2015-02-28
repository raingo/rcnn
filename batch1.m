

if matlabpool('size') == 0
matlabpool 3
end
caffe('set_device', 1);
rcnn_exp_cache_features('train');
%rcnn_exp_cache_features('val');
%rcnn_exp_cache_features('val');
%rcnn_exp_cache_features('test_1');
%rcnn_exp_cache_features('test_2');
do_train;
%email_notify(sprintf('rcnn cache features done: %s', mfilename));
