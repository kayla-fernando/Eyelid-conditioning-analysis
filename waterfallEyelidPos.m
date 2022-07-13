%% Waterfall plot of eyelid position across all trials %%

% Written by Kayla Fernando 3/23/22

%% Plot every 100th CS-US trial

clear all
close all
clc

mouse = 'KF08'; 
basepath = 'Y:\All_Staff\home\kayla\Eyelid conditioning\';

[cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);

size_grab = size(cspaired_all);
t = tiledlayout(round(size_grab(1)/400),4,'TileSpacing','tight','TileIndexing','columnmajor');
for k = 1:(round(size_grab(1)/400)*4)
    jj = k*100;
    nexttile
    title(t,'Every 100th CS-US trial')
    rectangle('Position',[68,0,83,1],'FaceColor','b','linestyle','none'); hold on
    rectangle('Position',[130,0,7,1],'FaceColor','g','linestyle','none'); 
    plot(cspaired_all(jj,:)); ylim([0 1]); xlim([0 334]);
    ylabel(['Trial ' num2str(jj)]); hold off
end

hold off

%% Plot US-only trials

clear all
close all
clc

mouse = 'KF08'; 
basepath = 'Y:\All_Staff\home\kayla\Eyelid conditioning\';

[cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);

size_grab = size(usonly_all);
t = tiledlayout(round(size_grab(1)/5),6,'TileSpacing','tight','TileIndexing','columnmajor');
for k = 1:(round(size_grab(1)/5))
    jj = k*5;
    nexttile
    title(t,'Every 5th US-only trial')
    rectangle('Position',[130,0,7,1],'FaceColor','g','linestyle','none'); hold on
    plot(usonly_all(jj,:)); ylim([0 1]); xlim([0 334]);
    ylabel(['Trial ' num2str(jj)]); hold off
end

hold off

%% Plot CS-catch trials

size_grab = size(cscatch_all);
t = tiledlayout(round(size_grab(1)/5),6,'TileSpacing','tight','TileIndexing','columnmajor');
for k = 1:(round(size_grab(1)/5)
    jj = k*5;
    nexttile
    title(t,'All CS-catch trials')
    rectangle('Position',[68,0,83,1],'FaceColor','b','linestyle','none'); hold on
    plot(cscatch_all(k,:)); ylim([0 1]); xlim([0 334]);
    ylabel(['Trial ' num2str(jj)]); hold off
end

hold off
