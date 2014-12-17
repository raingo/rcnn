function rec = VOCreadrecxml(VOCopts, path)

x=VOCreadxml(path);
x=x.annotation;

if ~isfield(x.size, 'depth')
    x.size.depth = '0';
end

if ~isfield(x, 'segmented')
    x.segmented = '0';
end

if ~isfield(x, 'object')
    x.object = [];
end

rec=rmfield(x,'object');

rec.size.width=str2double(rec.size.width);
rec.size.height=str2double(rec.size.height);
rec.size.depth=str2double(rec.size.depth);

rec.segmented=strcmp(rec.segmented,'1');

rec.imgname=[x.folder '/JPEGImages/' x.filename];
rec.imgsize=str2double({x.size.width x.size.height x.size.depth});
rec.database=rec.source.database;

tmp_obj = [];
tmp_obj.name = '';
tmp_obj.bndbox.xmin = 0;
tmp_obj.bndbox.ymin = 0;
tmp_obj.bndbox.xmax = 0;
tmp_obj.bndbox.ymax = 0;
objects = repmat(xmlobjtopas(tmp_obj), 0, 1);

for i=1:length(x.object)

    if ~isempty(VOCopts) && ~ismember(x.object(i).name, VOCopts.classes)
        continue
    end
    objects = [objects xmlobjtopas(x.object(i))];
end

rec.objects = objects;

function p = xmlobjtopas(o)

p.class=o.name;

if isfield(o,'pose')
    if strcmp(o.pose,'Unspecified')
        p.view='';
    else
        p.view=o.pose;
    end
else
    p.view='';
end

if isfield(o,'truncated')
    p.truncated=strcmp(o.truncated,'1');
else
    p.truncated=false;
end

if isfield(o,'difficult')
    p.difficult=strcmp(o.difficult,'1');
else
    p.difficult=false;
end

p.label=['PAS' p.class p.view];
if p.truncated
    p.label=[p.label 'Trunc'];
end
if p.difficult
    p.label=[p.label 'Difficult'];
end

p.orglabel=p.label;

p.bbox=str2double({o.bndbox.xmin o.bndbox.ymin o.bndbox.xmax o.bndbox.ymax});

p.bndbox.xmin=str2double(o.bndbox.xmin);
p.bndbox.ymin=str2double(o.bndbox.ymin);
p.bndbox.xmax=str2double(o.bndbox.xmax);
p.bndbox.ymax=str2double(o.bndbox.ymax);

if isfield(o,'polygon')
    warning('polygon unimplemented');
    p.polygon=[];
else
    p.polygon=[];
end

if isfield(o,'mask')
    warning('mask unimplemented');
    p.mask=[];
else
    p.mask=[];
end

if isfield(o,'part')&&~isempty(o.part)
    p.hasparts=true;
    for i=1:length(o.part)
        p.part(i)=xmlobjtopas(o.part(i));
    end
else
    p.hasparts=false;
    p.part=[];
end

