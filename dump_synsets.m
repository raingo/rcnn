

base_dir = 'datasets/ILSVRC2014/ILSVRC2014_devkit/data/'
load(fullfile(base_dir, 'meta_det.mat'));

fid = fopen(fullfile(base_dir, 'meta-det.txt'), 'w');

for i = 1:length(synsets)
    fprintf(fid, '%d\t%s\t%s\n', synsets(i).ILSVRC2013_DET_ID, synsets(i).WNID, synsets(i).name);
end
fclose(fid);
