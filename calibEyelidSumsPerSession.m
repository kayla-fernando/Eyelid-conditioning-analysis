%% Plotting average eyelid traces for CS-US trials, US-only trials, and CS-catch trials over all sessions %%

% Written by Kayla Fernando (7/8/22)

clear all
close all
clc

mouse = 'KF09';
basepath = 'Y:\\All_Staff\home\kayla\Eyelid conditioning\';

prompt = input('Does this mouse have multiple sessions at any point during training? ("1" for yes, "0" for no) ');
switch prompt
    % If mouse has no multiple sessions at any point during training:
    case 0 
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces
                [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                % Generate a list of which rig was used on each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s");
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
                % Rename eyelid traces
                [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                % Plot average eyelid traces of all trial types for each session
                [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
                [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
                [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
                        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
                        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
                    % Black rig throughout all of training
                    case 1         
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
                        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
                        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
                end
        end
    % If mouse has multiple sessions at any point during training:    
    case 1
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces, combining multiple sessions on a given day if necessary
                [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                % Generate a list of which rig was used for each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s")
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
                % Rename eyelid traces
                [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                % Plot average eyelid traces of all trial types for each session
                [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
                [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
                [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
                        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
                        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
                    % Black rig throughout all of training
                    case 1
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
                        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
                        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
                end
        end    
end