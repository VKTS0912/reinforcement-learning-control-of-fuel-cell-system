function [state_list] = BuildStateList

V_fc = 0:0.2:18;
I_fc = 0:5:450;

state_list_index = 1;

% Create a matrix of states:
for i=1:length(V_fc)
    for j=1:length(I_fc)
         state_list(state_list_index,1) = V_fc(i);
         state_list(state_list_index,2) = I_fc(j);
         state_list_index = state_list_index + 1;
        end
    end
end