function [images, boxes] = selective_search_boxes_local(imdb)


if matlabpool('size') == 0
    matlabpool 4
end

boxes = op_selective_search_boxes(1, length(imdb.image_ids), imdb);
images = imdb.image_ids;
