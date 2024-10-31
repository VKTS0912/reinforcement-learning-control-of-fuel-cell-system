function [state_new,D] = DoAction(state,action,T,lambda,D,R_L)
% Real state, not discretized state
% State include 2 element state = [V_fc,I_fc]
% D is duty cycle

V_fc = state(1);
I_fc = state(2);

% Change duty cycle
D = D + action;
if D > 0.99
    D = 0.99;
end
if D < 0
    D = 0;
end

%find new operating point
f = @(I_fc) diff_func(I_fc,T,lambda,D,R_L);
I_fc_new = fsolve(f,370);
V_fc_new = I_fc_new*R_L*((1-D)*(1-D));
state_new = [V_fc_new,I_fc_new];