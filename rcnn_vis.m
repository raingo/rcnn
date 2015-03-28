
voc_config = get_cur_voc_name();
name = voc_config.name;

% change to point to your VOCdevkit install
VOCdevkit = './datasets/VOCdevkit2007';
% ------------------------------------------------
view_set = 'val';
imdb_test = imdb_from_voc(VOCdevkit, view_set, name);
imdb_test.details.VOCopts.test_set = view_set;
imdb_vis_det(imdb_test);
