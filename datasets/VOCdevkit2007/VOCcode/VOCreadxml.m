function rec = VOCreadxml(path)

if length(path)>5&&strcmp(path(1:5),'http:')
    xml=urlread(path)';
else
    f=fopen(path,'r');
    xml=fread(f,'*char')';

    if strcmp(xml(1:2), '<?')
        ind = strfind(xml, '?>');
        xml = xml(ind + 2:end);
    end
    fclose(f);
end
rec=VOCxml2struct(xml);
