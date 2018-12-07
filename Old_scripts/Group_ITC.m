clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S12_33_DA'};%'S12_38_LK';'S12_42_NC';'S13_47_JT2';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125'};
locktype ='stim';

plot_params = genPlotParams(project_name,'ITPC');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};
for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs('Ying_iMAC', project_name,sbj_name, false);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            
            %PAC = computePACAll(sbj_name,project_name,block_names,dirs,elecs,[],[],'SpecDense','stim','condNames',{'autobio','math'},[]);
            
            PlotITPCAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames',{'autobio','math'},plot_params)
            
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end