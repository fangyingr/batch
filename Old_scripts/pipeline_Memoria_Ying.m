%% Branch 1. basic config - PEDRO
%% Branch 1. basic config - PEDRO
computer = 'Ying_iMAC';
AddPaths(computer)

parpool(4) % initialize number of cores

%% Initialize Directories

project_name = 'Memoria';

%% Create folders


sbj_name ='S18_131';%'S18_129'%'S17_105_TA';%'S18_128_CG';%'S17_116';%%'S17_104_SW';%'S14_69_RTb';% 'S18_131'%'S17_104_SW'%'S18_119_AG';%''S18_130_RH';%'S18_119_AG';%'S17_118_TW';

center = 'Stanford';

%% Get block names
block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% Make sure your are connected to CISCO and logged in the server
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';%'//Volumes/Ying_SEEG/Data_lbcn';%
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);

%%
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

xcorr_params = genXCorrParams(project_name);
xcorr_all =laggedCorrPerm(sbj_name,project_name,block_names,dirs,elecs,elecs,'HFB',xcorr_params,'condNames',{'autobio'});

%% Get iEEG and Pdio sampling rate and data format
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

%% Create subject folders
load_server_files = 1;
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format,load_server_files) 
%%% IMPROVE uigetfile to go directly to subject folder %%%

% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly
% At this stage, paste the EDF or TDT files into the originalData folder
% and the behavioral files into the psychData
% (unless if using CopyFilesServer, which is still under development)

%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
% parfor i = 1:length(block_names)
for i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end
% In the case of number comparison, one has also to copy the stim lists

%% Get marked channels and demographics
%[refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate

%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
    % MAYBE NOT CHANGE DC CHANNEL LABELS. No need to call them PDIO? 
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'MMR'
%         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'Memoria'
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs,'spanish')
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_China'
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_production'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Number_comparison'
        OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from 
end
%parpool(4) % initialize number of cores

%% Initialize Directories

project_name = 'Memoria';

%% Create folders


sbj_name ='S17_105_TA';%'S18_128_CG';%'S17_116';%%'S17_104_SW';%'S14_69_RTb';% 'S18_131'%'S17_104_SW'%'S18_119_AG';%''S18_130_RH';%'S18_119_AG';%'S17_118_TW';

center = 'Stanford';

%% Get block names
block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% Make sure your are connected to CISCO and logged in the server
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '//Volumes/Ying_SEEG/Data_lbcn';%'/Users/yingfang/Documents/data';
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);

%% Get iEEG and Pdio sampling rate and data format
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

%% Create subject folders
load_server_files = 0;
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format,load_server_files) 
%%% IMPROVE uigetfile to go directly to subject folder %%%

% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly
% At this stage, paste the EDF or TDT files into the originalData folder
% and the behavioral files into the psychData
% (unless if using CopyFilesServer, which is still under development)

%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
% parfor i = 1:length(block_names)
for i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end
% In the case of number comparison, one has also to copy the stim lists

%% Get marked channels and demographics
%[refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate

%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
    % MAYBE NOT CHANGE DC CHANNEL LABELS. No need to call them PDIO? 
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'MMR'
%         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'Memoria'
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs,'english')
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_China'
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_production'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Number_comparison'
        OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?        
    case 'GradCPT'
        OrganizeTrialInfoGradCPT(sbj_name, project_name, block_names, dirs,1,'1')
end


% segment_audio_mic(sbj_name,project_name, dirs, block_names{1}) 


%% Branch 3 - event identifier
%EventIdentifier(sbj_name, project_name, block_names, dirs,1)

EventIdentifier_Memoria(sbj_name, project_name, block_names, dirs)

center = 'Stanford';

%% Get block names
block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% Make sure your are connected to CISCO and logged in the server
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '//Volumes/Ying_SEEG/Data_lbcn';%'/Users/yingfang/Documents/data';
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);

%% Get iEEG and Pdio sampling rate and data format
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

%% Create subject folders
load_server_files = 0;
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format,load_server_files) 
%%% IMPROVE uigetfile to go directly to subject folder %%%

% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly
% At this stage, paste the EDF or TDT files into the originalData folder
% and the behavioral files into the psychData
% (unless if using CopyFilesServer, which is still under development)

%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
% parfor i = 1:length(block_names)
for i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end
% In the case of number comparison, one has also to copy the stim lists

