function [res_test, res_train, rcnn_model] = rcnn_exp_train_and_test()
% Runs an experiment that trains an R-CNN model and tests it.

% -------------------- CONFIG --------------------
net_file     = './data/caffe_nets/finetune_voc_2007_trainval_iter_70k';
cache_name   = 'v1_finetune_voc_2007_trainval_iter_70k';
crop_mode    = 'warp';
crop_padding = 16;
layer        = 7;
k_folds      = 0;

% change to point to your VOCdevkit install
VOCdevkit = './datasets/VOCdevkit2007';
% ------------------------------------------------

%name = 'sanity-check';
name = get_cur_voc_name();
imdb_train = imdb_from_voc(VOCdevkit, 'trainval', name);
% imdb_test = imdb_from_voc(VOCdevkit, 'test', name);
imdb_test = imdb_from_voc(VOCdevkit, 'val', name);

model_save_path = fullfile('data', 'rcnn_models', name, sprintf('rcnn_model-%s-%d-%d-%d.mat', crop_mode, crop_padding, layer, k_folds));
model_dir = fileparts(model_save_path);
mkdir_if_missing(model_dir);

if exist(model_save_path, 'file')
    clear rcnn_model rcnn_k_fold_model
    load(model_save_path);
else
    [rcnn_model, rcnn_k_fold_model] = ...
    rcnn_train(imdb_train, ...
    'layer',        layer, ...
    'k_folds',      k_folds, ...
    'cache_name',   cache_name, ...
    'net_file',     net_file, ...
    'crop_mode',    crop_mode, ...
    'crop_padding', crop_padding);
    save(model_save_path, 'rcnn_model', 'rcnn_k_fold_model');
end

if k_folds > 0
    res_train = rcnn_test(rcnn_k_fold_model, imdb_train);
else
    res_train = [];
end

res_test = rcnn_test(rcnn_model, imdb_test);
