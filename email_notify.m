function email_notify(msg)
cmd = sprintf('python email_notify.py "%s"', msg);
system(cmd);
end