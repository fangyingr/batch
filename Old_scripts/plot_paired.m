

clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'Hippocampus','PMC';'PMC','mPFC';'Hippocampus','mPFC'};
sbj_names ={'S12_38_LK';'S12_42_NC';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125';'S12_33_DA';};%'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%
locktype ='stim';
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'}%{'bad_epochs'};%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_para.xlim=[-0.2,2];
plot_params.multielec=true;
plot_params.ylabel = 'z-scored power';


for subi=1:length(sbj_names)
    for ri =1:size(regions,1)
        sbj_name = sbj_names{subi};
        dirs = InitializeDirs('Ying_iMAC', project_name,sbj_name, false);
        block_names = BlockBySubj(sbj_name,project_name);
        
        clear elec*
        [elec_names1,elecs1] = ElectrodeBySubj(sbj_name,regions{ri,1});
        [elec_names2,elecs2] = ElectrodeBySubj(sbj_name,regions{ri,2});
        if ~isempty(elecs1) && ~isempty(elecs2)
            
            tag=[regions{ri,1},'_',regions{ri,2}];
            
            elecs11=repmat(elecs1,1,numel(elecs2));
            elecs22=repmat(elecs2,1,numel(elecs1));
            elecs11=sort(elecs11);
            
            elecs=[elecs11',elecs22'];
            
            for ei=1:length(elecs)
            
            PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs(ei,:),'HFB','stim','condNames',{'autobio'},plot_params,'Band')
            end
            
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end