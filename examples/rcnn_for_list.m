

model_file='./data/rcnn_models/coco-full-100/coco_2014_full-100/rcnn_model-train-wrap-16-7-0.mat';
binary_file ='./data/models/coco-full-100/finetune-80K_iter_80000.caffemodel';
definition_file ='./model-defs/rcnn_batch_256_output_fc7.prototxt';
image_path_list = './data/images';
save_path = [image_path_list, '.boxes'];

use_gpu = true;
thresh = -1;

% Initialization only needs to happen once (so this time isn't counted
% when timing detection).
fprintf('Initializing R-CNN model (this might take a little while)\n');
clear rcnn_model
load(model_file);
rcnn_model.cnn.definition_file = definition_file;
rcnn_model.cnn.binary_file = binary_file;
rcnn_model = rcnn_load_model(rcnn_model, use_gpu);
fprintf('done\n');

fid = fopen(image_path_list);
fields = textscan(fid, '%s');
fclose(fid);
image_list = fields{1};


tI = tic;
for ii = 1:length(image_list)
    ti = tic;
    im_path = image_list{ii};
    try
        im = imread(im_path);
    catch ME
        warning(ME.message);
        continue
    end

    th = tic;
    dets = rcnn_detect(im, rcnn_model, thresh);
    fprintf('Total %d-class detection time: %.3fs\n', ...
        length(rcnn_model.classes), toc(th));
    all_dets = [];
    for i = 1:length(dets)
        all_dets = cat(1, all_dets, ...
            [i * ones(size(dets{i}, 1), 1) dets{i}]);
    end
    all_dets = all_dets(all_dets(:, end) > 0, :);
    size(all_dets)

    [~, ord] = sort(all_dets(:,end), 'descend');

    if size(all_dets, 1) > 0

        fid = fopen(save_path, 'a');
        for i = 1:length(ord)
            score = all_dets(ord(i), end);
            if score < 0
                break;
            end
            cls = rcnn_model.classes{all_dets(ord(i), 1)};
            cls_box = all_dets(ord(i), 2:end);
            fprintf(fid, '%s\t%s\t%g\t%g\t%g\t%g\t%g\n', im_path, cls, cls_box(1), cls_box(2), cls_box(3), cls_box(4), cls_box(5));
            showboxes(im, all_dets(ord(i), 2:5));
        end
        fclose(fid);
    end

    fprintf('%d %d %.3fs %.3fs\n', ii, length(image_list), toc(ti), toc(tI));
end

email_notify(sprintf('%s Done', mfilename));
