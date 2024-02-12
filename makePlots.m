function varargout = makePlots(trials,rig,win,varargin)

if length(varargin) > 0
    isi = varargin{1};
    session = varargin{2};
    us = varargin{3};
    cs = varargin{4};
else
    isi = 250;
    session = 1; % Session s01
    us = 3;
    cs = 5;
end

%% Eyelid traces
pairedtrials = find(trials.c_usdur>0 & trials.c_csnum==5); % & trials.session_of_day == 2);
idx = 1:length(pairedtrials);
eyelid1 = trials.eyelidpos(pairedtrials,:);
calibmin1 = min(eyelid1');
calibmin = min(calibmin1); %use only most extreme value from all trials
eyelid2 = eyelid1-calibmin;
calibmax1 = max(eyelid2');
calibmax = max(calibmax1); %use only most extreme value from all trials
eyelid3 = eyelid2./calibmax;
%keepers1 = find((mean(eyelid3(:, 1:66),2))<0.3 | (mean(eyelid3(:, 1:66),2))==0.3);
%keepers = eyelid3(keepers1,:);
%losers1 = setdiff(idx,keepers1);
%losers = eyelid3(losers1,:);
%idx2 = 1:length(keepers1);

%keepers2 = keepers(:,:) - mean(keepers(:,1:66),2);
%maxnorm1 = max(keepers2');
%maxnorm = max(maxnorm1);
%keepers3 = keepers2(:,:)./maxnorm;

hf1=figure;
hax=axes;

set(hax,'ColorOrder',jet(length(idx)),'NextPlot','ReplaceChildren');
%plot(trials.tm(1,:),keepers3(idx2,:))
plot(trials.tm(1,:),eyelid3(idx,:))
hold on 
%plot(trials.tm(1,:),mean(keepers3(idx2,:)),'k','LineWidth',2)
plot(trials.tm(1,:),mean(eyelid3(idx,:)),'k','LineWidth',2)
axis([trials.tm(1,1) trials.tm(1,end) -0.1 1.1])
title('CS-US')
xlabel('Time from CS (s)')
ylabel('Eyelid pos (FEC)')

%% CR amplitudes
%idx = 1:length(cs10trials);
%idx2 = 1:length(keepers1);
%cramp = mean(keepers3(:,win),2) - mean(keepers3(:,1:66),2); 
if strcmp(rig,'black') == 1 
    cramp = mean(eyelid3(:,win),2) - mean(eyelid3(:,1:66),2); 
elseif strcmp(rig,'blue') == 1
    cramp = mean(eyelid3(:,win),2) - mean(eyelid3(:,1:10),2);
end
CRprob = length(cramp(cramp>0.1))/length(idx)
CRamp = mean(cramp(cramp>0.1))

hf2=figure;
%plot(trials.trialnum(idx,:),cramp(idx),'.')
plot(cramp(idx),'.')
hold on
%plot([1 length(trials.trialnum)],[0.1 0.1],':k')
%axis([1 length(trials.trialnum) -0.1 1.1])
%plot([1 length(cs10trials)],[0.1 0.1],':k')
%axis([1 length(cs10trials) -0.1 1.1])
plot([1 length(idx)],[0.1 0.1],':k')
axis([1 length(idx) -0.1 1.1])
title('CS-US')
xlabel('Trials')
ylabel('CR size')

if nargout > 0
    varargout{1}=hf1;
    varargout{2}=hf2;
    varargout{3}=CRprob;
    varargout{4}=CRamp;
end
