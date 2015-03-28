function viewdet(VOCopts,cls,comp_id,onlytp)

if nargin<3
    error(['usage: viewdet(class,onlytp) e.g. viewdet(' 39 'car' 39 ') or ' ...
            'viewdet(' 39 'car' 39 ',true) to show true positives']);
end

if nargin<4
    onlytp=false;
end

% load test set
[gtids,t]=textread(sprintf(VOCopts.imgsetpath,VOCopts.testset),'%s %d');

% load ground truth objects
gt_cache_dir = fullfile(VOCopts.resdir, 'gt-cache');

if ~exist(gt_cache_dir, 'dir')
    mkdir(gt_cache_dir);
end

gt_cache_path = fullfile(gt_cache_dir, [cls '.mat']);
try
    load(gt_cache_path);
catch

    tic;
    npos=0;
    for i=1:length(gtids)
        % display progress
        if toc>1
            fprintf('%s: viewdet: load: %d/%d\n',cls,i,length(gtids));
            drawnow;
            tic;
        end

        % read annotation
        rec=PASreadrecord(sprintf(VOCopts.annopath,gtids{i}));

        % extract objects of class
        clsinds=strmatch(cls,{rec.objects(:).class},'exact');
        gt(i).BB=cat(1,rec.objects(clsinds).bbox)';
        gt(i).diff=[rec.objects(clsinds).difficult];
        gt(i).det=false(length(clsinds),1);
        npos=npos+sum(~gt(i).diff);
    end

    save(gt_cache_path, 'npos', 'gt');
end

res_pattern = sprintf(VOCopts.detrespath, [comp_id '-*'], VOCopts.testset, cls);
res_path = dir(res_pattern);

res_path = fullfile(VOCopts.resdir, 'Main', res_path(1).name);

% load results
[ids,confidence,b1,b2,b3,b4]=textread(res_path,'%s %f %f %f %f %f');
BB=[b1 b2 b3 b4]';

% sort detections by decreasing confidence
[sc,si]=sort(-confidence);
ids=ids(si);
BB=BB(:,si);

% view detections
nd=length(confidence);
tic;
for d=1:nd
    % display progress
    if onlytp&toc>1
        fprintf('%s: viewdet: find true pos: %d/%d\n',cls,i,length(gtids));
        drawnow;
        tic;
    end

    % find ground truth image
    i=strmatch(ids{d},gtids,'exact');
    if isempty(i)
        error('unrecognized image "%s"',ids{d});
    elseif length(i)>1
        error('multiple image "%s"',ids{d});
    end

    % assign detection to ground truth object if any
    bb=BB(:,d);
    ovmax=-inf;
    for j=1:size(gt(i).BB,2)
        bbgt=gt(i).BB(:,j);
        bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
        iw=bi(3)-bi(1)+1;
        ih=bi(4)-bi(2)+1;
        if iw>0 & ih>0
            % compute overlap as area of intersection / area of union
            ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
               (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
               iw*ih;
            ov=iw*ih/ua;
            if ov>ovmax
                ovmax=ov;
                jmax=j;
            end
        end
    end

    % skip false positives
    if onlytp&ovmax<VOCopts.minoverlap
        continue
    end

    fprintf('%s\n', gtids{i});

    % read image
    I=imread(sprintf(VOCopts.imgpath,gtids{i}));

    % draw detection bounding box and ground truth bounding box (if any)
    imagesc(I);
    hold on;
    if ovmax>=VOCopts.minoverlap
        bbgt=gt(i).BB(:,jmax);
        plot(bbgt([1 3 3 1 1]),bbgt([2 2 4 4 2]),'y-','linewidth',2);
        plot(bb([1 3 3 1 1]),bb([2 2 4 4 2]),'g:','linewidth',2);
    else
        plot(bb([1 3 3 1 1]),bb([2 2 4 4 2]),'r-','linewidth',2);
    end
    hold off;
    axis image;
    axis off;
    title(sprintf('det %d/%d: image: "%s" (green=true pos,red=false pos,yellow=ground truth',...
            d,nd,gtids{i}), 'Interpreter', 'none');

    fprintf('press any key to continue with next image\n');
    pause;
end
