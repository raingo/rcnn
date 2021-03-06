function rcnn_exp_cache_features(chunk)

% -------------------- CONFIG --------------------
voc_config = get_cur_voc_name();
net_file = voc_config.net_file;
cache_name = voc_config.cache_name;
crop_mode    = voc_config.crop_mode;
crop_padding = voc_config.crop_padding;
name = voc_config.name;

% change to point to your VOCdevkit install
VOCdevkit = './datasets/VOCdevkit2007';
% ------------------------------------------------

%imdb_trainval = imdb_from_voc(VOCdevkit, 'trainval', name);

switch chunk
  case 'train'
    imdb_train = imdb_from_voc(VOCdevkit, 'train', name);
    rcnn_cache_pool5_features(imdb_train, ...
        'crop_mode', crop_mode, ...
        'crop_padding', crop_padding, ...
        'net_file', net_file, ...
        'cache_name', cache_name);
    %link_up_trainval(cache_name, imdb_train, imdb_trainval);
  case 'val'
    imdb_val   = imdb_from_voc(VOCdevkit, 'val', name);
    rcnn_cache_pool5_features(imdb_val, ...
        'crop_mode', crop_mode, ...
        'crop_padding', crop_padding, ...
        'net_file', net_file, ...
        'cache_name', cache_name);
    %link_up_trainval(cache_name, imdb_val, imdb_trainval);
  case 'test_1'
    imdb_test  = imdb_from_voc(VOCdevkit, 'test', name);
    end_at = ceil(length(imdb_test.image_ids)/2);
    rcnn_cache_pool5_features(imdb_test, ...
        'start', 1, 'end', end_at, ...
        'crop_mode', crop_mode, ...
        'crop_padding', crop_padding, ...
        'net_file', net_file, ...
        'cache_name', cache_name);
  case 'test_2'
    imdb_test  = imdb_from_voc(VOCdevkit, 'test', name);
    start_at = ceil(length(imdb_test.image_ids)/2)+1;
    rcnn_cache_pool5_features(imdb_test, ...
        'start', start_at, ...
        'crop_mode', crop_mode, ...
        'crop_padding', crop_padding, ...
        'net_file', net_file, ...
        'cache_name', cache_name);
end


% ------------------------------------------------------------------------
function link_up_trainval(cache_name, imdb_split, imdb_trainval)
% ------------------------------------------------------------------------

cmd = ['./experiments/link_up_trainval.sh ' fullfile(pwd, './feat_cache', cache_name, imdb_split.name) ' ' fullfile(pwd, './feat_cache', cache_name, imdb_trainval.name)];
fprintf('running:\n%s\n', cmd);
system(cmd);
fprintf('done\n');
