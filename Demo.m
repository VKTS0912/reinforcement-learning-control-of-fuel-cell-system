max_test = 5;
% Temperature and water membrane case:
T_lambda_testcase = [350 333,
                12 15];

P_save = zeros(size(T_lambda_testcase,2), max_test+3);

for i = 1:1:size(T_lambda_testcase,2)
    [P_save(i ,1), h] = Plot_PI_curve_func(T_lambda_testcase(1,i), T_lambda_testcase(2,i));
end

fname = sprintf('q_result/charPlot_all.fig');
savefig(h,fname,'compact');
for i = 1:1:max_test
    
    P_save(:,i+2) = Main(1, i, T_lambda_testcase, max_test, P_save(:, 1));
end

filename = sprintf("q_result/test_x%d.mat", i);

save(filename);