%% Get marked channels and demographics
%[refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate

%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
    % MAYBE NOT CHANGE DC CHANNEL LABELS. No need to call them PDIO? 
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'MMR'
%         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'Memoria'
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs,'english')
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_China'
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_production'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Number_comparison'
        OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?        
    case 'GradCPT'
        OrganizeTrialInfoGradCPT(sbj_name, project_name, block_names, dirs,1,'1')
end


% segment_audio_mic(sbj_name,project_name, dirs, block_names{1}) 


%% Branch 3 - event identifier
EventIdentifier(sbj_name, project_name, block_names, dirs,1)

EventIdentifier_Memoria(sbj_name, project_name, block_names, dirs)



%% Branch 4 - bad channel rejection
BadChanRejectCAR(sbj_name, project_name, block_names, dirs)
% 1. Continuous data
%      Step 0. epileptic channels based on clinical evaluation from table_.xls
%      Step 1. based on the raw power
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the power spectrum deviation
%      Step 4. Bad channel detection based on HFOs

% Creates the first instance of data structure inside car() function
% TODO: Create a diagnostic panel unifying all the figures

%% Branch 5 - Time-frequency analyses
% Load elecs info
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

for i = 1:length(block_names)
    parfor ei = 1:length(elecs)
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], [], [], 'Band') % only for HFB
       % WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDenseLF', [], [], true, 'Spec') % across frequencies of interest
    end
end

%% Branch 6 - Epoching, identification of bad epochs and baseline correction

epoch_params = genEpochParams(project_name, 'stim'); 
epoch_params.blc.bootstrap = true;
for i = 1:length(block_names)
    bn = block_names{i};
    parfor ei = 1:length(elecs) 
        EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
       % EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDenseLF', [],[], epoch_params,'Spec')
    end
end

%% RT phase correlation
phaseRT = phaseRTCorrAll(sbj_name, project_name, block_names,dirs,'stim',elecs);
plotPhaseRTCorr(sbj_name,project_name,dirs,elecs,[])

%% PLV
% S17_116
% SPL = {'RPG1','RPG2','RPG3','RPG9','RPG10'};
% PMC = {'RPT1'};
% VIS = {'RPG41','RPG42','RPG49','RPG57','RPG58','RO6','RO7','RO8','RO14'};
% elecs1 = PMC;
% elecs2 = VIS;

% S18_119
% SPL = {'LRSC7','LRSC8','LRSC9','LRSC10'}; 
% INS = {'LdINS1','LdINS2'};
% PMC = {'LRSC1','LRSC2','RRSC1','RRSC2','RRSC3'};
% elecs1 = SPL;
% elecs2 = PMC;

% S18_123
% SPL = {'LSPS9','LSPS10'};
% PMC = {'LIHG24'};
% VIS = {'LIHG32','LIOG7','LIOG14','LLPG1'};
% elecs1 = PMC;
% elecs2 = VIS;

% S18_124
SPL = {'LDP6','LDP7','RDP5','RDP6','RDP7'};
PMC = {'LDP1'};
INS = {'LAI6','LAI7'};
VIS = {'LTP1'};
elecs1 = PMC;
elecs2 = VIS;

% S14_69b
SPL = {'LP6','LP7','LPI17'};
PMC = {'LPI11','LPI12','LPI13'};
elecs1 = SPL;
elecs2 = PMC;

computePLVAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','trials','stim','SpecDenseLF','condNames',[],[])
% computePLVAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,pairing,PLVdim,locktype,freq_band,column,conds,plv_params)

%% Phase-amplitude coupling

% phase_elecs = {'RPT1','RPG1','RPG2','RPG9','RPG10'};
% phase_elecs = {'RPT1','RPG2','RPG9'}; %S17_116

% phase_elecs = {'LP6','LP7','LPS7','LPS8','LPI17','LPI11','LPI12','LP2','LP3','LP4','LPS1'}; %S14_69b

% phase_elecs = {'LRSC8','LRSC9','LRSC10','RRSC6','LRSC1','LRSC2','LRSC3','RRSC1','RRSC3','LavINS8','LavIN10','LadCIN4','LadCIN5','RadCIN3'}; %S18_119
% phase_elecs = {'LIN2','LIN7','LIN8','LIN9','LPC2','LPC3','LPC4','LPC6','LPC7','LPC8','LPTP8'}; % S18_127
% phase_elecs = {'LDP6','LDP7','LDP1','LDP2','LDP3','RDP1','LAI6','LAI7','LDP9','LDP10'}; %S18_124
% phase_elecs = {'LRSC1','LCINm1','LCINm3','LCINm4','LINSa3','LOFCa2','LOFCa10','LOFCp1'}; %S17_118
phase_elecs = {'LAC3','LAC4','LPC7','LPC8','LPC9','LPC10','RH2','RIN1','RIN2','RIN3'}; %S17_110
% ChanNamesToNums(globalVar,phase_elecs)

