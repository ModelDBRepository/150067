     TrajectoryTime=1;
     TimeStep=0.002;
     SimulationTime=100;
     FileSuffix = 'AllLearning10';
     ResultsFolder = './Register/';
     TorqueFile = strcat(ResultsFolder,'Torque',FileSuffix,'.mat');
     TorqueIndFile = strcat(ResultsFolder,'Torque1',FileSuffix,'.mat');
     PCActivityFile = strcat(ResultsFolder,'PCActivity',FileSuffix,'.mat');
     MFDCNWeightFile = strcat(ResultsFolder,'MFDCNWeight',FileSuffix,'.mat');
     PCDCNWeightFile = strcat(ResultsFolder,'PCDCNWeight',FileSuffix,'.mat');
     ErrorPositionFile = strcat(ResultsFolder,'ErrorPosition',FileSuffix,'.mat');
     
     OutputVideoName = './Videos/Learning10kgJoint1';
     
     %TrajectoriesToShow = 1:10:1000;
     TrajectoriesToShow = 1:1:100;
     FpsVideo = 20;
     ScreenSize = [1600 900];
     %MaximumSizePerVideo = 512*2^20; % Maximum size for every video (in B)
     MaximumSizePerVideo = 200*2^20; % Maximum size for every video (in B)
     
     PFPCWeightsToShow = [50 175 300 400]; % Always 4 different PFs
     
     JointToShow = 1;
     JointColors = 'brg';
          
     LineWidth = 2;
     
     TotalSize = length(TrajectoriesToShow)*FpsVideo*ScreenSize(1)*ScreenSize(2)*3;
     
     disp(['Video total size: ' num2str(TotalSize/2^20) 'MB']);
     
     if (TotalSize>MaximumSizePerVideo)
         VideoParts = floor(TotalSize/MaximumSizePerVideo)+1;
         NumberOfFramesPerPart = floor(length(TrajectoriesToShow)*FpsVideo/VideoParts); 
         disp(['Splitting in ' num2str(VideoParts) ' parts of ' num2str(NumberOfFramesPerPart) ' frames each']);
     else
         VideoParts = 1;
         NumberOfFramesPerPart = length(TrajectoriesToShow)*FpsVideo;
     end
     
     Delay=0;
     NumStep=round(TrajectoryTime/TimeStep);
     NumTrayectories=round(SimulationTime/TrajectoryTime);
     
     Torque = load(TorqueFile);
     Torque = Torque.ans;
     
     Time = Torque(1,:);
     
     CorrectiveTorques = Torque(2:4,:);
     IdealTorques = Torque(8:10,:);
     ErrorTorques = IdealTorques - CorrectiveTorques;
     
     clear Torque;
     
     IndividualTorques = load(TorqueIndFile);
     IndividualTorques = IndividualTorques.ans(2:end,:);
          
     DCNActivity = load(TorqueIndFile);
     DCNActivity = DCNActivity.ans(2:end,:);
     
     PCActivity = load(PCActivityFile);
     PCActivity = PCActivity.ans(2:end,:);
          
     MFDCNWeight = load(MFDCNWeightFile);
     MFDCNWeight = MFDCNWeight.ans(2:7,:);
     
     PCDCNWeight = load(PCDCNWeightFile);
     PCDCNWeight = PCDCNWeight.ans(2:7,:);
          
     
     ErrorPosition = load(ErrorPositionFile);
     ErrorPosition = ErrorPosition.ans(2:4,:);
     
     for i=1:NumTrayectories,
           Mae1(i)=mae(ErrorPosition(1,NumStep*(i-1)+1:(NumStep*(i))-1));
           Mae2(i)=mae(ErrorPosition(2,NumStep*(i-1)+1:(NumStep*(i))-1));
           Mae3(i)=mae(ErrorPosition(3,NumStep*(i-1)+1:(NumStep*(i))-1));
     end
     MaeTotal = Mae1+Mae2+Mae3;
     
     % Plot the 3D trajectories
     t = 0:TimeStep:(TrajectoryTime-TimeStep);
     A=0.1;
     % Joint positions 
     qtdes1 =A*sin(2*pi*t);
     qtdes2 =A*sin(2*pi*t+pi/4);
     qtdes3 =A*sin(2*pi*t+pi/2); 
     
     [xdes, ydes, zdes] = cin_dir_och3joints_funct(qtdes1,qtdes2,qtdes3);
     
 
     fig10 = figure(10);
     set(fig10,'Position',[1 1 ScreenSize]); %make the frame size fixed
     %set(fig10,'Position',[1 1 800 800]); %make the frame size fixed
     
     % Set 3D trajectory axes
     TrajPlot = subplot(5,2,[1 3]);
     ax=get(TrajPlot,'Position');
     %ax(2)=ax(2)+0.05;
     %ax(4)=ax(4)-0.05; %or wathever
     %set(TrajPlot,'Position',ax);
     grid on;
     axis([0.78 0.789 -0.08 0.08 0 1]);
     campos([0.8 -0.25 8.6])
     xlabel('x(m)');
     xlabh = get(gca,'XLabel');
     set(xlabh,'Position',[0.801 -0.386 8.398]);
     ylabel('y(m)');
     ylabh = get(gca,'YLabel');
     set(ylabh,'Position',[0.807 -0.277 8.39]);
     zlabel('z(m)');
     title('3D Trajectory','FontSize', 18);
     set(gca,'defaultlinelinewidth',3); 
     set(gca,'nextplot','replacechildren');
 
     
     % Set corrective torque axes
     TorquePlot = subplot(5,2,[5 7]);
     ax=get(TorquePlot,'Position');
     ax(2)=ax(2)+0.02;
     ax(4)=ax(4)-0.02; %or wathever
     set(TorquePlot,'Position',ax);
     axis([0 1 min(CorrectiveTorques(:)) max(CorrectiveTorques(:))]);
     xlabel('Time(s)');
     ylabel('Torque (Nm)');
     title('Corrective Torques','FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren')
     
     % Set MAE axes
     MAEPlot = subplot(5,2,9);
     axis([0 max(TrajectoriesToShow) min(log10(MaeTotal(TrajectoriesToShow))) max(log10(MaeTotal(TrajectoriesToShow)))]);
     xlabel('Trial');
     ylabel('log(MAE)');
     title('Mean Average Error','FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren')
     
     
     % Set PFPC axes
     PFPCWeightPlot = subplot(5,2,2);
     axis([0 max(TrajectoriesToShow) 0 1]);
     xlabel('Trial');
     ylabel('PF-PC Weight');
     title(['PF-PC Weight - Joint ' num2str(JointToShow)],'FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren')
     
     
     % Set PC activity axes
     PCActPlot = subplot(5,2,4);
     axis([0 1 0 1]);
     xlabel('Time(s)');
     ylabel('Firing Rate');
     title(['PC Activity - Joint ' num2str(JointToShow)],'FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren')
     
     % Set DCN activity axes
     DCNActPlot = subplot(5,2,6);
     LocalValues = IndividualTorques((JointToShow*2-1):(JointToShow*2),:);
     axis([0 1 0 max(LocalValues(:))]);
     xlabel('Time(s)');
     ylabel('Firing Rate');
     title(['DCN Activity - Joint ' num2str(JointToShow)],'FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren')
     
     % Set MF-DCN weight axes
     MFDCNWeightPlot = subplot(5,2,8);
     LocalValues = MFDCNWeight((JointToShow*2-1):(JointToShow*2),:);
     axis([0 max(TrajectoriesToShow) 0 max(LocalValues(:))]);
     xlabel('Trial');
     ylabel('MF-DCN Weight');
     title(['MF-DCN Weight - Joint ' num2str(JointToShow)],'FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren')
     
     % Set PC-DCN weight axes
     PCDCNWeightPlot = subplot(5,2,10);
     LocalValues = PCDCNWeight((JointToShow*2-1):(JointToShow*2),:);
     axis([0 max(TrajectoriesToShow) 0 max(LocalValues(:))]);
     xlabel('Trial');
     ylabel('PC-DCN Weight');
     title(['PC-DCN Weight - Joint ' num2str(JointToShow)],'FontSize', 13);
     set(gca,'defaultlinelinewidth',LineWidth); 
     set(gca,'nextplot','replacechildren');
        
     
         
     StepPerFrame = NumStep/FpsVideo;
     nframe=FpsVideo*length(TrajectoriesToShow);
     CurrentVideoPart = 1;
     CurrentPartFrame = 1;
     mov(1:NumberOfFramesPerPart)= struct('cdata',[],'colormap',[]);
     for j=1:length(TrajectoriesToShow),
         i = TrajectoriesToShow(j);
         InitIndex = (NumStep*(i-1)+1);
         EndIndex = (NumStep*i);
         LocalTime = 0:TimeStep:((NumStep-1)*TimeStep);
         qtreal1 = qtdes1-ErrorPosition(1,InitIndex:EndIndex);
         qtreal2 = qtdes2-ErrorPosition(2,InitIndex:EndIndex);
         qtreal3 = qtdes3-ErrorPosition(3,InitIndex:EndIndex);
         [xreal, yreal, zreal] = cin_dir_och3joints_funct(qtreal1,qtreal2,qtreal3);
         title(TrajPlot,['Trial ' num2str(i)],'FontSize', 20);
         
         PFPCIndexes = [0:(i-1)]*NumStep;
         
         % Plot PF-PC weight
         plot(PFPCWeightPlot, 1:i, PCActivity(JointToShow*2-1,PFPCIndexes+PFPCWeightsToShow(1)),['-' JointColors(JointToShow)],...
             1:i, PCActivity(JointToShow*2-1,PFPCIndexes+PFPCWeightsToShow(2)),['-' JointColors(JointToShow)],...
             1:i, PCActivity(JointToShow*2-1,PFPCIndexes+PFPCWeightsToShow(3)),['-' JointColors(JointToShow)],...
             1:i, PCActivity(JointToShow*2-1,PFPCIndexes+PFPCWeightsToShow(4)),['-' JointColors(JointToShow)]);
            
                  
         for k=1:FpsVideo,
            LocalIndex = round(StepPerFrame*k)-1;
            
            % Plot 3D Trajectory
            plot3(TrajPlot,xdes,ydes,zdes,'r',xreal(1:LocalIndex),yreal(1:LocalIndex),zreal(1:LocalIndex),'k');
            
            % Plot corrective torques
            plot(TorquePlot, LocalTime(1:LocalIndex), CorrectiveTorques(1,InitIndex:(InitIndex+LocalIndex-1)), ['-' JointColors(1)],...
                LocalTime, IdealTorques(1,InitIndex:EndIndex), ['--' JointColors(1)],...
                LocalTime(1:LocalIndex), CorrectiveTorques(2,InitIndex:(InitIndex+LocalIndex-1)), ['-' JointColors(2)],...
                LocalTime, IdealTorques(2,InitIndex:EndIndex), ['--' JointColors(2)],...
                LocalTime(1:LocalIndex), CorrectiveTorques(3,InitIndex:(InitIndex+LocalIndex-1)), ['-' JointColors(3)],...
                LocalTime, IdealTorques(3,InitIndex:EndIndex), ['--' JointColors(3)]);
            legend(TorquePlot,'Joint 1 - Real','Joint 1 - Ideal','Joint 2 - Real',...
                'Joint 2 - Ideal','Joint 3 - Real','Joint 3 - Ideal','Location','SouthEast');
            
            % Plot MAE evolution
            plot(MAEPlot, 1:i, log10(MaeTotal(1:i)),'k');
                 
            % Plot PC activity
            plot(PCActPlot, LocalTime(1:LocalIndex), PCActivity(JointToShow*2-1,InitIndex:(InitIndex+LocalIndex-1)),['-' JointColors(JointToShow)],...
                LocalTime(1:LocalIndex), PCActivity(JointToShow*2,InitIndex:(InitIndex+LocalIndex-1)),['--' JointColors(JointToShow)]);
                 
            
            % Plot DCN activity
            plot(DCNActPlot, LocalTime(1:LocalIndex), DCNActivity(JointToShow*2-1,InitIndex:(InitIndex+LocalIndex-1)),['-' JointColors(JointToShow)],...
                LocalTime(1:LocalIndex), DCNActivity(JointToShow*2,InitIndex:(InitIndex+LocalIndex-1)),['--' JointColors(JointToShow)]);
            
            % Plot MF-DCN weight
            plot(MFDCNWeightPlot, Time(1:(InitIndex+LocalIndex-1)), MFDCNWeight(JointToShow*2-1,1:(InitIndex+LocalIndex-1)),['-' JointColors(JointToShow)],...
                Time(1:(InitIndex+LocalIndex-1)), MFDCNWeight(JointToShow*2,1:(InitIndex+LocalIndex-1)),['--' JointColors(JointToShow)]);
            legend(MFDCNWeightPlot,'Agonist','Antagonist','Location','East');
            
            % Plot PC-DCN weight
            plot(PCDCNWeightPlot, Time(1:(InitIndex+LocalIndex-1)), PCDCNWeight(JointToShow*2-1,1:(InitIndex+LocalIndex-1)),['-' JointColors(JointToShow)],...
                Time(1:(InitIndex+LocalIndex-1)), PCDCNWeight(JointToShow*2,1:(InitIndex+LocalIndex-1)),['--' JointColors(JointToShow)]);
            
            
            mov(CurrentPartFrame)=getframe(gcf);
            
            if (CurrentPartFrame==NumberOfFramesPerPart)
                disp(['Writing video part ' num2str(CurrentVideoPart)]);
                movie2avi(mov, [OutputVideoName num2str(CurrentVideoPart) '.avi'], 'compression', 'None','fps',FpsVideo);
                mov(1:NumberOfFramesPerPart)= struct('cdata',[],'colormap',[]);
                CurrentVideoPart = CurrentVideoPart + 1;
                CurrentPartFrame = 0;
            end
            
            CurrentPartFrame = CurrentPartFrame + 1;
            
         end
     end
     
     beep;