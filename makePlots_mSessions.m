function varargout = makePlots_mSessions(trials,rig,win,times,varargin)

if length(varargin) > 1
    isi = varargin{1};
    session = varargin{2};
    us = varargin{3};
    cs = varargin{4};
else
    isi = 250;
    session = 1; % Session s01
    us = 3; %triggers airpuff; arduino COM3
    cs = 5; %triggers speaker; refers to 5 kHz tone
end

%% Eyelid traces

if strcmp(rig,'black') == 1
    trials.eyelidpos = trials.eyelidpos(:,1:200);
    trials.tm = repmat(times,size(trials.tm,1),1);
end
pairedtrials1 = find(trials.c_usdur>=0 & trials.c_csnum==5 & trials.session_of_day == 1);
pairedtrials2 = find(trials.c_usdur>=0 & trials.c_csnum==5 & trials.session_of_day == 2);
idx = 1:size(pairedtrials1,1)+size(pairedtrials2,1);
eyelid1 = trials.eyelidpos(pairedtrials1,:);
eyelid2 = trials.eyelidpos(pairedtrials2,:);
calibmin1 = min(eyelid1');
calibmin2 = min(eyelid2');
calibmin1b = min(calibmin1); %use only most extreme value from all trials
calibmin2b = min(calibmin2);
eyelid2a = eyelid1-calibmin1b;
eyelid2b = eyelid2-calibmin2b;
calibmax1 = max(eyelid2a');
calibmax2 = max(eyelid2b');
calibmax1b = max(calibmax1); %use only the most extreme value from all trials
calibmax2b = max(calibmax2);
eyelid3a = eyelid2a./calibmax1b;
eyelid3b = eyelid2b./calibmax2b;
eyelid3 = cat(1, eyelid3a, eyelid3b);

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
    cramp = mean(eyelid3(:,win),2) - mean(eyelid3(:,1:10),2); 
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
