SA(:,6) = mean(SA,2)

for ii = 1:5
    plot(SA(:,ii),'Color','[0.6350 0.0780 0.1840]')
    hold on
end

plot(SA(:,end),'Color','r','LineWidth',2)
hold off