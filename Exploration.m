function Q = Exploration(state_index,state_list,action_list,Q,e_num_max,alpha,gamma,T_pv,G_pv,R_L,D)

    state = state_list(state_index,:);
    
    for i = 1:length(action_list)
        % Choose random action
        action_index = i;

        % Do action
        action = action_list(action_index);
        [state_new,D] = DoAction(state,action,D,R_L,T_pv,G_pv);
        state_new_index = DiscretizeState(state_new,state_list);

        % Caculate reward
        P = state(1)*state(2);
        P_new = state_new(1)*state_new(2);
        reward = TakeReward(P,P_new);
        
        % Update Q
        Q(state_index,action_index) = Q(state_index,action_index) + alpha*(reward + gamma*max(Q(state_new_index,:)) - Q(state_index,action_index));
    end
