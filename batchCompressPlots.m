%% Batch compress videos, batch CRprob, and batch CRamp plots for multiple mice on the same day

close all
clear all
clc

mouse = {'KF34'; 'KF35'; 'KF36'; 'KF37'; 'KF38'; 'KF39'; 'KF40'; 'KF41'; 'KF42'; 'KF43'; 'KF45'};
rig = {'black'; 'blue'; 'black'; 'blue'; 'black'; 'blue'; 'black'; 'blue'; 'black'; 'blue'; 'blue'};
date = '220917';

% Make batch compressed videos
for n = 1:length(mouse);
    makeCompressedVideos(['Y:\\home\kayla\Eyelid conditioning\' mouse{n} '\' date])
end

% Make batch CRprob and CRamp plots
for n = 1:length(mouse);
    if strcmp(rig{n},'black') == 1
        win = [108 109 110 111]; %determined through imageSubtraction.m
    elseif strcmp(rig{n},'blue') == 1 
        win = [35 36 37 38]; %determined through imageSubtraction.m
    end
    
    isi = 250;
    session = 1;
    us = 3; %triggers airpuff; arduino COM3
    cs = 5; %triggers speaker; refers to 5 kHz tone
    
    folder = fullfile('Y:\\home\kayla\Eyelid conditioning\',mouse{n},date);
    trials = processTrials(fullfile(folder,'compressed'),...
        fullfile(folder,'compressed',sprintf('Data_%s_s01_calib.mp4',date))); 

    save(fullfile(folder, 'trialdata.mat'),'trials');

    if numel(unique(trials.session_of_day)) == 1
        [hf1,hf2,CRprob,CRamp]=makePlots(trials,rig{n},win,isi,session,us,cs);
    else
        [hf1,hf2,CRprob,CRamp]=makePlots_mSessions(trials,rig{n},win,isi,session,us,cs);
    end

    hgsave(hf1,fullfile(folder,'CRs.fig'));
    hgsave(hf2,fullfile(folder,'CR_amp_trend.fig'));

    print(hf1,fullfile(folder,sprintf('%s_%s_CRs.pdf',mouse{n},date)),'-dpdf')
    print(hf2,fullfile(folder,sprintf('%s_%s_CR_amp_trend.pdf',mouse{n},date)),'-dpdf')
    
end
