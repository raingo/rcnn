

load meta_det.mat

fid = fopen('meta-det.txt', 'w');

for i = 1:length(synsets)
    fprintf(fid, '%d\t%s\t%s\n', synsets(i).ILSVRC2013_DET_ID, synsets(i).WNID, synsets(i).name);
end
fclose(fid);
