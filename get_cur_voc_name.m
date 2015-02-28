
function voc_config = get_cur_voc_name()
    voc_confg = [];
    voc_config.name = 'exp-baseline';
    % voc_config.name = 'sanity-check';


    %voc_config.net_file     = './external/caffe/examples/finetune_pascal_detection/finetune_exp-baseline_train-iter-80K_iter_80000.caffemodel';
    %voc_config.cache_name   = 'v1_finetune_voc_exp-baseline_train_iter_80k';

    voc_config.net_file     = './external/caffe/examples/finetune_pascal_detection/ilsvrc_2012_train_iter_310k/finetune_exp-baseline_train-iter-80K_iter_80000.caffemodel';
    voc_config.cache_name   = 'ilsvrc12_finetune_exp_baseline_train_iter_80k';

    %voc_config.net_file     = './data/caffe_nets/ilsvrc_2012_train_iter_310k';
    %voc_config.cache_name   = 'ilsvrc_2012_train_iter_310k';


    %voc_config.net_file     = './data/caffe_nets/finetune_ilsvrc13_val1+train1k_iter_50000';
    %voc_config.cache_name   = 'finetune_ilsvrc13_val1+train1k_iter_50000';

    %voc_config.net_file     = './data/caffe_nets/finetune_voc_2007_trainval_iter_70k';
    %voc_config.cache_name   = 'v1_finetune_voc_2007_trainval_iter_70k';
    % voc_config.net_file     = './data/caffe_nets/finetune_sanity-check_trainval_iter_1000.caffemodel';
    % voc_config.cache_name   = 'v1_finetune_sanity-check_train_iter_1000';

    voc_config.crop_mode = 'wrap';
    voc_config.crop_padding = 16;

end
