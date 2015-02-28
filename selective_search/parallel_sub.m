
% base_dir
% worker_id [from 0]

tasks = dlmread(fullfile(base_dir, 'tasks.list'));
first_el = tasks(worker_id, 1);
last_el = tasks(worker_id, 2);

load(fullfile(base_dir, 'imdb.mat'));

result = op_selective_search_boxes(first_el, last_el, imdb);

result_path = fullfile(base_dir, sprintf('result-%d.mat', worker_id));
save(result_path, 'result', 'first_el', 'last_el');
