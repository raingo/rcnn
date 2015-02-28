function region_for_voc(imdb, save_path)

[images, boxes] = selective_search_boxes_local2(imdb);
save_dir = fileparts(save_path);
mkdir_if_missing(save_dir);
save(save_path, 'boxes', 'images','-v7.3');

end
