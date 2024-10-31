function [P_save] = EpisodeTest1(j, max_steps,state_list,action_list,Q,e_num,e_num_max,alpha,gamma,figure_num,R_L,T_lambda_testcase, max_test, P_ref)

D = 0.9;
%initialize state
T = T_lambda_testcase(1, 1);
lambda = T_lambda_testcase(2, 1);
f = @(I_fc) diff_func(I_fc,T,lambda,D,R_L);
I_fc = fsolve(f,360);
V_fc = I_fc*R_L*((1-D)*(1-D));
state = [V_fc,I_fc];
state_index = DiscretizeState(state,state_list);

total_reward = 0;
count_reward = 0;
count_flag = 1;

p_pre =0;
step_pre =0;
T_osc =0;
T_osc_flag =0; 
cnt_conv =0;
cnt_conv_max = 200;

i_jump=0;
length_jump =200;
i_end =0;
T_pre=0;
lambda_pre =0;
for i = 1:1:max_steps
    if (cnt_conv >= cnt_conv_max) && count_flag < size(T_lambda_testcase, 2)
            count_flag = count_flag + 1;
            cnt_conv =0;
            e_num_max = e_num_max +1;
            R_L = R_L -2;
            i_jump = i;
            i_end = i_jump + length_jump;
            T_pre = T;
            lambda_pre = lambda;
    end
    if(T > T_lambda_testcase(1,count_flag))
        T = ((T_pre - T_lambda_testcase(1,count_flag))/(i_jump-i_end))*(i-i_jump)+T_pre;
    end
    if(lambda < T_lambda_testcase(2,count_flag))
        lambda = ((lambda_pre - T_lambda_testcase(2,count_flag))/(i_jump-i_end))*(i-i_jump)+lambda_pre;
    end
    % Policy
    % Choose action
    if e_num(state_index) <= e_num_max
        % Exploration
        % Choose random action
        action_index = randi(size(Q,2));
        e_num(state_index) = e_num(state_index) + 1;
    else
        % Chose best action
        [~,action_index] = max(Q(state_index,:));
    end
    
    %do action
    action          = action_list(action_index);
    [state_new,D]   = DoAction(state,action,T,lambda,D,R_L);

    %take reward
    P = state(1)*state(2);
    P_new = state_new(1)*state_new(2);
    reward = TakeReward(P,P_new);
    state_new_index = DiscretizeState(state_new,state_list);
    total_reward    = total_reward + reward;


    %update QTable
    Q(state_index,action_index) = Q(state_index,action_index) + alpha*(reward + gamma * max(Q(state_new_index,:)) - Q(state_index,action_index));
    
    state_index = state_new_index;
    state = state_new;
    

    h = figure(figure_num);
    % Plot P_fc
    subplot(3,3,1)
    xpoints(i) = i-1;
    ypoints(i) = P;
    ylabel('P (Watt)')
    plot(xpoints,ypoints)
    title(['P_{fc} = ',num2str(P),' ']);
    % Plot T_fc
    subplot(3,3,2);
    xpoints(i) = i-1;
    ypoints1(i) = T;   
    plot(xpoints,ypoints1)
    title(['T_{fc',num2str(count_flag),'} = ',num2str(T),' ']);
    % Plot lambda
    subplot(3,3,3);
    xpoints(i) = i-1;
    ypoints2(i) = lambda;   
    plot(xpoints,ypoints2)
    title(['lambda_{',num2str(count_flag),'}= ',num2str(lambda),' '])
    % Plot R_load
    subplot(3,3,4)
    xpoints(i) = i-1;
    ypoints3(i) = R_L;
    plot(xpoints,ypoints3)
    title(['R_{load} = ',num2str(ypoints3(i)),' ']);
    % Plot V_fc
    subplot(3,3,5)
    xpoints(i) = i-1;
    ypoints4(i) = state(1);
    ylabel('V_{fc} (Volts)')   
    plot(xpoints,ypoints4)
    title(['V_{fc} ',num2str(ypoints4(i)),' ']);
    % Plot I_fc
    subplot(3,3,6)
    xpoints(i) = i-1;
    ypoints5(i) = state(2);
    ylabel('I_{fc} (Amperes)')   
    plot(xpoints,ypoints5)
    title(['I_{fc} = ',num2str(ypoints5(i)),' ']);
    % Plot Total reward
    subplot(3,3,7);
    xpoints(i) = i-1;
    ypoints6(i) = total_reward;   
    plot(xpoints,ypoints6)
    title('Total reward')
    % Plot Duty cycle
    subplot(3,3,8);
    xpoints(i) = i-1;
    ypoints7(i) = D;   
    plot(xpoints,ypoints7)
    title(['Duty cycle = ',num2str(D),' '])
    % Plot differences between P_fc and P_max
    subplot(3,3,9)
    xpoints(i) = i-1;
    ypoints8(i) = P-P_ref(count_flag);   
    plot(xpoints,ypoints8)
    title(['P_{fc} - P_{max = ',num2str(P_ref(count_flag)), '} = ',num2str(ypoints8(i))]);

    drawnow

% Condition of convergence
    if p_pre == P
        if T_osc == i - step_pre
            cnt_conv = cnt_conv +1;
            step_pre = i;   
        else
            if(T_osc_flag < 1)
                T_osc_flag = T_osc_flag + 1;
            else
                T_osc = i - step_pre;
                cnt_conv = 0;
                T_osc_flag = 0;
                step_pre = i;   
            end
        end
    else
        if (i - step_pre) > 50
            p_pre = P;
            step_pre = i;
            cnt_conv = 0;
        end
    end


    if cnt_conv == cnt_conv_max-10 && count_flag < size(T_lambda_testcase, 2)
        if T_osc <= 1
            P_save(count_flag,1) = P;
        else
            P_save(count_flag,1) = -P;
        end
    end
    if cnt_conv == cnt_conv_max-10 && count_flag >= size(T_lambda_testcase, 2)
        if T_osc <= 1
            P_save(count_flag,1) = P;
        else
            P_save(count_flag,1) = -P;
        end
        break;
    end

end
fname = sprintf('q_result/x%dtimes_run%d.fig', max_test, j);
savefig(h,fname,'compact');
close(h);




