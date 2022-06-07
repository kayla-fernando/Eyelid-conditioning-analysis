%% Using average of US-only trials from each session to calibrate the analysis window for CRprob and CRamp from each session %%

% Written by Kayla Fernando (5/8/22)

clear all
close all
clc

%% Load and normalize data

mouse = 'KF12';
basepath = 'Y:\\All_Staff\home\kayla\Eyelid conditioning\';

prompt = input('Does this animal have multiple sessions at any point during training? ("1" for yes, "0" for no) ');
switch prompt
    case 0
        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials] = getAllEyelidTraces(mouse,basepath);
    case 1
        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials] = getAllEyelidTraces_mSessions(mouse,basepath);
end

%% Plot average + first derivative of all US-only trials

% Plotting the first derivative will visualize whether or not the UR is a
% single movement (preferred) or has multiple components (not preferred)

% Trial parameters
isi = 250; % ms
session = 1;
us = 3; % triggers airpuff; arduino COM3
cs = 5; % triggers speaker; refers to 5 kHz tone

% Savitzky-Golay filter parameters on the first derivative of the original eyelid trace
sav_golay_order = 2; % fits a line through the designated bin width (taking the first derivative/slope of this line)
sav_golay_bin_width = 9; % parameter to adjust; original value = 25
[b, g] = sgolay(sav_golay_order, sav_golay_bin_width);

% For event detection
event_indices = []; % a list of indices where threshold crossing occurs
blanking_indices = 100; % parameter to adjust
state = 0; % a state variable (are we above threshold?)

first_analysis_day = 1;
for k = first_analysis_day:length(files)
    % First, rename eyelid traces
    % CS-US trials will become 'learning_trials'
    eyelid3_5_trials{k} = cspaired_all_cell{k}; 
        learning_trials{k} = mean(eyelid3_5_trials{k});
    
    % US-only trials will become 'calib_trials'
    eyelid3_7_trials{k} = usonly_all_cell{k}; 
            if isempty(eyelid3_7_trials{1})
                first_analysis_day = 2;
            elseif isempty(eyelid3_7_trials{k})
                eyelid3_7_trials{k} = eyelid3_7_trials{k-1};
            end
        calib_trials{k} = mean(eyelid3_7_trials{k});
            if numel(calib_trials{k}) == 1;
                calib_trials{k} = eyelid3_7_trials{k};
            end
    
    % CS-catch trials will become 'catch_trials'
    eyelid3_0_trials{k} = cscatch_all_cell{k}; 
            if isempty(eyelid3_0_trials{1})
                first_analysis_day = 2;
            elseif isempty(eyelid3_0_trials{k})
                eyelid3_0_trials{k} = eyelid3_0_trials{k-1};
            end
        catch_trials{k} = mean(eyelid3_0_trials{k});
            if numel(catch_trials{k}) == 1;
                catch_trials{k} = eyelid3_0_trials{k};
            end
    
    % Next, get the dates
    date{k} = directory(k+2).name;
    
    % Then, plot each US-only eyelid trace + its first derivative
    ax1 = subplot(2, 1, 1);
        plot(calib_trials{k});
        xline(130,'g'); xline(137,'g'); % 2018b and newer
%         l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_7_trials{k},1)) ' US-only trials']); 
        ylim([0 1]); xlim([0 334]); ylabel('FEC');
        dydx{k} = -conv(calib_trials{k}, g(:,2), 'same');
    ax2 = subplot(2, 1, 2);
        plot(dydx{k});
        xline(130,'g'); xline(137,'g'); % 2018b and newer
%         l1 = line([130 130], [-0.1 0.1]); set(l1,'color','g'); l2 = line([137 137], [-0.1 0.1]); set(l2,'color','g');
        xlim([0 334]);
    linkaxes([ax1, ax2], 'x');
    
    % Finally, take the standard deviation of the original eyelid trace and ask for n * above the standard deviations as the threshold
    thresholdFactor = 1; % parameter to adjust; original value = 1
    threshold{k} = thresholdFactor * std(dydx{k}); 
    h = refline(0, threshold{k}); h.Color = 'k';
    title(['Savitzky-Golay-filtered eyelid trace; bin width = ' num2str(sav_golay_bin_width)]); %'; n * above SD = ' num2str(thresholdFactor)]); 
    ylabel('First derivative'); xlabel('Frame');
    
    pause 
