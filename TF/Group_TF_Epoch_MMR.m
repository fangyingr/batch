clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'PMC';'mPFC';'Hippocampus'};
sbj_names ={'S12_38_LK'};%'S17_104_SW';{'S12_42_NC'};%'S17_105_TA'
%}%'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_130_RH';'S12_33_DA';'S12_42_NC';'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_116';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

% 
% for i = 1:length(sbj_names)
%     block_names = BlockBySubj(sbj_names{i},project_name);
%     dirs = InitializeDirs(project_name,sbj_names{i},comp_root,server_root,code_root);
%     UpdateGlobalVarDirs(sbj_names{i}, project_name, block_names, dirs)
% 
%     OrganizeTrialInfoMMR_rest(sbj_names{i}, project_name, block_names, dirs)
%     EventIdentifier(sbj_names{i}, project_name, block_names, dirs, 1) %% old s is dc 2
%     close all
%   end


for subi=1:length(sbj_names)
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
    block_names = BlockBySubj(sbj_name,project_name);
  
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
       [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
%         load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
%         elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
        elecs=[82];
        if ~isempty(elecs)
            %wavelet
            for i = 1:length(block_names)
                parfor ei = 1:length(elecs)   
                    WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], 500, false, 'Band')
                   % WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], 200, true, 'Spec') % only for HFB
                end
            end
%             
%             %Epoch
%             
            epoch_params = genEpochParams(project_name, 'stim');%'resp'
             epoch_params.blc.bootstrap = true; 
        
            for i = 1:length(block_names)
                bn = block_names{i};
                for ei = 1:length(elecs)
                    EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
                  % EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
                end
            end
%             %elecs=[71 51];
        %    elecs=[83 66];
            plot_params = genPlotParams(project_name,'timecourse');
            plot_params.noise_method = 'trials'; %'trials','timepts','none'
            plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs'}%
            plot_params.multielec = false;
           % plot_params.col=[141,160,203;252,141,98;102,194,165]./255;
           % PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math'},plot_params,'Band') %{'autobio-specific','autobio-general'}
            PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio'},plot_params,'Band') %{'autobio-specific','autobio-general'}
          
            %  PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','TrueFalse',{'Auto_true','Auto_false'},plot_params,'Band') %{'autobio-specific','autobio-general'}
            
%             
%             plot_params = genPlotParams(project_name,'ERSP');
%             plot_params.noise_method = 'trials'; %'trials','timepts','none'
%             plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%;%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
%             PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames',{'autobio','math'},plot_params)
%             
        else
            disp('No electrodes in this regions')
        end
    end
end