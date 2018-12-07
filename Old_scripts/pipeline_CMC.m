%% Branch 1. basic config - PEDRO
computer = 'Ying_iMAC_SEEG';
AddPaths(computer)
parpool(4) % initialize number of cores

%% Initialize Directories
project_name = 'CMC';%

%% Create folders
sbj_name ='S10_LZJ';%'S09_XKW';%'S08_LWP';%'S07_YHY';%'S06_LXY';%'S05_PZY';%'S04_CWG';%'S03_FSM';%'S01_HHL'%'S02_PJC';%;%'S03_FSM';%'S02_PJC';%'S01_HHL';%

% Center
center = 'China';
% center = 'Stanford';
block_names = BlockBySubj_CMC(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% Make sure your are connected to CISCO and logged in the server
dirs = InitializeDirs_GZ(computer, project_name,sbj_name, false);

%%
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name,center);

%% Create subject folders
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format,false)

%% Get marked channels and demographics
%[refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate

%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
else
    error('Data format has to be edf format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'CMC'
        OrganizeTrialInfoCMC(sbj_name, project_name, block_names, dirs)
end


%% Branch 3 - event identifier
EventIdentifierCMC(sbj_name, project_name, block_names, dirs,[9 10 11 12])
%EventIdentifier(sbj_name, project_name, block_names, dirs, 2, 0) % new ones, photo = 1; old ones121, photo = 2; china, photo = varies, depends on the clinician
% Fix it for UCLA
% subject 'S11_29_RB' exception = 1 for block 2


%% Branch 4 - bad channel rejection
BadChanRejectCAR(sbj_name, project_name, block_names, dirs)

%% Branch 5 - Time-frequency analyses
% Load elecs info
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
%elecs = [1:4];
for i = 1:length(block_names)
    parfor ei = 1:length(elecs)
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], [], [], 'Band') % only for HFB
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], 200, true, 'Spec') % across frequencies of interest
    end
end

%% Branch 6 - Epoching, identification of bad epochs and baseline correction

epoch_params = genEpochParams_GZ(project_name, 'stim'); 

for i = 1:length(block_names)
    bn = block_names{i};
    parfor ei = 1:length(elecs) 
        EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
        EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
    end
end

% four conditions
plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames4',[],plot_params)


plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames4',[],plot_params,'Band') %{'autobio-specific','autobio-general'}


%% two conditions cic

plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNamescic',[],plot_params)


plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNamescic',[],plot_params,'Band') %{'autobio-specific','autobio-general'}


%% two conditions attend va
plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNamesva',[],plot_params)


plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNamesva',[],plot_params,'Band') %{'autobio-specific','autobio-general'}


%% stats
[~, ~, ~, ~, ~, ~, hfb_elecs_CIC_hfb] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNamescic',{'C','IC'},[],'Band',1,[],'CIC');
[~, ~, ~, ~, ~, ~, hfb_elecs_AV_hfb] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNamesva',{'Attend-A','Attend-V'},[],'Band',1,[],'AV');

[~, ~, ~, ~, ~, ~, hfb_elecs_CIC] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNamescic',{'C','IC'},[],'Spec',1,[],'CIC');            
[~, ~, ~, ~, ~, ~, hfb_elecs_AV] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNamesva',{'Attend-A','Attend-V'},[],'Spec',1,[],'AV');


% Delete non epoch data after epoching
deleteContinuousData(sbj_name, dirs, project_name, block_names, 'HFB', 'Band')
deleteContinuousData(sbj_name, dirs, project_name, block_names, 'SpecDense', 'Spec')