end

%% Detection of US delivery and corresponding analysis window for CS-US eyelid traces

% Converting cell array to double array for relational operations
all_conv = vertcat(dydx{:});
all_thresh = horzcat(threshold{:});

% Detect the frame at which UR occurs
for k = first_analysis_day:length(files)
    for i = 1:length(all_conv) 
        if (state == 0) && (all_conv(k,i) > all_thresh(k))
            state = 1; % we are above threshold!
            event_indices = [event_indices i]; % event_indices will increase with each event
%             l = line([i i], [-0.05, 0.05]);
%             set(l, 'color', 'r');
        elseif (state == 1) && (all_conv(k,i) < all_thresh(k)) && (i - event_indices(end)) > blanking_indices 
            state = 0;
        end
    end
end

% Variable 'ref_frames' should have as many elements as days of training
ref_frames = event_indices(find(event_indices >= 120)); 
ref_frames = ref_frames(find(ref_frames <= 160));

for k = first_analysis_day:length(files)
    % First, determine the analysis window
    if first_analysis_day == 2;
        win{1} = zeros(1,4);
%         win{k} = [ref_frames(k-1)-4 ref_frames(k-1)-3 ref_frames(k-1)-2 ref_frames(k-1)-1];
        win{k} = [126 127 128 129]; % determined through imageSubtraction.m
    else
%         win{k} = [ref_frames(k)-4 ref_frames(k)-3 ref_frames(k)-2 ref_frames(k)-1];
        win{k} = [126 127 128 129]; % determined through imageSubtraction.m
    end
    start_analysis = cellfun(@(v)v(1),win);
    end_analysis = cellfun(@(v)v(4),win);
    disp(['Day ' num2str(k) ' four-frame window: ' num2str(win{k})])
    
    % Next, plot average CS-US eyelid trace, average US-only eyelid trace, and four-frame window for a single session
    ax3 = subplot(2,1,1); 
        plot(learning_trials{k});
        xline(start_analysis(k)); xline(end_analysis(k)); % 2018b and newer
%         l1 = line([start_analysis(k) start_analysis(k)], [0 1]); set(l1,'color','k'); l2 = line([end_analysis(k) end_analysis(k)], [0 1]); set(l2,'color','k'); 
        xline(68,'b'); xline(151,'b'); % 2018b and newer
%         l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
        xline(130,'g'); xline(137,'g'); % 2018b and newer
%         l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_5_trials{k},1)) ' CS-US trials']); 
        ylim([0 1]); xlim([0 334]); ylabel('FEC'); 
    ax4 = subplot(2,1,2); 
        plot(calib_trials{k});
        xline(start_analysis(k)); xline(end_analysis(k)); % 2018b and newer
%         l1 = line([start_analysis(k) start_analysis(k)], [0 1]); set(l1,'color','k'); l2 = line([end_analysis(k) end_analysis(k)], [0 1]); set(l2,'color','k');  
        xline(130,'g'); xline(137,'g'); % 2018b and newer
%         l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_7_trials{k},1)) ' US-only trials']); 
        ylim([0 1]); xlim([0 334]); ylabel('FEC'); xlabel('Frame');
    linkaxes([ax3,ax4],'x');
    
    pause
    
    % Then, make eyelid, CRprob, and CRamp plots
    prompt = input(['Does Day ' num2str(k) ' have multiple sessions? ("1" for yes, "0" for no) ']);
    switch prompt
        case 0
            makePlots(trials{k},win{k},isi,session,us,cs)
        case 1
            makePlots_mSessions(trials{k},win{k},isi,session,us,cs)
    end
    
    pause
end

%% Comparing CS-US CRamps vs CS-catch CRamps using calibrated analysis window

