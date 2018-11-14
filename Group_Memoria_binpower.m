
clear;clc;close all;
project_name='Memoria';
sbj_names ={'S17_118_TW';'S18_119_AG';'S18_130_RH'};
regions = {'PMC';'mPFC'};%;;};%};%;'Hippocampus'
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';
locktype='stim';
tag = [locktype,'lock_bl_corr'];
noise_fields_trials ={'bad_epochs_HFO','bad_epochs_raw_HFspike','bad_epochs_raw_LFspike'};
conds={'autobio'};
smooth=1;
data_all.allonsets=[];
for ri=1:length(regions)
    data_all.(regions{ri}).wave=[];
    data_all.(regions{ri}).trialsect=[];
    data_all.(regions{ri}).label=[];
    for subi=1:length(sbj_names)
        sbj_name = sbj_names{subi};
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        
        for ei = 1:length(elecs)
            el = elecs(ei);
            
            data=[];
            data = concatBlocks(sbj_name,block_names,dirs,el,'HFB','Band',{'wave'},tag);
            [grouped_trials_all,~] = groupConds(conds,data.trialinfo,'condNames','trials',noise_fields_trials,false);
            data_all.(regions{ri}).wave=[data_all.(regions{ri}).wave;data.wave(grouped_trials_all{1},:)];
            data_all.(regions{ri}).trialsect=[data_all.(regions{ri}).trialsect;grouped_trials_all{1}];
            data_all.(regions{ri}).label=[data_all.(regions{ri}).label;{data.label}];
            data_all.allonsets=[data_all.allonsets;data.trialinfo.allonsets(grouped_trials_all{1},:)];
        end
    end
end

%% calculate bin data
time_events = cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)));
time_events=[0,time_events];
for ri=1:length(regions)
                for bi=1:size (time_events,2)-1
                    tindx=[];
                    tindx=find(data.time>time_events(bi)&data.time<=time_events(bi+1));
                    bindata{ri}(:,bi)=nanmean(data_all.(regions{ri}).wave(:,tindx),2);
                end
 
end

%% stats

for i=1:size(time_events,2)-1
[p(i), observeddifference(i), effectsize(i)] = permutationTest(bindata{1}(:,i),bindata{2}(:,i),10000)
end

median(bindata{1})
median(bindata{2})
%% smooth
for ri=1:length(regions)
    if smooth
        winSize = floor(data.fsample*0.2);
        gusWin= gausswin(winSize)/sum(gausswin(winSize));
        data_all.(regions{ri}).wave = convn( data_all.(regions{ri}).wave,gusWin','same');
    end
end


%% plot
plot_params = genPlotParams(project_name,'timecourse');
figureDim = [0 0 .2 .4];
figure('units', 'normalized', 'outerposition', figureDim)
set(gcf,'color','w')

lineprops.style= '-';
lineprops.width = plot_params.lw;
lineprops.edgestyle = '-';


for ri=1:length(regions)
    lineprops.col{1}=plot_params.col(ri,:);
    mseb(data.time,nanmean(data_all.(regions{ri}).wave),nanstd(data_all.(regions{ri}).wave)/sqrt(size(data_all.(regions{ri}).wave,1)),lineprops,1);
    hold on
    h(ri)=plot(data.time,nanmean(data_all.(regions{ri}).wave),'LineWidth',plot_params.lw,'Color',plot_params.col(ri,:));
end

y_lim = ylim;



for i = 1:length(time_events)-1
    plot([time_events(i) time_events(i)],y_lim,'Color', [.5 .5 .5], 'LineWidth',1)
end
%plot([0 0],y_lim,'Color', [.5 .5 .5], 'LineWidth',1)
plot(xlim,[0 0],'Color', [.5 .5 .5], 'LineWidth',1)
title('Memory Response (group level)')
set(gca,'fontsize',20)
box off
set(gca,'linewidth',1.5)
xlim([-0.5,6])
xlabel(plot_params.xlabel);
ylabel(plot_params.ylabel);
leg = legend(h,regions,'Location','Northeast', 'AutoUpdate','off');
legend boxoff
set(leg,'fontsize',14, 'Interpreter', 'none')


