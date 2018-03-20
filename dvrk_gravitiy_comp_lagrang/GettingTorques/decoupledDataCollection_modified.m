rosshutdown
rosinit

q_min = [-0.6981,-0.2618, -0.8727, -3.4907, -1.5708 ,-0.7854,-8.3776];
q_max = [1.1345, 0.8727 , 0.6109 ,  1.5708 , 3.1416, 0.7854,7.8540];

q_min_start = (q_max-q_min)*0.2+q_min;
%The distance for one step, 10 steps in total. 
q_delta     = (q_max-q_min)*0.6/10;

decouple_num = 5
joint_num = 7;
switch_time = 5
step_time = 3
sample_num = 50

% This function is for data collection for each joint torque of the MTM
% (the joints are decoupled)
sub_pos = rossubscriber('/dvrk/MTMR/state_joint_current');
sub_tor_current = rossubscriber('/dvrk/MTMR/state_joint_current');
sub_tor_desired = rossubscriber('/dvrk/MTMR/state_joint_current');
pub_pos = rospublisher('/dvrk/MTMR/set_position_joint');

% torque_data = (recorded_torque,jth_pose,ith_joint)
torque_desired = zeros(joint_num,10,decouple_num);
torque_current = zeros(joint_num,10,decouple_num);
actual_position = zeros(joint_num,10,decouple_num);
% reset the pose to home configuration
q = [0,0,0,0,0,0,0];
Set_Position(pub_pos,q);
pause(2)


% set and record the torque data at different configurations
% Each time the data collection of one joint is done, the robot is 
% reset to the home pose and then move on to the next joint

for i=2:6
    sum_mean_torque_current = zeros(joint_num,sample_num);
    sum_mean_torque_desired = zeros(joint_num,sample_num);
    sum_postion = zeros(joint_num,sample_num);
    q = [0,0,0,0,0,0,0];
    Set_Position(pub_pos,q); 
    for j = 1:1:5
        q(i) = q(i)-q_delta(i);
        Set_Position(pub_pos,q);
        pause(step_time)
        for k = 1:sample_num
            msg_desired = receive(sub_tor_desired);
            msg_current = receive(sub_tor_current);
            sum_mean_torque_current(:,k) = msg_current.Effort;
            sum_mean_torque_desired(:,k) = msg_desired.Effort;
            sum_postion(:,k) = Get_Position(sub_pos);
        end
        torque_desired(:,j,i-1) = mean(sum_mean_torque_desired,2);
        torque_current(:,j,i-1) = mean(sum_mean_torque_current,2);
        actual_position(:,j,i-1) = mean(sum_postion,2);
    end
    q(i) = q(i)-q_delta(i)/2;
    for j = 1:1:10
        q(i) = q(i)+q_delta(i);
        Set_Position(pub_pos,q);
        pause(step_time)
        for k = 1:sample_num
            msg_desired = receive(sub_tor_desired);
            msg_current = receive(sub_tor_current);
            sum_mean_torque_current(:,k) = msg_current.Effort;
            sum_mean_torque_desired(:,k) = msg_desired.Effort;
            sum_postion(:,k) = Get_Position(sub_pos);
        end
        torque_desired(:,j+5,i-1) = mean(sum_mean_torque_desired,2);
        torque_current(:,j+5,i-1) = mean(sum_mean_torque_current,2);
        actual_position(:,j+5,i-1) = mean(sum_postion,2);
    end  
    q(i) = q(i)+q_delta(i)/2;
    for j = 1:1:5
        q(i) = q(i)-q_delta(i);
        Set_Position(pub_pos,q);
        pause(step_time)
        for k = 1:sample_num
            msg_desired = receive(sub_tor_desired);
            msg_current = receive(sub_tor_current);
            sum_mean_torque_current(:,k) = msg_current.Effort;
            sum_mean_torque_desired(:,k) = msg_desired.Effort;
            sum_postion(:,k) = Get_Position(sub_pos);
        end
        torque_desired(:,j+15,i-1) = mean(sum_mean_torque_desired,2);
        torque_current(:,j+15,i-1) = mean(sum_mean_torque_current,2);
        actual_position(:,j+15,i-1) = mean(sum_postion,2);
    end  
end 

rosshutdown
