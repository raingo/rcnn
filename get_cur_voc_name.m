
function voc_config = get_cur_voc_name()
    voc_confg = [];
    % name = 'exp-baseline';
    voc_config.name = 'sanity-check';

    voc_config.net_file     = './data/caffe_nets/finetune_voc_2007_trainval_iter_70k';
    voc_config.cache_name   = 'v1_finetune_voc_2007_trainval_iter_70k';
    % voc_config.net_file     = './data/caffe_nets/finetune_sanity-check_trainval_iter_1000.caffemodel';
    % voc_config.cache_name   = 'v1_finetune_sanity-check_train_iter_1000';

    voc_config.crop_mode = 'wrap';
    voc_config.crop_padding = 16;

end
