
base_res = rcnn_exp_train_and_test;
bb_res = rcnn_exp_bbox_reg_train_and_test;


fprintf('base_res: \n');
base_res

fprintf('bb_res: \n');
bb_res

email_notify(sprintf('%s Done', mfilename));
