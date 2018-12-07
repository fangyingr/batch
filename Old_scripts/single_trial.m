
y_lim=[-2,5];
x_lim=[-0.2,2];
figureDim = [0 0 .8 .8];
    figure('units', 'normalized', 'outerposition', figureDim)
 for ci=1:length(cond_names)
     clf;
for i=1:size(plot_data{ci},1)
    
    subplot(6,8,i)
   
    plot(data.time,plot_data{ci}(i,:),'LineWidth',1)
    ylim(y_lim);
    xlim(x_lim);
    hold on
    plot([0 0],y_lim, 'Color', [0 0 0], 'LineWidth',1)
    plot(x_lim,[0 0], 'Color', [.5 .5 .5], 'LineWidth',1)
    xlabel('time');
    ylabel('z power')
    
end

suptitle([data.label,'-',cond_names{ci}]);%'previous trial'

saveas(gcf,['/Users/yingfang/Documents/data/Results/MMR/Group/S42_',data.label,'_',cond_names{ci},'.png'])

 end