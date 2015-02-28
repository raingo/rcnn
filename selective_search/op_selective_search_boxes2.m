%function result = op_selective_search_boxes(first_el, last_el, imdb)

%imdb_path
%first_el
%last_el
%worker_id

load(imdb_path);

fast_mode = true;

result = cell(last_el-first_el+1, 1);
parfor i_ = 1:last_el-first_el+1
  i = i_ + first_el - 1;
  % i_ = i-first_el+1;

  fprintf('%d/%d (%s) ...', i, last_el, imdb.image_ids{i});
  im = imread(imdb.image_at(i));
  th = tic();
  result{i_} = selective_search_boxes(im, fast_mode);
  t = toc(th);

  fprintf('%d %.2f\n', i_, t);
 end

save(
