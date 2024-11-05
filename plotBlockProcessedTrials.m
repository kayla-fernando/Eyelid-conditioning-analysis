function [h,hf1] = plotBlockProcessedTrials(blockAveragedDownSignal,mouse,rig,files,trials,blockSizeTemp,CRprobs,times)

% Written by Kayla Fernando (7/10/22)

hold off

if numel(unique(rig)) == 1
    % Heatmap of block-processed eyelid traces 
    h = heatmap(blockAveragedDownSignal);
    title([mouse ' CS-US eyelid traces ' num2str(blockSizeTemp(1)) '-trial blocks']);
    xlabel('Time from CS (s)');
    ylabel('Trial block');
    colormap(jet); %turbo in newer versions
    colorbar;
    caxis([0 1]);
    % Get underlying axis handle
    origState = warning('query','MATLAB:structOnObject');
    cleanup = onCleanup(@()warning(origState));
    warning('off','MATLAB:structOnObject')
    s = struct(h);  % Undocumented
    ax = s.Axes;    % Undocumented
    clear('cleanup')
    % Label x-axis
    XLabels = times; %trials{1}.tm(1,1:end); %241104: accomodating for new black rig params
    CustomXLabels = string(XLabels);
    h.XDisplayLabels = CustomXLabels;
    h.XDisplayLabels = compose('%.2f',str2double(h.XDisplayLabels));
    % Remove grids
    h.GridVisible = 'off';
    % Place lines around selected column (assumes 1 unit in size)
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            CS_col_1 = 24; %68;  % frame %241104: accomodating new black rig params
            CS_col_2 = 53.5; %151; % frame %241104: accomodating new black rig params
            xline(ax,[CS_col_1-0.5],'b-','Alpha',1,'LineWidth',1.5); xline(ax,[CS_col_2-0.5],'b-','Alpha',1,'LineWidth',1.5); % 2018b and newer
            US_col_1 = 54; %143; % frame %241104: accomodating new black rig params
            US_col_2 = 57; %153; % frame %241104: accomodating new black rig params
            xline(ax,[US_col_1-0.5],'g-','Alpha',1,'LineWidth',1.5); xline(ax,[US_col_2-0.5],'g-','Alpha',1,'LineWidth',1.5); % 2018b and newer
        elseif strcmp(rig{k},'blue') == 1
            CS_col_1 = 24;  % frame
            CS_col_2 = 53.5; % frame
            xline(ax,[CS_col_1-0.5],'b-','Alpha',1,'LineWidth',1.5); xline(ax,[CS_col_2-0.5],'b-','Alpha',1,'LineWidth',1.5); % 2018b and newer
            US_col_1 = 54; % frame
            US_col_2 = 57; % frame
            xline(ax,[US_col_1-0.5],'g-','Alpha',1,'LineWidth',1.5); xline(ax,[US_col_2-0.5],'g-','Alpha',1,'LineWidth',1.5); % 2018b and newer
        end
    end
    % 220427: adjust renderer parameters for cdfs to export as .eps vector files
    set(gcf,'renderer','Painters')
    print -depsc -tiff -r300 -painters test.eps
    
    % Plot binned CRprob learning curves
    figure;
    hf1 = plot(CRprobs);
    title([mouse ' CRprob across all trials']);
    xlabel(['Trial block ( ' num2str(blockSizeTemp(1)) ' trials each)']);
    ylabel('Probability');
    xlim([0 size(blockAveragedDownSignal,1)]); ylim([0 1]);
elseif numel(unique(rig)) > 1
    b = find(strcmp(rig,'blue'));
    if numel(b) == 1
        r = blockAveragedDownSignal{b};
        blockAveragedDownSignal{b} = [blockAveragedDownSignal{b}, repmat(0,size(r,1),334-200)];
    else
        for i = b(1:end)
            r = blockAveragedDownSignal{i};
            blockAveragedDownSignal{i} = [blockAveragedDownSignal{i}, repmat(0,size(r,1),334-200)];
        end
    end
    blockAveragedDownSignal = vertcat(blockAveragedDownSignal{:});
    h = heatmap(blockAveragedDownSignal);
    title([mouse ' CS-US eyelid traces ' num2str(blockSizeTemp(1)) '-trial blocks']);
    xlabel('Time from CS (s)');
    ylabel('Trial block');
    colormap(jet); %turbo in newer versions
    colorbar;
    caxis([0 1]);
    % Get underlying axis handle
    origState = warning('query','MATLAB:structOnObject');
    cleanup = onCleanup(@()warning(origState));
    warning('off','MATLAB:structOnObject')
    s = struct(h);  % Undocumented
    ax = s.Axes;    % Undocumented
    clear('cleanup')
    % Label x-axis
    XLabels = trials{1}.tm(1,1:end);
    CustomXLabels = string(XLabels);
    h.XDisplayLabels = CustomXLabels;
    h.XDisplayLabels = compose('%.2f',str2double(h.XDisplayLabels));
    % Remove grids
    h.GridVisible = 'off';
    % Place lines around selected column (assumes 1 unit in size)
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            CS_col_1 = 24; %68;  % frame %241104: accomodating new black rig params
            CS_col_2 = 53.5; %151; % frame %241104: accomodating new black rig params
            xline(ax,[CS_col_1-0.5],'b-','Alpha',1,'LineWidth',1.5); xline(ax,[CS_col_2-0.5],'b-','Alpha',1,'LineWidth',1.5); % 2018b and newer
            US_col_1 = 54; %143; % frame %241104: accomodating new black rig params
            US_col_2 = 57; %153; % frame %241104: accomodating new black rig params
            xline(ax,[US_col_1-0.5],'g-','Alpha',1,'LineWidth',1.5); xline(ax,[US_col_2-0.5],'g-','Alpha',1,'LineWidth',1.5); % 2018b and newer
        elseif strcmp(rig{k},'blue') == 1
            CS_col_1 = 24;  % frame
            CS_col_2 = 53.5; % frame
            xline(ax,[CS_col_1-0.5],'b-','Alpha',1,'LineWidth',1.5); xline(ax,[CS_col_2-0.5],'b-','Alpha',1,'LineWidth',1.5); % 2018b and newer
            US_col_1 = 54; % frame
            US_col_2 = 57; % frame
            xline(ax,[US_col_1-0.5],'g-','Alpha',1,'LineWidth',1.5); xline(ax,[US_col_2-0.5],'g-','Alpha',1,'LineWidth',1.5); % 2018b and newer
        end
    end
    % 220427: adjust renderer parameters for cdfs to export as .eps vector files
    set(gcf,'renderer','Painters')
    print -depsc -tiff -r300 -painters test.eps

    % Plot binned CRprob learning curves
    figure;
    hf1 = plot(CRprobs);
    title([mouse ' CRprob across all trials']);
    xlabel(['Trial block ( ' num2str(blockSizeTemp(1)) ' trials each)']);   
    ylabel('Probability');
    xlim([0 size(blockAveragedDownSignal,1)]); ylim([0 1]);
end
end
