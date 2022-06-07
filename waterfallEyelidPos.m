%% Waterfall plot of eyelid position across all trials %%

% Written by Kayla Fernando 3/23/22

close all
clear all
clc

mouse = 'KF03'; 
basepath = 'Y:\All_Staff\home\kayla\Eyelid conditioning\';

[cspaired_all,usonly_all,cscatch_all] = getAllEyelidTraces(mouse,basepath);

%% Plot every 100th CS-US trial

size_grab = size(cspaired_all);
t = tiledlayout(round(size_grab(1)/400),4,'TileSpacing','tight','TileIndexing','columnmajor');
for k = 1:size_grab(1)
    jj = k*100;
    nexttile
    title(t,'Every 100th CS-US trial')
    rectangle('Position',[68,0,83,1],'FaceColor','b','linestyle','none'); hold on
    rectangle('Position',[145,0,10,1],'FaceColor','g','linestyle','none'); 
    plot(cspaired_all(jj,:)); ylim([0 1]); xlim([0 334]);
    ylabel(['Trial ' num2str(jj)]); hold off
end

%% Plot all US-only trials

size_grab = size(usonly_all);
t = tiledlayout(round(size_grab(1)/4),4,'TileSpacing','tight','TileIndexing','columnmajor');
for k = 1:size_grab(1)
    nexttile
    title(t,'All US-only trials')
    rectangle('Position',[145,0,10,1],'FaceColor','g','linestyle','none'); hold on
    plot(usonly_all(k,:)); ylim([0 1]); xlim([0 334]);
    ylabel(['Trial ' num2str(k)]); hold off
end

%% Plot all CS-catch trials

size_grab = size(cscatch_all);
t = tiledlayout(round(size_grab(1)/5),5,'TileSpacing','tight','TileIndexing','columnmajor');
for k = 1:(size_grab(1))
    nexttile
    title(t,'All CS-catch trials')
    rectangle('Position',[68,0,83,1],'FaceColor','b','linestyle','none'); hold on
    plot(cscatch_all(k,:)); ylim([0 1]); xlim([0 334]);
    ylabel(['Trial ' num2str(k)]); hold off
end