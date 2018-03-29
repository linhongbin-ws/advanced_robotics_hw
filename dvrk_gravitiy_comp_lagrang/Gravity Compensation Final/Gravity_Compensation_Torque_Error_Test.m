sub_pos = rossubscriber('/dvrk/MTML/state_joint_current');
sub_tor = rossubscriber('/dvrk/MTML/state_joint_desired');

pub_pos = rospublisher('/dvrk/MTML/set_position_joint');;
 g = 9.9;
 position_error = zeros(8,100);
 
  dynamic_param = [0.0540
   -0.0220
    0.0301
   -0.0007
   -0.0036
   -0.0021
   -0.0032
    0.0183
    0.0004
    0.0002
   -0.0000
    0.0000];

for i = 1:100
  qs = Get_Position(sub_pos);
  q1 = qs(1);
  q2 = qs(2);
  q3 = qs(3);
  q4 = qs(4);
  q5 = qs(5);
  q6 = qs(6);
  q7 = qs(7);
  
  Regressor_Matrix =             [         0,          0,                                     0,                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                     0,                                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                     0
                                   g*sin(q2), -g*cos(q2), g*cos(q2)*cos(q3) - g*sin(q2)*sin(q3), g*cos(q2)*sin(q3) + g*cos(q3)*sin(q2), g*cos(q4)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*sin(q2) - g*cos(q2)*cos(q3)*cos(q4)*sin(q5) - g*cos(q2)*cos(q5)*sin(q3), g*sin(q2)*sin(q3)*sin(q4)*sin(q6) - g*cos(q2)*cos(q6)*sin(q3)*sin(q5) - g*cos(q3)*cos(q6)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*sin(q4)*sin(q6) - g*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q3) + g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q6), g*cos(q2)*cos(q3)*cos(q4) - g*cos(q4)*sin(q2)*sin(q3), g*cos(q2)*cos(q3)*sin(q4) - g*sin(q2)*sin(q3)*sin(q4), g*cos(q2)*sin(q3)*sin(q5) + g*cos(q3)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3), g*cos(q6)*sin(q2)*sin(q3)*sin(q4) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6), g*cos(q2)*cos(q5)*sin(q3)*sin(q7) + g*cos(q3)*cos(q5)*sin(q2)*sin(q7) + g*cos(q2)*cos(q3)*cos(q4)*sin(q5)*sin(q7) + g*cos(q6)*cos(q7)*sin(q2)*sin(q3)*sin(q4) + g*cos(q2)*cos(q7)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*cos(q7)*sin(q2)*sin(q5)*sin(q6) - g*cos(q4)*sin(q2)*sin(q3)*sin(q5)*sin(q7) - g*cos(q2)*cos(q3)*cos(q6)*cos(q7)*sin(q4) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q6) + g*cos(q4)*cos(q5)*cos(q7)*sin(q2)*sin(q3)*sin(q6), g*cos(q4)*cos(q7)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*cos(q7)*sin(q2) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4)*sin(q7) - g*cos(q2)*cos(q5)*cos(q7)*sin(q3) + g*cos(q6)*sin(q2)*sin(q3)*sin(q4)*sin(q7) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6)*sin(q7) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q7)*sin(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6)*sin(q7)
                                           0,          0, g*cos(q2)*cos(q3) - g*sin(q2)*sin(q3), g*cos(q2)*sin(q3) + g*cos(q3)*sin(q2), g*cos(q4)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*sin(q2) - g*cos(q2)*cos(q3)*cos(q4)*sin(q5) - g*cos(q2)*cos(q5)*sin(q3), g*sin(q2)*sin(q3)*sin(q4)*sin(q6) - g*cos(q2)*cos(q6)*sin(q3)*sin(q5) - g*cos(q3)*cos(q6)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*sin(q4)*sin(q6) - g*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q3) + g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q6), g*cos(q2)*cos(q3)*cos(q4) - g*cos(q4)*sin(q2)*sin(q3), g*cos(q2)*cos(q3)*sin(q4) - g*sin(q2)*sin(q3)*sin(q4), g*cos(q2)*sin(q3)*sin(q5) + g*cos(q3)*sin(q2)*sin(q5) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3), g*cos(q6)*sin(q2)*sin(q3)*sin(q4) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6), g*cos(q2)*cos(q5)*sin(q3)*sin(q7) + g*cos(q3)*cos(q5)*sin(q2)*sin(q7) + g*cos(q2)*cos(q3)*cos(q4)*sin(q5)*sin(q7) + g*cos(q6)*cos(q7)*sin(q2)*sin(q3)*sin(q4) + g*cos(q2)*cos(q7)*sin(q3)*sin(q5)*sin(q6) + g*cos(q3)*cos(q7)*sin(q2)*sin(q5)*sin(q6) - g*cos(q4)*sin(q2)*sin(q3)*sin(q5)*sin(q7) - g*cos(q2)*cos(q3)*cos(q6)*cos(q7)*sin(q4) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q6) + g*cos(q4)*cos(q5)*cos(q7)*sin(q2)*sin(q3)*sin(q6), g*cos(q4)*cos(q7)*sin(q2)*sin(q3)*sin(q5) - g*cos(q3)*cos(q5)*cos(q7)*sin(q2) - g*cos(q2)*cos(q3)*cos(q6)*sin(q4)*sin(q7) - g*cos(q2)*cos(q5)*cos(q7)*sin(q3) + g*cos(q6)*sin(q2)*sin(q3)*sin(q4)*sin(q7) + g*cos(q2)*sin(q3)*sin(q5)*sin(q6)*sin(q7) + g*cos(q3)*sin(q2)*sin(q5)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q7)*sin(q5) + g*cos(q4)*cos(q5)*sin(q2)*sin(q3)*sin(q6)*sin(q7) - g*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q6)*sin(q7)
                                           0,          0,                                     0,                                     0,                                                                                                g*sin(q2 + q3)*sin(q4)*sin(q5),                                                                                                                                                                           -g*sin(q2 + q3)*(cos(q4)*sin(q6) + cos(q5)*cos(q6)*sin(q4)),                               -g*sin(q2 + q3)*sin(q4),                                g*sin(q2 + q3)*cos(q4),                                                                                                g*sin(q2 + q3)*cos(q5)*sin(q4),                                                                                                                                                                           -g*sin(q2 + q3)*(cos(q4)*cos(q6) - cos(q5)*sin(q4)*sin(q6)),                                                                                                                                                                                                                                                                                                                                                 -g*sin(q2 + q3)*(sin(q4)*sin(q5)*sin(q7) + cos(q4)*cos(q6)*cos(q7) - cos(q5)*cos(q7)*sin(q4)*sin(q6)),                                                                                                                                                                                                                                                                                                                                                  g*sin(q2 + q3)*(cos(q7)*sin(q4)*sin(q5) - cos(q4)*cos(q6)*sin(q7) + cos(q5)*sin(q4)*sin(q6)*sin(q7))
                                           0,          0,                                     0,                                     0,    -g*(cos(q2)*cos(q3)*sin(q5) - sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*sin(q2)),                                                                            -g*(cos(q5)*cos(q6)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5)*cos(q6) + cos(q2)*cos(q4)*cos(q6)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*cos(q6)*sin(q2)*sin(q5)),                                                     0,                                                     0,     g*(cos(q5)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5) + cos(q2)*cos(q4)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*sin(q2)*sin(q5)),                                                                             g*(cos(q5)*sin(q2)*sin(q3)*sin(q6) - cos(q2)*cos(q3)*cos(q5)*sin(q6) + cos(q2)*cos(q4)*sin(q3)*sin(q5)*sin(q6) + cos(q3)*cos(q4)*sin(q2)*sin(q5)*sin(q6)),                                                                                                     g*(cos(q2)*cos(q3)*sin(q5)*sin(q7) - sin(q2)*sin(q3)*sin(q5)*sin(q7) - cos(q2)*cos(q3)*cos(q5)*cos(q7)*sin(q6) + cos(q2)*cos(q4)*cos(q5)*sin(q3)*sin(q7) + cos(q3)*cos(q4)*cos(q5)*sin(q2)*sin(q7) + cos(q5)*cos(q7)*sin(q2)*sin(q3)*sin(q6) + cos(q2)*cos(q4)*cos(q7)*sin(q3)*sin(q5)*sin(q6) + cos(q3)*cos(q4)*cos(q7)*sin(q2)*sin(q5)*sin(q6)),                                                                                                    -g*(cos(q2)*cos(q3)*cos(q7)*sin(q5) - cos(q7)*sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*cos(q7)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q2) + cos(q2)*cos(q3)*cos(q5)*sin(q6)*sin(q7) - cos(q5)*sin(q2)*sin(q3)*sin(q6)*sin(q7) - cos(q2)*cos(q4)*sin(q3)*sin(q5)*sin(q6)*sin(q7) - cos(q3)*cos(q4)*sin(q2)*sin(q5)*sin(q6)*sin(q7))
                                           0,          0,                                     0,                                     0,                                                                                                                             0,        -g*(cos(q2)*cos(q6)*sin(q3)*sin(q4) + cos(q3)*cos(q6)*sin(q2)*sin(q4) + cos(q2)*cos(q3)*sin(q5)*sin(q6) - sin(q2)*sin(q3)*sin(q5)*sin(q6) + cos(q2)*cos(q4)*cos(q5)*sin(q3)*sin(q6) + cos(q3)*cos(q4)*cos(q5)*sin(q2)*sin(q6)),                                                     0,                                                     0,                                                                                                                             0,        -g*(cos(q2)*cos(q3)*cos(q6)*sin(q5) - cos(q2)*sin(q3)*sin(q4)*sin(q6) - cos(q3)*sin(q2)*sin(q4)*sin(q6) - cos(q6)*sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*cos(q6)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*cos(q6)*sin(q2)),                                                                                                                                                                        -g*(cos(q2)*cos(q3)*cos(q6)*cos(q7)*sin(q5) - cos(q2)*cos(q7)*sin(q3)*sin(q4)*sin(q6) - cos(q3)*cos(q7)*sin(q2)*sin(q4)*sin(q6) - cos(q6)*cos(q7)*sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*cos(q6)*cos(q7)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*cos(q6)*cos(q7)*sin(q2)),                                                                                                                                                                        -g*(cos(q2)*cos(q3)*cos(q6)*sin(q5)*sin(q7) - cos(q2)*sin(q3)*sin(q4)*sin(q6)*sin(q7) - cos(q3)*sin(q2)*sin(q4)*sin(q6)*sin(q7) - cos(q6)*sin(q2)*sin(q3)*sin(q5)*sin(q7) + cos(q2)*cos(q4)*cos(q5)*cos(q6)*sin(q3)*sin(q7) + cos(q3)*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q7))
                                           0,          0,                                     0,                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                     0,                                                     0,                                                                                                                             0,                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                     0,                                                                                                                                                                                                                                                                                                                                                                                                                                                    0]; %g*(cos(q5)*cos(q7)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5)*cos(q7) + cos(q2)*cos(q4)*cos(q7)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*cos(q7)*sin(q2)*sin(q5) + cos(q2)*cos(q6)*sin(q3)*sin(q4)*sin(q7) + cos(q3)*cos(q6)*sin(q2)*sin(q4)*sin(q7) + cos(q2)*cos(q3)*sin(q5)*sin(q6)*sin(q7) - sin(q2)*sin(q3)*sin(q5)*sin(q6)*sin(q7) + cos(q2)*cos(q4)*cos(q5)*sin(q3)*sin(q6)*sin(q7) + cos(q3)*cos(q4)*cos(q5)*sin(q2)*sin(q6)*sin(q7)),                -g*(cos(q2)*cos(q3)*cos(q5)*sin(q7) - cos(q5)*sin(q2)*sin(q3)*sin(q7) + cos(q2)*cos(q6)*cos(q7)*sin(q3)*sin(q4) + cos(q3)*cos(q6)*cos(q7)*sin(q2)*sin(q4) + cos(q2)*cos(q3)*cos(q7)*sin(q5)*sin(q6) - cos(q2)*cos(q4)*sin(q3)*sin(q5)*sin(q7) - cos(q3)*cos(q4)*sin(q2)*sin(q5)*sin(q7) - cos(q7)*sin(q2)*sin(q3)*sin(q5)*sin(q6) + cos(q2)*cos(q4)*cos(q5)*cos(q7)*sin(q3)*sin(q6) + cos(q3)*cos(q4)*cos(q5)*cos(q7)*sin(q2)*sin(q6))];


  Torques = Regressor_Matrix*dynamic_param;;
  torques_error= Get_Torque(sub_tor)-Torques;
end

Plot_Errors(torques_error);