PAC = computePACAll(sbj_name,project_name,block_names,dirs,[],[],[],'SpecDenseLF','stim','condNames',[],[]);

plotPAC(PAC,{'city','mtn'},'LDP1',[])
plotPACAll(sbj_name,project_name,dirs,[],[],{'autobio','math'},'SpecDenseLF')

%% PLV RT correlation
PLVRTCorrAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','stim','condNotAfterMtn',[],[])

%% DONE PREPROCESSING. 
% Eventually replace globalVar to update dirs in case of working from an
% with an external hard drive
%UpdateGlobalVarDirs(sbj_name, project_name, block_name, dirs)

%% Branch 7 - Plotting
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

% plot individual trials (to visualize bad trials)
plot_params = genPlotParams(project_name,'timecourse');
plot_params.single_trial = true;
plot_params.noise_method = 'trials'; %'trials','timepts','none'
% plot_params.noise_fields_timepts = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_params.textsize = 10;
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band')

% plot avg. HFB timecourse for each electrode separately
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.noise_fields_timepts = {'bad_inds'};
% elecs = {'LRSC1'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band')

% plot HFB timecourse, grouping multiple conds together
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',{{'math','autobio'},{'math'}},plot_params,'Band')

%% multielectrode plotting
load cdcol.mat
cols.SPLattn = cdcol.lilac;
cols.SPLmath = cdcol.scarlet;
cols.PMC = cdcol.ultramarine;
cols.INS = cdcol.yellowgeen;
cols.ACC = cdcol.yellowgeen;

% S18_124
% SPLattn = 'LDP7';
% PMC = 'LDP1';
% INS = 'LAI6';
% elecs = {INS,PMC};
% elecs1 = PMC;
% elecs2 = VIS;

%S14_69b
% SPLattn = 'LP6';
% SPLmath = 'LPS7';
% elecs = {SPLattn,SPLmath};

%S17_116
% SPLattn = 'RPG2';
% SPLmath = 'RPG9';
% PMC = 'RPT1';
% elecs = {SPLattn,PMC};

%S18_119
SPLattn = 'LRSC8';
INS = 'LavIN10';
PMC = 'LRSC1';
ACC = 'LadCIN5';
elecs = {INS,PMC};

% plot HFB timecourse for multiple elecs on same plot
plot_params = genPlotParams(project_name,'timecourse');
plot_params.col = [cols.INS; cols.PMC];
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_params.multielec = true;
plot_params.scale_amp = false;
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'math'},plot_params,'Band')
%% 
% plot inter-trial phase coherence for each electrode
plot_params = genPlotParams(project_name,'ITPC');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotITPCAll(sbj_name,project_name,block_names,dirs,[],'SpecDenseLF','stim','condNames',[],plot_params)

% plot ERSP (event-related spectral perturbations) for each electrode
plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'SpecDenseLF','stim','condNames',[],plot_params)

% Number comparison
% load a given trialinfo
% load([dirs.result_root,'/',project_name,'/',sbj_name,'/',block_names{1},'/trialinfo_',block_names{1},'.mat'])
% conds_dist = unique(trialinfo.conds_num_lum_digit_dot_distance)
% conds_number_digit = conds_dist(contains(conds_dist, 'number_digit'));
% conds_number_dot = conds_dist(contains(conds_dist, 'number_dot'));
% conds_brightness_dot = conds_dist(contains(conds_dist, 'brightness_dot'));
% conds_brightness_digit= conds_dist(contains(conds_dist, 'brightness_digit'));

    
col = gray(4)
col = col*0.85

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_num_lum_digit_dot_distance',conds_number_digit,col,'trials',[],x_lim)

% TODO: 
% Allow conds to be any kind of class, logical, str, cell, double, etc.
% Input baseline correction flag to have the option.
% Include the lines option

PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','condNames',[],'trials',[])
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','conds_calc',[],'trials',[])

% TODO: Fix cbrewer 2

%% STATS
tag = 'stimlock_bl_corr';
[p,p_fdr,sig] = permutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,tag,'condNames',{'math'},'HFB',[]);

%% GradCPT- baseline vs. city vs. mtn
power_by_cond = GradCPT_BL_vs_city_vs_mtn(sbj_name,block_names,dirs,[],'HFB','condNotAfterMtn');
%% Branch 8 - integrate brain and electrodes location MNI and native and other info
% Load and convert Freesurfer to Matlab
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);
V = importVolumes(dirs);

