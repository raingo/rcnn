function [images, boxes] = selective_search_boxes_local(imdb)

    n_processes = 6;
    n_tasks = length(imdb.image_ids);

    task_per_process = ceil(n_tasks / n_processes);

    tmp_dir = '/mnt/dp1/ycli-data/parallel-tmp/';

    if ~exist(tmp_dir, 'dir')
        system(sprintf('mkdir -p %s', tmp_dir));
    end


    fid = fopen(fullfile(tmp_dir, 'tasks.list'), 'w');

    for first_el = 1:task_per_process:n_tasks
        fprintf(fid, '%d %d\n', first_el, min(n_tasks, first_el + task_per_process - 1));
    end

    fclose(fid);

    save(fullfile(tmp_dir, 'imdb.mat'), 'imdb');

    system(sprintf('./selective_search/run-parallel.sh %s', tmp_dir));

    boxes = cell(n_tasks, 1);
    images = imdb.image_ids;

    for i = 1:n_processes
        result_path = fullfile(tmp_dir, sprintf('result-%d.mat', i));
        load(result_path);
        boxes(first_el:last_el) = result;
    end
