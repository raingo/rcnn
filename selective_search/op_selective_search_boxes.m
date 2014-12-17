function result = op_selective_search_boxes(first_el, last_el, imdb)
% result = op_selective_search_boxes(first_el, last_el, imdb)
%
% Loop slice operation for distributed computation of selective search
% boxes.
%
% This function depends on simple-cluster-lib, which is specific to 
% the Berkeley cluster and not useful to the general public (and 
% hence not available). This file exists because it's convenient for 
% me to keep it in the repository.
%
% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Ross Girshick
% 
% This file is part of the R-CNN code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

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
