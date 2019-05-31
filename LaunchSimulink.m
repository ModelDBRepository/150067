%**************************************************************************
%                           Launch m file for Simulink EdLuT
%**************************************************************************   

     bdclose all
     set_param(0,'CharacterEncoding','windows-1252')

     %clear all
     %close all
     TrajectoryTime=1;
     TimeStep=0.002;
     SimulationTime=1000;
     %FileSuffix = 'LearningPC2_5';
     %FileSuffix = 'LearningPC10';
     FileSuffix = 'AllLearning10';
     %ResultsFolder = 'F:\Experimental_Data\MF-DCN Learning\TrainingSlowPCandDCN\';
     ResultsFolder = './Register/';
     TorqueFile = strcat(ResultsFolder,'Torque',FileSuffix,'.mat');
     TorqueIndFile = strcat(ResultsFolder,'Torque1',FileSuffix,'.mat');
     PCActivityFile = strcat(ResultsFolder,'PCActivity',FileSuffix,'.mat');
     MFDCNWeightFile = strcat(ResultsFolder,'MFDCNWeight',FileSuffix,'.mat');
     PCDCNWeightFile = strcat(ResultsFolder,'PCDCNWeight',FileSuffix,'.mat');
     ErrorPositionFile = strcat(ResultsFolder,'ErrorPosition',FileSuffix,'.mat');
     
     %TrajectoriesToShow = 1:round(SimulationTime/TrajectoryTime);
     TrajectoriesToShow = 1:10:1000;
     
     Delay=0;
     NumStep=round(TrajectoryTime/TimeStep);
     NumTrayectories=round(SimulationTime/TrajectoryTime);
     context=1;
     load MANIPUL
     load MANIPULDETERIORADO15 RRedKuKadet15
     %load the manipulator file with 1kg mass at the ending efector
     RRedKuKa=RRedKuKa;
     RRedKuKadet=RRedKuKadet15;
     % launch the simulink file, at least the path an time per trajectory 
     % should be specified.
     open_system('EdLuTSimulink');
     set_param('EdLuTSimulink/ToFileTorque','Filename',TorqueFile);
     set_param('EdLuTSimulink/ToFileTorqueInd','Filename',TorqueIndFile);
     set_param('EdLuTSimulink/ToFilePC','Filename',PCActivityFile);
     set_param('EdLuTSimulink/ToFileMFDCN','Filename',MFDCNWeightFile);
     set_param('EdLuTSimulink/ToFilePCDCN','Filename',PCDCNWeightFile);
     open_system('EdLuTSimulink/Subsystem');
     open_system('EdLuTSimulink/Subsystem/ErrorModel');
     set_param('EdLuTSimulink/Subsystem/ErrorModel/ToFileErrorPos','Filename',ErrorPositionFile);
     save_system('EdLuTSimulink');
     sim('EdLuTSimulink',SimulationTime+Delay);
     
     
     Torque = load(TorqueFile);
     Torque = Torque.ans;
     
     figure(1)
     subplot(3,1,1)
     plot(Torque(1,:),Torque(2,:),'b')
     hold on
     plot(Torque(1,:),Torque(3,:),'r')
     hold on
     plot(Torque(1,:),Torque(4,:),'k')
     title('Corrective Torques')
     subplot(3,1,2)
     plot(Torque(1,:),Torque(8,:),'b')
     hold on
     plot(Torque(1,:),Torque(9,:),'r')
     hold on
     plot(Torque(1,:),Torque(10,:),'k')
     title('Ideal Torques')
     subplot(3,1,3)
     plot(Torque(1,:),Torque(8,:)-Torque(2,:),'b')
     hold on
     plot(Torque(1,:),Torque(9,:)-Torque(3,:),'r')
     hold on
     plot(Torque(1,:),Torque(10,:)-Torque(4,:),'k')
     title('Error Torques')
     clear Torque;

     
     Torque1 = load(TorqueIndFile);
     Torque1 = Torque1.ans;
     figure(2)
     subplot(3,1,1)
     plot(Torque1(1,:),Torque1(2,:),'b')
     hold on
     plot(Torque1(1,:),Torque1(3,:),'r')
     hold on
     title('Corrective partial Torque Joint 1')
     subplot(3,1,2)
     plot(Torque1(1,:),Torque1(4,:),'b')
     hold on
     plot(Torque1(1,:),Torque1(5,:),'r')
     hold on
     title('Corrective partial Torque Joint 2')
     subplot(3,1,3)
     plot(Torque1(1,:),Torque1(6,:),'b')
     hold on
     plot(Torque1(1,:),Torque1(7,:),'r')
     hold on
     title('Corrective partial Torque Joint 3')
          
     figure(3)
     subplot(3,1,1)
     plot(Torque1(1,:),Torque1(2,:)+Torque1(3,:),'b')
     title('Stiffness Joint 1')
     subplot(3,1,2)
     plot(Torque1(1,:),Torque1(4,:)+Torque1(5,:),'r')
     title('Stiffness Joint 2')
     subplot(3,1,3)
     plot(Torque1(1,:),Torque1(6,:)+Torque1(7,:),'k')
     title('Stiffness Joint 3')
     clear Torque1;
     
     PCActivity = load(PCActivityFile);
     PCActivity = PCActivity.ans;
     figure(4)
     subplot(3,1,1)
     plot(PCActivity(1,:),PCActivity(2,:),'b')
     hold on
     plot(PCActivity(1,:),PCActivity(3,:),'r')
     hold on
     title('PC Activity Joint 1')
     subplot(3,1,2)
     plot(PCActivity(1,:),PCActivity(4,:),'b')
     hold on
     plot(PCActivity(1,:),PCActivity(5,:),'r')
     hold on
     title('PC Activity Joint 2')
     subplot(3,1,3)
     plot(PCActivity(1,:),PCActivity(6,:),'b')
     hold on
     plot(PCActivity(1,:),PCActivity(7,:),'r')
     hold on
     title('PC Activity Joint 3')
     clear PCActivity;
     
     MFDCNWeight = load(MFDCNWeightFile);
     MFDCNWeight = MFDCNWeight.ans;
     figure(5)
     subplot(3,1,1)
     plot(MFDCNWeight(1,:),MFDCNWeight(2,:),'b')
     hold on
     plot(MFDCNWeight(1,:),MFDCNWeight(3,:),'r')
     hold on
     title('MFDCN Weight Joint 1')
     subplot(3,1,2)
     plot(MFDCNWeight(1,:),MFDCNWeight(4,:),'b')
     hold on
     plot(MFDCNWeight(1,:),MFDCNWeight(5,:),'r')
     hold on
     title('MFDCN Weight Joint 2')
     subplot(3,1,3)
     plot(MFDCNWeight(1,:),MFDCNWeight(6,:),'b')
     hold on
     plot(MFDCNWeight(1,:),MFDCNWeight(7,:),'r')
     hold on
     title('MFDCN Weight Joint 3')
     clear MFDCNWeight;
     
     PCDCNWeight = load(PCDCNWeightFile);
     PCDCNWeight = PCDCNWeight.ans;
     figure(6)
     subplot(3,1,1)
     plot(PCDCNWeight(1,:),PCDCNWeight(2,:),'b')
     hold on
     plot(PCDCNWeight(1,:),PCDCNWeight(3,:),'r')
     hold on
     title('PCDCN Weight Joint 1')
     subplot(3,1,2)
     plot(PCDCNWeight(1,:),PCDCNWeight(4,:),'b')
     hold on
     plot(PCDCNWeight(1,:),PCDCNWeight(5,:),'r')
     hold on
     title('PCDCN Weight Joint 2')
     subplot(3,1,3)
     plot(PCDCNWeight(1,:),PCDCNWeight(6,:),'b')
     hold on
     plot(PCDCNWeight(1,:),PCDCNWeight(7,:),'r')
     hold on
     title('PCDCN Weight Joint 3')
     clear PCDCNWeight;
     
     
     
     ErrorPos = load(ErrorPositionFile);
     ErrorPos = ErrorPos.ans;
     figure(7)
     plot(ErrorPos(1,:),ErrorPos(2,:),'b')
     hold on
     plot(ErrorPos(1,:),ErrorPos(3,:),'r')
     hold on
     plot(ErrorPos(1,:),ErrorPos(4,:),'k')
     title('Error Position')
     
     
     ErrorPos1=ErrorPos(2,:)';
     ErrorPos2=ErrorPos(3,:)';
     ErrorPos3=ErrorPos(4,:)';
     clear ErrorPos;       

     for i=1:NumTrayectories,


           Mae1(i)=mae(ErrorPos1(NumStep*(i-1)+1:(NumStep*(i))-1));
           Mae2(i)=mae(ErrorPos2(NumStep*(i-1)+1:(NumStep*(i))-1));
           Mae3(i)=mae(ErrorPos3(NumStep*(i-1)+1:(NumStep*(i))-1));
     end
     figure(8)
     subplot(3,1,1)
     plot(Mae1,'b')
     hold on
     title('MAE error (Position)')
     subplot(3,1,2)
     plot(Mae2,'r')
     hold on
     subplot(3,1,3)
     plot(Mae3,'k')
     
     MaeTotal = Mae1+Mae2+Mae3;
     figure(12)
     plot(MaeTotal,'b')
     hold on;
     
     % Plot the 3D trajectories
     t = 0:TimeStep:(TrajectoryTime-TimeStep);
     A=0.1;
     % Joint positions 
     qtdes1 =A*sin(2*pi*t);
     qtdes2 =A*sin(2*pi*t+pi/4);
     qtdes3 =A*sin(2*pi*t+pi/2); 
     
     figure(9)
     grid on;
     hold all;
     [xdes, ydes, zdes] = cin_dir_och3joints_funct(qtdes1,qtdes2,qtdes3);
     plot3(xdes,ydes,zdes);
     leg = {'Desired'};
     
     for j=1:length(TrajectoriesToShow),
         i = TrajectoriesToShow(j);
         qtreal1 = qtdes1-ErrorPos1((NumStep*(i-1)+1):(NumStep*i))';
         qtreal2 = qtdes2-ErrorPos2((NumStep*(i-1)+1):(NumStep*i))';
         qtreal3 = qtdes3-ErrorPos3((NumStep*(i-1)+1):(NumStep*i))';
         [xreal, yreal, zreal] = cin_dir_och3joints_funct(qtreal1,qtreal2,qtreal3);
         plot3(xreal,yreal,zreal);
         leg{j+1} = ['Trial ' num2str(i)];
     end
     axis([0.78 0.789 -0.08 0.08 0 1]);
     campos([0.8 -0.25 8.6])
     xlabel('x(m)');
     ylabel('y(m)');
     zlabel('z(m)');
     legend(leg);
     
     save_system('EdLuTSimulink');
     close_system('EdLuTSimulink');