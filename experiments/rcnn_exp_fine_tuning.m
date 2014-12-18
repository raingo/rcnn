
VOCdevkit = './datasets/VOCdevkit2007';

name = get_cur_voc_name();
train_set = 'train';
val_set = 'val';
imdb_train = imdb_from_voc(VOCdevkit, train_set, name);
imdb_val = imdb_from_voc(VOCdevkit, val_set, name);

rcnn_make_window_file(imdb_train, 'external/caffe/examples/finetune_pascal_detection');
rcnn_make_window_file(imdb_val, 'external/caffe/examples/finetune_pascal_detection');
