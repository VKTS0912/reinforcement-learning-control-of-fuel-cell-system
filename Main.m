function [P_save] = Main(scenario, i, T_lambda_testcase, max_test, P_ref)

%algorithm parameter
alpha       = 0.6;   % learning rate
gamma       = 0.9;   % discount factor
e_num_max   = 15;
R_L = 50;
%build state list, actionlist
state_list = BuildStateList;
action_list = BuildActionList;

%initialize QTable
n_state = size(state_list,1);
n_action = size(action_list,1);
Q = zeros(n_state,n_action);

e_num = zeros(size(Q,1),1);

%IMPLEMENT ALGORITHM
%plot I-V curve of PV source and P_max operation point reference

switch scenario
    case 1
        max_steps = 2000*size(T_lambda_testcase, 2);
        figure_num = 2;
        figure(figure_num)
        P_save = EpisodeTest1(i, max_steps,state_list,action_list,Q,e_num,e_num_max,alpha,gamma,figure_num,R_L, T_lambda_testcase, max_test, P_ref);
end

