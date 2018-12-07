clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'PMC','mPFC'};%'Hippocampus','PMC';;'Hippocampus','mPFC'
sbj_names ={'S17_118_TW';'S18_119_AG';'S18_130_RH'};%{'S12_42_NC'}%;'S12_38_LK';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125'};%'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%
locktype ='stim';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';

for subi=1:length(sbj_names)
    for ri =1:size(regions,1)
        sbj_name = sbj_names{subi};
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        clear elec*
        [elec_names1,elecs1] = ElectrodeBySubj(sbj_name,regions{ri,1});
        [elec_names2,elecs2] = ElectrodeBySubj(sbj_name,regions{ri,2});
     
        if ~isempty(elecs1) && ~isempty(elecs2)
            
            tag=[regions{ri,1},'_',regions{ri,2}];
            plot_params = genPlotParams(project_name,'timecourse');
            plot_params.noise_method = 'trials';%'timepts';%'trials'; %'trials','timepts','none'
            plot_params.noise_fields_trials ={'bad_epochs_HFO','bad_epochs_raw_HFspike','bad_epochs_raw_LFspike'};%{'bad_epochs'};%%{'bad_epochs_raw_jump','bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%;%%
            plot_params.devidemax=false;%true;
            plot_params.multielec=true;
            plot_params.lw = 2;
            %plot_params.single_trial=1;
            %plot_params.noise_fields_timepts= {'bad_inds_HFO','bad_epochs_raw_LFspike','bad_inds_raw_HFspike'}
            PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio'},plot_params,'Band') %,'math'{'autobio-specific','autobio-general'}
            
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end