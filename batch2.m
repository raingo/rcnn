
if matlabpool('size') == 0
matlabpool 3
end
caffe('set_device', 0);
rcnn_exp_cache_features('val');
%rcnn_exp_cache_features('test_1');
%rcnn_exp_cache_features('test_2');
