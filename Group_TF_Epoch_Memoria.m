

clear all;clc;
computer = 'Ying_SEEG';
%AddPaths(computer)
project_name = 'Memoria';
center = 'Stanford';
regions = {'Hippocampus';'mPFC';'PMC'};%;%;'Hippocampus''mPFC';'PMC'
sbj_names ={'S16_99_CJ';'S18_131';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S17_116';'S18_127';'S18_128_CG';'S17_105_TA';'S18_126';'S14_69_RTb';'S16_100_AF';'S17_104_SW';'S18_130_RH';'S18_129'};
%%;
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';%'/Volumes/Ying_SEEG/ParviziLab';
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
for subi=1:length(sbj_names)
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
    block_names = BlockBySubj(sbj_name,project_name);
    
    %% update globalVar
    % % %     [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
    % % %     CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format,0)
    % % %    % updateGlobalVar(project_name,sbj_name,dirs,comp_root,block_names)
    % % %
    %% event identifier
    %     if ismember(sbj_name,'S17_110_SC')
    %
    %         OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs,'spanish')
    %     else
    %         OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs,'english')
    %     end
    %
    %     EventIdentifier_Memoria(sbj_name, project_name, block_names, dirs)
    %
    %     pause;
    %     close all;
    % for ri=1:length(regions)
    elec_names=[];elecs=[];
    %         [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
    %elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
    elecs=1:globalVar.nchan;
    
    if ~isempty(elecs)
        
        
%         %%wavelet
%         for i = 1:length(block_names)
%             parfor ei = 1:length(elecs)
%                 WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], 500, true, 'Band')
%                 % WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], 200, true, 'Spec') % only for HFB
%             end
%         end
        
        % epoch
        epoch_params = genEpochParams(project_name, 'stim');
        epoch_params.blc.bootstrap = true; 
        
        for i = 1:length(block_names)
            bn = block_names{i};
            
            parfor ei = 1:length(elecs)
                EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
                % EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
            end
        end
        
        epoch_params = genEpochParams(project_name, 'resp');
       epoch_params.blc.bootstrap = true;
        for i = 1:length(block_names)
            bn = block_names{i};
            
            parfor ei = 1:length(elecs)
                EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
                % EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
            end
        end
        %
        
        plot_params = genPlotParams(project_name,'timecourse');
        plot_params.noise_method = 'trials';%'timepts';%'trials'; %'trials','timepts','none'
        plot_params.noise_fields_trials ={'bad_epochs_HFO','bad_epochs_raw_HFspike','bad_epochs_raw_LFspike'};%{'bad_epochs'};%%{'bad_epochs_raw_jump','bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%;%%
        plot_params.devidemax=false;%true;
        plot_params.multielec=false;
        %plot_params.lw = 2;
        %plot_params.single_trial=1;
        %plot_params.noise_fields_timepts= {'bad_inds_HFO','bad_epochs_raw_LFspike','bad_inds_raw_HFspike'}
        % PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','conds_all',{'autobio','numword'},plot_params,'Band')
        PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math'},plot_params,'Band') %,'math'{'autobio-specific','autobio-general'}
        
        
        plot_params.xlim = [-5 1];
        %  PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','resp','conds_all',{'autobio','numword'},plot_params,'Band')
        PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','resp','condNames',{'autobio','math'},plot_params,'Band') %,'math'{'autobio-specific','autobio-general'}
        
        %  PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','newcondNames',{'autobio-specific','autobio-general'},plot_params,'Band') %
        %
        %             plot_params = genPlotParams(project_name,'ERSP');
        %             plot_params.noise_method = 'trials'; %'trials','timepts','none'
        %             plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};% {'bad_epochs'};%;%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
        %             PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames',{'autobio','math'},plot_params);
        %
    else
        
        disp('No electrodes in this regions')
        
        % end
    end
end