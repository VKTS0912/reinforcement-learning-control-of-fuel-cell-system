function [action_list] = BuildActionList
% Action is the change of the DC/DC converter duty cycle D
action_list = [-0.6;-0.02;-0.0002;0;0.0002;0.02;0.6];

filename = "q_result/x10action_list.mat";
save(filename);