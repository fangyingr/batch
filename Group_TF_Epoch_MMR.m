clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'Hippocampus';'PMC';'mPFC'};%};%
sbj_names ={'S18_131'};%{'S12_42_NC';'S17_118_TW';'S18_119_AG';'S12_33_DA';'S12_38_LK';'S18_130_RH'};%{'S17_118_TW';'S18_119_AG';};%{'S17_118_TW';'S18_124_JR2';'S12_38_LK';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S18_125';'S13_47_JT2'};%'S12_33_DA';'S12_38_LK';'S17_118_TW';'S12_42_NC';'S12_33_DA'};%{'S17_118_TW'}%;%

server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
for subi=1:length(sbj_names)
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
       % [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
        elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
       % elecs=[83 66]
        if ~isempty(elecs)
            %wavelet
            for i = 1:length(block_names)
                parfor ei = 1:length(elecs)   
                    WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], 500, true, 'Band')
                   % WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], 200, true, 'Spec') % only for HFB
                end
            end
            
            %Epoch
            
            epoch_params = genEpochParams(project_name, 'stim');
            
            for i = 1:length(block_names)
                bn = block_names{i};
                parfor ei = 1:length(elecs)
                    EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
                   % EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
                end
            end
            %elecs=[71 51];
           % elecs=[74 66];
            plot_params = genPlotParams(project_name,'timecourse');
            plot_params.noise_method = 'trials'; %'trials','timepts','none'
            plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs'}%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
            plot_params.multielec = false;
            PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math'},plot_params,'Band') %{'autobio-specific','autobio-general'}
          %  PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','TrueFalse',{'Auto_true','Auto_false'},plot_params,'Band') %{'autobio-specific','autobio-general'}
            
%             
            plot_params = genPlotParams(project_name,'ERSP');
            plot_params.noise_method = 'trials'; %'trials','timepts','none'
            plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%;%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
            PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames',{'autobio','math'},plot_params)
            
        else
            disp('No electrodes in this regions')
        end
    end
end