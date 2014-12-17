function region_for_voc(imdb, save_path)

[images, boxes] = selective_search_boxes_local(imdb);
save(save_path, 'boxes', 'images');

end
