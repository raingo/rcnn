function res = imdb_vis_det(imdb)

    comp_id = 'comp4';

    VOCopts  = imdb.details.VOCopts;
    test_set = VOCopts.testset;

    addpath(fullfile(VOCopts.rootdir, 'VOCcode'));
    addpath(VOCopts.rootdir);

    %for i = 1:length(VOCopts.classes)
    i = 1;
    viewdet(VOCopts, VOCopts.classes{i}, comp_id);
    %end

    rmpath(VOCopts.rootdir);
    rmpath(fullfile(VOCopts.rootdir, 'VOCcode'));
