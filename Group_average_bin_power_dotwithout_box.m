

load('/Users/yingfang/Documents/lbcn_preproc/vizualization/colormaps/cdcol_2018.mat')

sbj_names ={'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;
%
colors = [cdcol.indian_red; cdcol.light_olive_40; cdcol.azurite_blue; cdcol.raw_russet;  cdcol.yellow; ...

cdcol.sky_blue;cdcol.jade_green; cdcol.fast_orange; cdcol.turquoise_green; cdcol.violet; cdcol.raspberry_red;...

cdcol.veronese_green; cdcol.sapphire_blue; cdcol.silver_2; cdcol.flame_red; cdcol.purple; cdcol.cobalt_blue_10; ...

cdcol.middle_phthalocyanine_green];

set(0,'defaultfigurecolor','w')

regions = {'Hippocampus';'PMC';'mPFC'};

figure('Position',[200 200 1200 550])

x=[1 2 3 5 6 7 9 10 11 13 14 15 17 18 19];
label={'Hippo','PMC','mPFC','Hippo','PMC','mPFC','Hippo','PMC','mPFC','Hippo','PMC','mPFC','Hippo','PMC','mPFC'};
% colors=[109 193 165;
%     142 161 201;
%     248 141 103]./255;

k=1;
%+sqrt(0.02)*rand()
for si= 1:5
    for ri =1:length(regions)
        xval =ones(1,size(data.(regions{ri}).binpower,1))*x(k);
       
        k=k+1;
        
                for ii=1:length(data.(regions{ri}).binpower(:,si))
        
                    [~,d]=ismember(data.(regions{ri}).subname(ii),sbj_names);
                     catcolors=[];
                    catcolors =colors(d,:);
                    
                     if data.(regions{ri}).sigbin(ii,si)==1% && data.(regions{ri}).binpower(ii,si)>0
                     plot(xval,data.(regions{ri}).binpower(ii,si),'*','MarkerSize',10,'MarkerFaceColor', catcolors)%plot_params.col(8,:)
                     else
                     plot(xval,data.(regions{ri}).binpower(ii,si),'c.','MarkerSize',20,'Color', catcolors)%plot_params.col(8,:)
                     end
                     hold on
%                     if data.(regions{ri}).sigbin(ii,si)==1;
%                         catcolors_edge(ii,:)=[0 0 0];
%                     else
%                         catcolors_edge(ii,:)= catcolors(ii,:);
%                     end
                end
        
%         for i = 1:length(catcolors)
%             
%             
%              hold on
% %             set([H(i).data], 'MarkerFaceColor',[1 1 1]*0.8,'MarkerEdgeColor',[1 1 1]*0.3, 'MarkerSize',3.5)
% %             
% %             set(H(i).sdPtch,'FaceColor',colors(ri,:),'EdgeColor','none')
% %             
% %             set(H(i).semPtch,'FaceColor',colors(ri,:)*0.85,'EdgeColor','none')
% %             
% %             set([H(i).mu],'color','w')
% %             
%         end
%         
       % hold on
    end
end
plot([0 20],[0 0],'k-','LineWidth',3)
box off
%ylim([-1 4])
set(gca,'xtick',x)
set(gca,'xticklabel',label,'FontSize',14)
set(gca, 'LineWidth',2)
ylabel('Z-score Power','FontSize',20);

Legend(sbj_names)
%axis off



hold on