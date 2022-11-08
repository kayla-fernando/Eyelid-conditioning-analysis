%% eyelidSumsPerSession %%
% Plotting average eyelid traces for CS-US trials, US-only trials, and CS-catch trials over all sessions

% Written by Kayla Fernando (10/27/22)

% NOTE: Plotting the average eyelid traces for each trial type only
% uses data from s01, so days with multiple sessions won't be plotted
% properly. Analysis with multiple sessions works fine.

clear all
close all
clc

mouse = 'KF51'; 
basepath = 'Y:\\home\kayla\Eyelid conditioning\';

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess

switch promptData
    % No multiple sessions, different rigs
    case '0  0'
        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
    % No multiple sessions, same rig, blue
    case '0  1  0'
        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
    % No multiple sessions, same rig, black
    case '0  1  1'
        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
    % Multiple sessions, different rigs
    case '1  0'
        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
    % Multiple sessions, same rig, blue
    case '1  1  0'
        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
    % Multiple sessions, same rig, black
    case '1  1  1'
        [ax1,ax2,win] = plotConditioningCalib(conditioning_trials,calib_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,files,trials,date,1);
        [ax3,ax4,win] = plotConditioningCatch(conditioning_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,mouse,rig,win,files,trials,date,1);
        [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,1);
end
