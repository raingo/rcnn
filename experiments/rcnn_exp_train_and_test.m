function [res_test, res_train, rcnn_model] = rcnn_exp_train_and_test()
% Runs an experiment that trains an R-CNN model and tests it.

% -------------------- CONFIG --------------------
voc_config = get_cur_voc_name();
net_file = voc_config.net_file;
cache_name = voc_config.cache_name;
crop_mode    = voc_config.crop_mode;
crop_padding = voc_config.crop_padding;
name = voc_config.name;

layer        = 7;
k_folds      = 0;

% change to point to your VOCdevkit install
VOCdevkit = './datasets/VOCdevkit2007';
% ------------------------------------------------

train_set = 'train';
imdb_train = imdb_from_voc(VOCdevkit, train_set, name);
imdb_test = imdb_from_voc(VOCdevkit, 'val', name);

model_save_path = fullfile('data', 'rcnn_models', name, cache_name, sprintf('rcnn_model-%s-%s-%d-%d-%d.mat', train_set, crop_mode, crop_padding, layer, k_folds));
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
