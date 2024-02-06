%% Batch compress videos, batch CRprob, and batch CRamp plots for multiple mice on the same day %%

close all
clear all
clc

experiment = 'experiment';

mouse = {'mouse'; 'mouse';...
         'mouse'; 'mouse';...
         'mouse'; 'mouse'};
rig = {'black'; 'blue';... 
       'black'; 'blue'; 
       'black'; 'blue'};
date = '220101';

% Make batch compressed videos
for n = 1:length(mouse);
    makeCompressedVideos(['Y:\\home\kayla\Eyelid conditioning\' experiment '\' mouse{n} '\' date])
end

% Make batch CRprob and CRamp plots
for n = 1:length(mouse);
    if strcmp(rig{n},'black') == 1
        win = [139 140 141 142]; %determined through imageSubtraction.m
    elseif strcmp(rig{n},'blue') == 1 
        win = [47 48 49 50]; %determined through imageSubtraction.m
    end
    
    isi = 250;
    session = 1;
    us = 3; %triggers airpuff; arduino COM3
    cs = 5; %triggers speaker; refers to 5 kHz tone
    
    folder = fullfile(['Y:\\home\kayla\Eyelid conditioning\' experiment '\' mouse{n} '\' date]);
    trials = processTrials(fullfile(folder,'compressed'),...
        fullfile(folder,'compressed',sprintf('%_%s_s01_calib.mp4',mouse{n},date))); 

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