% Convert electrode coordinates from native to MNI space
[MNI_coords, elecNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);

% Plot brain and coordinates
% transform coords
% coords(:,1) = coords(:,1) + 5;
% coords(:,2) = coords(:,2) + 5;
% coords(:,3) = coords(:,3) - 5;

figureDim = [0 0 1 .4];
figure('units', 'normalized', 'outerposition', figureDim)

views = [1 2 4];
hemisphere = 'left';

% Plot electrodes as dots
for i = 1:length(views)
    subplot(1,length(views),i)
    ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(i))
    f1 = plot3(coords(:,1),coords(:,2),coords(:,3), '.', 'Color', 'b', 'MarkerSize', 40);
    alpha(0.5)

%     if i > 2
%         f1.Parent.OuterPosition(3) = f1.Parent.OuterPosition(3)/2;
%     else
%     end
end
light('Position',[1 0 0])


% Plot electrodes as text
views = [1 4];

for v = 1:length(views)
    subplot(1,length(views),v)
    ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(v))
    for i = 1:length(elecs)
        hold on
        text(coords(i,1),coords(i,2),coords(i,3), num2str(elecs(i)), 'FontSize', 20);
    end
    alpha(0.5)
end


% Plot two hemispheres
ctmr_gauss_plot(cortex.left,[0 0 0], 0, 'left', 1)
ctmr_gauss_plot(cortex.right,[0 0 0], 0, 'right', 1)
f1 = plot3(coords(:,1),coords(:,2),coords(:,3), '.', 'Color', 'k', 'MarkerSize', 40);
f1 = plot3(coords(e,1),coords(e,2),coords(e,3), '.', 'Color', 'r', 'MarkerSize', 40);
text(coords(e,1),coords(e,2),coords(e,3), num2str(elecs(e)), 'FontSize', 20);



%% Create subjVar
subjVar = [];
subjVar.cortex = cortex;
subjVar.V = V;
subjVar.elect_native = coords;
subjVar.elect_MNI = MNI_coords;
subjVar.elect_names = elect_names;
subjVar.demographics = GetDemographics(sbj_name, dirs);
save([dirs.original_data '/' sbj_name '/subjVar.mat' ], 'subjVar')

% demographics
% date of implantation
% birth data
% age
% gender
% handedness
% IQ full
% IQ verbal
% ressection?


%% Copy subjects
subjs_to_copy = {'S18_125'};
parfor i = 1:lenght(subjs_to_copy)
    CopySubject(subjs_to_copy{i}, dirs.psych_root, '/Volumes/LBCN8T/Stanford/data2/psychData', dirs.data_root, '/Volumes/LBCN8T/Stanford/data2/neuralData')
    UpdateGlobalVarDirs(subjs_to_copy{i}, project_name, block_names, dirs)
end
%% Medium-long term projects
% 1. Creat subfunctions of the EventIdentifier specific to each project
% 2. Stimuli identity to TTL

%% Concatenate all trials all channels
plot_params.blc = true;
data_all = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim', plot_params);



%% Behavioral analysis
% Load behavioral data
load()

datatype = 'HFB'
plot_params.blc = true
locktype = 'stim'
data_all.trialinfo = [];
for i = 1:length(block_names)
    bn = block_names {i};
    dir_in = [dirs.data_root,'/','HFB','Data/',sbj_name,'/',bn,'/EpochData/'];
    
    if plot_params.blc
        load(sprintf('%s/%siEEG_%slock_bl_corr_%s_%.2d.mat',dir_in,datatype,locktype,bn,1));
    else
        load(sprintf('%s/%siEEG_%slock_%s_%.2d.mat',dir_in,datatype,locktype,bn,1));
    end
    % concatenate trial info
    data_all.trialinfo = [data_all.trialinfo; data.trialinfo]; 
end

data_calc = data_all.trialinfo(data_all.trialinfo.isCalc == 1,:)
acc = sum(data_calc.Accuracy)/length(data_calc.Accuracy);
mean_rt = mean(data_calc.RT(data_calc.Accuracy == 1));
sd_rt = std(data_calc.RT(data_calc.Accuracy == 1));

boxplot(data_calc.RT(data_calc.Accuracy == 1), data_calc.OperandMin(data_calc.Accuracy == 1))
set(gca,'fontsize',20)
ylabel('RT (sec.)')
xlabel('Min operand')


%% MMR
data_calc = data_all.trialinfo(strcmp(data_all.trialinfo.condNames, 'math'),:);




