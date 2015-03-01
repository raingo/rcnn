
voc_config = get_cur_voc_name();
name = voc_config.name;

% change to point to your VOCdevkit install
VOCdevkit = './datasets/VOCdevkit2007';
% ------------------------------------------------
imdb_test = imdb_from_voc(VOCdevkit, 'val', name);
imdb_vis_det(imdb_test);
