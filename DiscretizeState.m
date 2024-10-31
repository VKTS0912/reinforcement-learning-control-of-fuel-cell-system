% Find the closest state in state_list to the given state by calculating the Euclidean distances
% between them and returning the index of the closest state. This function is used to 
% map or discretize continuous states into discrete states based on their proximity in Euclidean space
function [state_index] = DiscretizeState(state,state_list)

di = [];
for i = 1:size(state_list,1)   % i = from 1 to the number of rows in state_list matrix
    t = sqrt(sum((state_list(i,:) - state).^2));  % access elements in row i of state_list
    di = [di;t];
end

[d,state_index] = min(di);  % Stores the min value of array di and its index
