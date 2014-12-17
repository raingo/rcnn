function VOCopts = get_voc_opts(path, name)

tmp = pwd;
cd(path);
try
  addpath('VOCcode');
  mode = name;
  VOCinit;
catch ME
  rmpath('VOCcode');
  cd(tmp);
  error(sprintf('VOCcode directory not found under %s, %s', path, ME.message));
end
rmpath('VOCcode');
cd(tmp);
