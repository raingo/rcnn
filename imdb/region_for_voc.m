function region_for_voc(imdb, save_path)

[images, boxes] = selective_search_boxes_local(imdb);
save_dir = fileparts(save_path);
mkdir_if_missing(save_dir);
save(save_path, 'boxes', 'images');

end
