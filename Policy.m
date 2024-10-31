function [action_index,enum] = Policy(state_index,Q,e_num_max,e_num)

if e_num(state_index) <= e_num_max
    action_index = randi(size(Q,2));
    e_num(state_index) = e_num(state_index) + 1;
else
    [d,action_index] = max(Q(state_index,:));
end

% State_index: represents the index of the current state for which we want to select an action.
% Q: a Q-table (or Q-function) that stores Q-values for state-action pairs. (row is state, column is action) 
% e_num_max: the maximum allowed exploration count, which determines how many times the agent can explore randomly before shifting to exploitation.
% e_num: a counter that keeps track of the number of exploratory actions taken so far.

% if e_num <= e_num_max
%     % Exploration phase: Choose a random action
%     Randomly select an action index:
% size(Q, 2) is the number of columns in the Q-table, which is number of available actions. 
% randi(size(Q, 2)) uses the randi function to generate a random integer within the range from 1 to the number of actions (determined by size(Q, 2)).
%     Increment the exploration count

% else
%     % Exploitation phase: Choose the action with the maximum Q-value for the current state
%     Find the action index with the maximum Q-value
% end