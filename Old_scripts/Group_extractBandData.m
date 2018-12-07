clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'mPFC';'Hippocampus';'PMC';};%};%
sbj_names ={'S17_118_TW'}%;'S18_124_JR2';'S12_38_LK';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S18_119_AG';'S18_125';'S13_47_JT2'};%'S12_33_DA';'S12_38_LK';'S17_118_TW';'S12_42_NC';'S12_33_DA'};%{'S17_118_TW'}%;%


blc_params.run = true; % or false
blc_params.locktype = 'stim';
blc_params.win = [-.2 0];
tmax = 2;

for subi=1:length(sbj_names)
    ROLthetamean=[];
    ROLHFBmean=[];
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs('Ying_iMAC', project_name,sbj_name);
    block_names = BlockBySubj(sbj_name,project_name);
    
    %     for ri=1:length(regions)
    %         elec_names=[];elecs=[];
    %         [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
    %  elecs = 100;
    if ~isempty(elecs)
        %wavelet
%         for i = 1:length(block_names)
%             parfor ei = 1:length(elecs)
%                 % WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'Theta', [], 500, true, 'Band')
%                 WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], 500, true, 'Band')
%                 WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], 200, true, 'Spec') % only for HFB
%             end
%         end
%         
%         %%Epoch
%         
%         epoch_params = genEpochParams(project_name, 'stim');
%         
%         for i = 1:length(block_names)
%             bn = block_names{i};
%             parfor ei = 1:length(elecs)
%                 EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
%                 EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
%             end
%         end
        %             for i = 1:length(block_names)
        %                 parfor ei = 1:length(elecs)
        %                    % EpochDataAll(sbj_name, project_name, block_names{i}, dirs,elecs(ei),'stim', [], tmax, 'Theta', [],[], blc_params,[],'Band')
        %                     EpochDataAll(sbj_name, project_name, block_names{i}, dirs,elecs(ei),'stim', [], tmax, 'HFB', [],[], blc_params,[],'Band')
        %                     EpochDataAll(sbj_name, project_name, block_names{i}, dirs,elecs(ei),'stim', [], tmax, 'SpecDense', [],[], blc_params,[],'Spec')
        %                 end
        %             end
        %             % extract data
        %             for bi=1:length(block_names)
        %                 parfor ei=1:length(elecs)
        %                      extractBandData(sbj_name,project_name,block_names{bi},dirs,elecs(ei),'Theta','stim','SpecDenseTH')
        %                      extractBandData(sbj_name,project_name,block_names{bi},dirs,elecs(ei),'HFB','stim','SpecDenseTH')
        %                 end
        %             end
        %
        % plot
        
        
        plot_params = genPlotParams(project_name,'timecourse');
        plot_params.noise_method = 'trials'; %'trials','timepts','none'
        plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs'}%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
        plot_para.xlim=[-0.2,2];
        %PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','trialhistory',{'task after rest','task after task'},plot_params,'Band') %{'autobio-specific','autobio-general'}
        
        % PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','trialhistory_rm',{'memory after rest','memory after memory','memory after math'},plot_params,'Band') %{'autobio-specific','autobio-general'}
        
        % PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','trialhistory_rma',{'math after rest','math after autobio','math after math'},plot_params,'Band') %{'autobio-specific','autobio-general'}
        
        %  PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'Theta','stim','condNames',{'autobio','math','rest'},plot_params,'Band') %{'autobio-specific','autobio-general'}
        PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math','rest'},plot_params,'Band') %{'autobio-specific','autobio-general'}
        
        
        plot_params = genPlotParams(project_name,'ERSP');
        plot_params.noise_method = 'trials'; %'trials','timepts','none'
        plot_params.noise_fields_trials = {'bad_epochs'}%{'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
        PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames',{'autobio','math'},plot_params)
        %  PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','trialhistory_rma',{'math after rest','math after autobio','math after math'},plot_params)
        %
        %         else
        %
        %             disp('No electrodes in this regions')
        %
        %         end
    end
end