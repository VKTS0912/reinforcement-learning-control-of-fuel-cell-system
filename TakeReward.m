function [reward] = TakeReward(P,P_new)
delta_P = P_new - P;

w_p = 4;
w_n = 1;

if(delta_P < 0)
    reward = w_p*delta_P;
else
    reward = w_n*delta_P;    
end
