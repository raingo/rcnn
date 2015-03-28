
[base_res_test, base_res_train] = rcnn_exp_train_and_test;
%bb_res = rcnn_exp_bbox_reg_train_and_test;


fprintf('base_res_test: \n');
AP = cell2mat({base_res_test.ap})
mean(AP)

fprintf('base_res_train: \n');
AP = cell2mat({base_res_train.ap})
mean(AP)

%fprintf('bb_res: \n');
%bb_res

email_notify(sprintf('%s Done', mfilename));
