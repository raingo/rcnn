clear VOCopts

% use VOC2006 or VOC2007 data

% mode = 'VOC2007';
% mode = 'exp-baseline';
if ~exist('mode', 'var')
    mode = 'VOC2007';
end

%
% VOC2006=false; % set true to use VOC2006 data

% dataset

VOCopts.dataset = mode;

% get current directory with forward slashes

cwd=cd;
cwd(cwd=='\')='/';

% change this path to point to your copy of the PASCAL VOC data
VOCopts.datadir=[cwd '/data/'];
VOCopts.rootdir=cwd;

% change this path to a writable directory for your results
VOCopts.resdir=[cwd '/results/' VOCopts.dataset '/'];

% change this path to a writable local directory for the example code
VOCopts.localdir=[cwd '/local/' VOCopts.dataset '/'];

% initialize the test set

% initialize main challenge paths

VOCopts.annopath=[VOCopts.datadir VOCopts.dataset '/Annotations/%s.xml'];

if ~strcmp(mode, 'VOC2007') && ~strcmp(mode, 'VOC2006') && isempty(findstr('coco', mode))
    ext = 'JPEG';
else
    ext = 'jpg';
end

fprintf('ext: %s\n', ext);

VOCopts.imgpath=[VOCopts.datadir VOCopts.dataset '/JPEGImages/%s.' ext ];
VOCopts.imgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Main/%s.txt'];
VOCopts.clsimgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Main/%s_%s.txt'];
VOCopts.detrespath=[VOCopts.resdir 'Main/%s_det_%s_%s.txt'];

% initialize segmentation task paths

VOCopts.seg.clsimgpath=[VOCopts.datadir VOCopts.dataset '/SegmentationClass/%s.png'];
VOCopts.seg.instimgpath=[VOCopts.datadir VOCopts.dataset '/SegmentationObject/%s.png'];

VOCopts.seg.imgsetpath=[VOCopts.datadir VOCopts.dataset '/ImageSets/Segmentation/%s.txt'];

VOCopts.seg.clsresdir=[VOCopts.resdir 'Segmentation/%s_%s_cls'];
VOCopts.seg.instresdir=[VOCopts.resdir 'Segmentation/%s_%s_inst'];
VOCopts.seg.clsrespath=[VOCopts.seg.clsresdir '/%s.png'];
VOCopts.seg.instrespath=[VOCopts.seg.instresdir '/%s.png'];

% initialize the VOC challenge options

switch mode
    case 'VOC2006'
        % VOC2006 classes

        VOCopts.classes={...
        'bicycle'
        'bus'
        'car'
        'cat'
        'cow'
        'dog'
        'horse'
        'motorbike'
        'person'
        'sheep'};

    case 'VOC2007'

        % VOC2007 classes

        VOCopts.classes={...
        'aeroplane'
        'bicycle'
        'bird'
        'boat'
        'bottle'
        'bus'
        'car'
        'cat'
        'chair'
        'cow'
        'diningtable'
        'dog'
        'horse'
        'motorbike'
        'person'
        'pottedplant'
        'sheep'
        'sofa'
        'train'
        'tvmonitor'};

    otherwise
        fid = fopen(fullfile(VOCopts.datadir, VOCopts.dataset,'cls-list.txt'));
        fields = textscan(fid, '%s');
        fclose(fid);
        VOCopts.classes = fields{1};
end

VOCopts.nclasses=length(VOCopts.classes);

VOCopts.poses={...
'Unspecified'
'SideFaceLeft'
'SideFaceRight'
'Frontal'
'Rear'};

VOCopts.nposes=length(VOCopts.poses);

VOCopts.parts={...
'head'
'hand'
'foot'};

VOCopts.maxparts=[1 2 2];   % max of each of above parts

VOCopts.nparts=length(VOCopts.parts);

VOCopts.minoverlap=0.5;

% initialize example options

VOCopts.exannocachepath=[VOCopts.localdir '%s_anno.mat'];

VOCopts.exfdpath=[VOCopts.localdir '%s_fd.mat'];
