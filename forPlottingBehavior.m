data(:,end+1) = mean(data,2)

for ii = 1:size(data,2)-1
    plot(data(:,ii),'Color','[0.6350 0.0780 0.1840]')
    hold on
end

plot(data(:,end),'Color','r','LineWidth',2)
hold off
