function VOCopts = get_voc_opts(path, name)

    tmp = pwd;
    cd(path);
    addpath('VOCcode');
    mode = name;
    VOCinit;
    rmpath('VOCcode');
    cd(tmp);
