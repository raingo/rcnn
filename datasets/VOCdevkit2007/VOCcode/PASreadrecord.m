function rec = PASreadrecord(path, VOCopts)

if ~exist('VOCopts', 'var')
    VOCopts  = [];
end

if length(path)<4
    error('unable to determine format: %s',path);
end

if strcmp(path(end-3:end),'.txt')
    rec=PASreadrectxt(path);
else
    rec=VOCreadrecxml(VOCopts, path);
end
