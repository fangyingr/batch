

clear;clc;close all;
project_name='Memoria';
sbj_names ={'S14_69_RTb';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S16_99_CJ';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;
%'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%
regions = {'PMC';'mPFC';'Hippocampus'};%;;};%};%;'Hippocampus'
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';%'/Volumes/Ying_SEEG/ParviziLab';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

locktype='stim';
tag = [locktype,'lock_bl_corr'];
noise_fields_trials ={'bad_epochs_HFO','bad_epochs_raw_HFspike','bad_epochs_raw_LFspike'};
conds={'autobio'};%{'numword'};%{'autobio'}%{'autobio'}
smooth=1;
data_all.allonsets=[];
for ri=1:length(regions)
    data_all.(regions{ri}).wave=[];
    data_all.(regions{ri}).trialsect=[];
    data_all.(regions{ri}).label=[];
    data_all.average.(regions{ri})=[];
    bindata{ri}=[];
    for subi=1:length(sbj_names)
        sbj_name = sbj_names{subi};
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        if ~isempty(elecs)
            averagedata=[];
            for ei = 1:length(elecs)
                el = elecs(ei);
                
                data=[];
                data = concatBlocks(sbj_name,block_names,dirs,el,'HFB','Band',{'wave'},tag);
                [grouped_trials_all,~] = groupConds(conds,data.trialinfo,'conds_all','trials',noise_fields_trials,false);
                data_all.(regions{ri}).wave=[data_all.(regions{ri}).wave;data.wave(grouped_trials_all{1},:)];
                data_all.(regions{ri}).trialsect=[data_all.(regions{ri}).trialsect;grouped_trials_all{1}];
                data_all.(regions{ri}).label=[data_all.(regions{ri}).label;{data.label}];
                data_all.allonsets=[data_all.allonsets;data.trialinfo.allonsets(grouped_trials_all{1},:)];
                data_all.average.(regions{ri})=[data_all.average.(regions{ri});nanmean(data.wave(grouped_trials_all{1},:),1)];
                averagedata=[averagedata;nanmean(data.wave(grouped_trials_all{1},:),1)];
            end
            time_events=[];
            time_events = cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)));
            time_events=[-0.5,0,time_events];
            bp=[];
            for bi=1:size (time_events,2)-1
                tindx=[];
                tindx=find(data.time>time_events(bi)&data.time<=(time_events(bi))+1);
                bp(:,bi)=nanmean(averagedata(:,tindx),2);
                
            end
            bindata{ri}=[bindata{ri};bp];
        else
            disp('no elecs in this region')
        end
    end
end

%% calculate bin data
for ri=1:length(regions)
    for bi=1:size (time_events,2)-1
        bindata_ave(ri,bi)=nanmean(bindata{ri}(:,bi),1);
        se(ri,bi)=nanstd(bindata{ri}(:,bi),1)/sqrt(size(bindata{ri}(:,bi),1));
    end
end
%% stats

save('/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/BinPower/Group_average_bin_power.mat','bindata','bindata_ave','se')




%% Statics
region_pairs={'PMC','mPFC';'PMC','Hippocampus';'mPFC','Hippocampus'};
region_num=[1 2; 1 3; 2 3];
for i=1:length(region_pairs)
    
    for j=1:5
        [p(i,j),~,~] = permutationTest(bindata{region_num(i,1)}(:,j),bindata{region_num(i,2)}(:,j),10000);
    end
    
end

 [p_fdr, p_masked] = fdr( p, 0.05);