% If an eyelid response reaches its peak amplitude before the end of the 
% CS-US interval, the response is poorly timed and may not be cerebellum-
% dependent. Additionally, tone CSs elicit unlearned, cerebellum-
% independent startles that are reflected in eyelid movements peaking 
% 15-30 ms after CS onset.(Heiney et al. 2018, Neuromethods)

for k = first_analysis_day:length(files)
    disp(['Day ' num2str(k) ' four-frame window: ' num2str(win{k})])
    
    learning_placeholder = learning_trials{k};
    learning_CRamp = mean(learning_placeholder(:,win{k}),2) - mean(learning_placeholder(:,1:66),2) % CRamp of avg of CS-US trials in analysis window
    catch_placeholder = catch_trials{k};
    catch_CRamp = mean(catch_placeholder(:,win{k}),2) - mean(catch_placeholder(:,1:66),2) % CRamp of avg of CS-catch trials in analysis window
    
    % Plot average CS-US eyelid trace and average CS-catch eyelid trace
    ax5 = subplot(2,1,1); 
        plot(learning_trials{k});
        xline(start_analysis(k)); xline(end_analysis(k)); % 2018b and newer
%         l1 = line([start_analysis(k) start_analysis(k)], [0 1]); set(l1,'color','k'); l2 = line([end_analysis(k) end_analysis(k)], [0 1]); set(l2,'color','k');
        xline(68,'b'); xline(151,'b'); % 2018b and newer
%         l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
        xline(130,'g'); xline(137,'g'); % 2018b and newer
%         l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_5_trials{k},1)) ' CS-US trials']); 
        ylim([0 1]); xlim([0 334]); ylabel('FEC'); 
    ax6 = subplot(2,1,2); 
        plot(catch_trials{k});
        xline(start_analysis(k)); xline(end_analysis(k)); % 2018b and newer
%         l1 = line([start_analysis(k) start_analysis(k)], [0 1]); set(l1,'color','k'); l2 = line([end_analysis(k) end_analysis(k)], [0 1]); set(l2,'color','k');
        xline(68,'b'); xline(151,'b'); % 2018b and newer
%         l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
        title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_0_trials{k},1)) ' CS-catch trials']); 
        ylim([0 1]); xlim([0 334]); ylabel('FEC'); xlabel('Frame'); 
    linkaxes([ax5,ax6],'x')
    
    pause 
end

%% Summary eyelid traces

for k = 1:length(files)

    % CS-US trials
    ax1 = subplot(3,1,1); 
    plot(learning_trials{1, k}); 
    xline(gca,68,'b-','Alpha',1); xline(gca,151,'b-','Alpha',1); % 2018b and newer
    xline(gca,130,'g-','Alpha',1); xline(gca,137,'g-','Alpha',1); % 2018b and newer
%     l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
%     l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
    title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_5_trials{k},1)) ' CS-US trials']);  
    ylabel('FEC'); 
    xlim([0 334]); ylim([0 1]);

    % US-only trials
    ax2 = subplot(3,1,2); 
    plot(calib_trials{1, k}); 
    xline(gca,130,'g-','Alpha',1); xline(gca,137,'g-','Alpha',1); % 2018b and newer
%     l1 = line([130 130], [0 1]); set(l1,'color','g'); l2 = line([137 137], [0 1]); set(l2,'color','g');
    title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_7_trials{k},1)) ' US-only trials']); 
    ylabel('FEC'); 
    xlim([0 334]); ylim([0 1]);

    % CS-catch trials
    ax3 = subplot(3,1,3); 
    plot(catch_trials{1, k}); 
    xline(gca,68,'b-','Alpha',1); xline(gca,151,'b-','Alpha',1); % 2018b and newer
%     l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
    title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_0_trials{k},1)) ' CS-catch trials']); 
    xlabel('Frame'); ylabel('FEC');  
    xlim([0 334]); ylim([0 1]);

    linkaxes([ax1, ax2, ax3], 'x');
    
    pause
end

close all
