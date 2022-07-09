function [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,first_analysis_day)
% For tracking the development of the learned CR that should be present during CS-US trials and not during US-only trials

% Written by Kayla Fernando (7/8/22)

for k = first_analysis_day:length(files)
    % First, determine the analysis window
    if strcmp(rig{k},'black') == 1
        win{k} = [126 127 128 129]; 
    elseif strcmp(rig{k},'blue') == 1
        win{k} = [35 36 37 38];
    end  
    
    % Find the start and endpoints of the analysis window
    if strcmp(rig{k},'black') == 1
        win_temp = win{k};
        start_analysis = win_temp(1);
        end_analysis = win_temp(4);
    elseif strcmp(rig{k},'blue') == 1
        win_temp = win{k};
        start_analysis = win_temp(1);
        end_analysis = win_temp(4);
    end
    
    % Next, plot the average CS-US eyelid trace, compare with the average US-only trace, and plot the four-frame window for a single session
    ax1 = subplot(2,1,1); 
        plot(conditioning_trials{k});
        if strcmp(rig{k},'black') == 1 | strcmp(rig{k},'blue') == 1
            xline(start_analysis); xline(end_analysis); % 2018b and newer
    %         l1 = line([start_analysis start_analysis], [0 1]); set(l1,'color','k'); l2 = line([end_analysis end_analysis], [0 1]); set(l2,'color','k'); 
        end
        if strcmp(rig{k},'black') == 1
           xline(68,'b'); xline(151,'b'); % 2018b and newer
    %        l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
           xline(130,'g'); xline(137,'g'); % 2018b and newer
    %        l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
        elseif strcmp(rig{k},'blue') == 1
            xline(24,'b'); xline(53,'b'); % 2018b and newer
    %         l1 = line([24 24], [0 1]); set(l1,'color','b'); l2 = line([53 53], [0 1]); set(l2,'color','b');
            xline(39,'g'); xline(42,'g'); % 2018b and newer
    %         l1 = line([39 39], [0 1]); set(l1,'color','g'); l2 = line([42 42], [0 1]); set(l2,'color','g');            
        end
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_5_trials{k},1)) ' CS-US trials']);
        ylim([0 1]); xlim([0 size(trials{1,1}.tm,2)]); ylabel('FEC'); 
    ax2 = subplot(2,1,2); 
        plot(calib_trials{k});
        if strcmp(rig{k},'black') == 1 | strcmp(rig{k},'blue') == 1
            xline(start_analysis); xline(end_analysis); % 2018b and newer
    %         l1 = line([start_analysis start_analysis], [0 1]); set(l1,'color','k'); l2 = line([end_analysis end_analysis], [0 1]); set(l2,'color','k'); 
        end
        if strcmp(rig{k},'black') == 1
           xline(130,'g'); xline(137,'g'); % 2018b and newer
    %        l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
        elseif strcmp(rig{k},'blue') == 1
            xline(39,'g'); xline(42,'g'); % 2018b and newer
    %         l1 = line([39 39], [0 1]); set(l1,'color','g'); l2 = line([42 42], [0 1]); set(l2,'color','g');            
        end
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_7_trials{k},1)) ' US-only trials']); 
        ylim([0 1]); xlim([0 size(trials{1,1}.tm,2)]); ylabel('FEC'); xlabel('Frame');
    linkaxes([ax1,ax2],'x');
    
    disp(['Day ' num2str(k) ' four-frame window: ' num2str(win{k})])
  
    pause
end