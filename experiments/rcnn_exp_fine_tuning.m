
VOCdevkit = './datasets/VOCdevkit2007';

voc_config = get_cur_voc_name();
net_file = voc_config.net_file;
cache_name = voc_config.cache_name;
crop_mode    = voc_config.crop_mode;
crop_padding = voc_config.crop_padding;
name = voc_config.name;

train_set = 'train';
val_set = 'val';
imdb_train = imdb_from_voc(VOCdevkit, train_set, name);
imdb_val = imdb_from_voc(VOCdevkit, val_set, name);

save_dir = fullfile('external/caffe/examples/finetune_pascal_detection/', name);
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

try
    rcnn_make_window_file(imdb_train, save_dir);
    rcnn_make_window_file(imdb_val, save_dir);
catch ME
    fprintf('Error: %s', ME.message);
    for i = 1:length(ME.stack)
        disp(ME.stack(i));
    end
end
diary off

email_notify(sprintf('%s finished', mfilename));
