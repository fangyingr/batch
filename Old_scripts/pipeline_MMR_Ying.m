
%% Branch 1. basic config - PEDRO
AddPaths('Ying_iMAC')

%parpool(4) % initialize number of cores

%% Initialize Directories
project_name = 'MMR';%'Memoria';%;

%% Create folders
sbj_name ='S18_132';%'S17_116';%'S16_100_AF'%'S14_69_RTb';%'S17_118_TW';%'S17_110_SC';%'S16_99_CJ';%'S18_131';%'S12_42_NC'%'S18_130_RH';%'S12_38_LK';%'S13_47_JT2';%%%;%;%'S18_124_JR2'%'S12_33_DA'%'S12_42_NC';%%'S17_118_TW';%'S12_38_LK';%%'S12_38_LK';%;'S18_119_AG'%%%'S18_125';%'S18_126';%%'S11_27_PT';%'S12_33_DA'%'S13_47_JT2'%%'S17_112_EA'%%''S16_99_CJ';%'S17_110_SC';%'S13_47_JT2'%S17_112_EA'%%'S18_126';% 'S18_126';% 'S18_124_JR2';

% Center
% center = 'China';
center = 'Stanford';

%% Get block names
block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% Make sure your are connected to CISCO and logged in the server
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);


[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

%% Create subject folders
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format, 1) 
%%% IMPROVE uigetfile to go directly to subject folder %%%

% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly
% At this stage, paste the EDF or TDT files into the originalData folder
% and the behavioral files into the psychData
% (unless if using CopyFilesServer, which is still under development)

ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate
%LK 65 105 119 117 106 71 118 67 107 81 66 103 108 37 70 115 80 84 51 83 59 69 60 112 38 54 56 36 91 43 116 113 41 57 35 110 75 73 72 29 47 88 53 102 49 87 120 68 34 39 33 45 52 82 64 50 86 61 109 48 104 62 114 98 93 99 121 78 79 100 101 90 92 63 122 76 111 46 58 44 55 40 97 96 74 42 77 95 85 8 7 5 4


%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
parfor i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end
% In the case of number comparison, one has also to copy the stim lists


%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'Calculia_SingleDigit'
        %         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoCalculia(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds? INCLUDE REST!!!
    case 'MMR'
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'Memoria'
        language = 'english'; % make this automnatize by sbj_name
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs, language)
    case 'Calculia_China'
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_production'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Number_comparison'
        OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'MFA'
        OrganizeTrialInfoMFA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia'
        OrganizeTrialInfoCalculia_combined(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
end



%% Branch 3 - event identifier
if strcmp(project_name, 'Number_comparison')
    event_numcomparison_current(sbj_name, project_name, block_names, dirs, 9) %% MERGE THIS
elseif strcmp(project_name, 'Memoria')
    EventIdentifier_Memoria(sbj_name, project_name, block_names, dirs) % new ones, photo = 1; old ones, photo = 2; china, photo = varies, depends on the clinician, normally 9.
else
    EventIdentifier(sbj_name, project_name, block_names, dirs, 1) % new ones, photo = 1; old ones, photo = 2; china, photo = varies, depends on the clinician, normally 9.
end


%% Branch 4 - bad channel rejection
BadChanRejectCAR(sbj_name, project_name, block_names, dirs)
%% concatenate all the data for Su' visualization tool

plot_params.blc = true;
data_all = ConcatenateAll_su(sbj_name,project_name,block_names,dirs,[],'HFB','stim', plot_params,'Band');
Plot_Window_App
%% theta band multi electrode

elecs=83;%[98 99 100 103];%[73 74 75 83];%[98 100 103]%[23 51 32];
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs'};%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_para.xlim=[-0.2,2];
plot_params.multielec=false;
plot_params.ylabel = 'z-scored power';
PlotTrialAvgAll_max(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio'},plot_params,'Band')

%PlotTrialAvgAll_max(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','trialhistory_rma',{'math after rest','math after autobio','math after math'},plot_params,'Band') %{'autobio-specific','autobio-general'}

plot_params.blc = true;
data_all = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim', plot_params);

[ROL] = getROLAll(sbj_name,project_name,block_names,dirs,elecs,'Band','HFB','stim',[],'condNames',{'autobio'});

for i=1:length(elecs)
    a=cell2mat(ROL.autobio.thr(elecs(i)))*1000;
    a=a(intersect(find(a>100),find(a<1000)));
    histogram(a,50)
    hold on
end

PAC = computePACAll(sbj_name,project_name,block_names,dirs,[],[],[],'SpecDense','stim','condNames',[],[]);

plotPACAll(sbj_name,project_name,dirs,[],[],{'autobio','math'},'SpecDense')



elecs=[8 77];%[31 111 51]%[13 55]%[99 51 32]%[74 70]%[3 47]%[74 70]%[84 99];%
plot_params = genPlotParams(project_name,'timecourse','Theta',true);
%PlotTrialAvgAll_ychange(sbj_name,project_name,block_names,dirs,elecs,'Spec','stim','condNames',{'autobio'},'trials',plot_params)%'HFB'

PlotTrialAvgAll_ychange(sbj_name,project_name,block_names,dirs,elecs,'Spec','stim','newcondNames',{'autobio-specific'},'trials',plot_params)%'HFB'

PlotTrialAvgAll_ychange(sbj_name,project_name,block_names,dirs,elecs,'Spec','stim','newcondNames',{'autobio-general'},'trials',plot_params)%'HFB'
elecs=51;
%elecs=[13 55]%[8 77];%[31 111 51]%[99 51 32]%[13 55]%[74 70]%[84 99];%
plot_params = genPlotParams(project_name,'timecourse');
plot_params.single_trial = 0;
plot_params.noise_fields_trials= {'bad_epochs_HFO','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math'},plot_params,'Band')%

plot_params = genPlotParams(project_name,'timecourse','HFB',true);
PlotTrialAvgAll_ychange(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','newcondNames',{'autobio-specific'},'trials',plot_params)%'HFB'

plot_params = genPlotParams(project_name,'timecourse','HFB',true);
PlotTrialAvgAll_ychange(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','newcondNames',{'autobio-general'},'trials',plot_params)%'HFB'





%% Get iEEG and Pdio sampling rate and data format
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name,center);

%% Create subject folders
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format,false)
% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly
% At this stage, paste the EDF or TDT files into the originalData folder
% and the behavioral files into the psychData
% (unless if using CopyFilesServer, which is still under development)

%% Get marked channels and demographics
%[refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate


%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
parfor i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end

%fs_iEEG=1000;

%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    %SaveDataNihonKohden_118(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'MMR'
        % OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'Memoria'
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs)
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'CalculiaChina'
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_production'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
end

%Plug into OrganizeTrialInfoCalculiaProduction
%OrganizeTrialInfoNumberConcatActive
%OrganizeTrialInfoCalculiaEBS
% %% Segment audio from mic
% % adapt: segment_audio_mic
% switch project_name
%     case 'Calculia_EBS'
%     case 'Calculia_production'
%         load(sprintf('%s/%s_%s_slist.mat',globalVar.psych_dir,sbj_name,bn))
%         K.slist = slist;
% end
% %%%%%%%%%%%%%%%%%%%%%%%

%% Branch 3 - event identifier
 % new ones, photo = 1; old ones121, photo = 2; china, photo = varies, depends on the clinician
EventIdentifier(sbj_name, project_name, block_names, dirs, 1)


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
%,%48 2 3 32];%[46:48 55:57]%[1 2 51 52];%[77:79 107 7:9 17:19 29 30];%[71 72 111 51 31 32 33];%[23 100 51 32 41 97 98 99]%[12 13 53 54 55]%%[80:86 73 74 75];%[81:84 46:49]%;%[88:90,98:100,104,110:112,120,121 ]%%[1 2]%[80:86 73 74 75]%[47 48 2 3 22];%[71 72 111 51 31 32 33];%[46 47 48 56 57 58];%[51 52 1 2]%[53 54 55 12 13];%[1 19:22 27:30 65:68 74];%[51 32 41 23 98 99];%[77:79 107 7:9 17:19 29 30];

%elecs=[65:74]%[88:90,98:100,104,110:112,120:122 11:15];
%[65:74 81:90 97:104];%76;%[81 82]%[68:74 82:86]%[65:70 81:88 97:106]%[16:20 51:62]%[73:75 83:85 65:72]%[65:67 75:77 81 87:89 97:104];
for i = 1:length(block_names)
    parfor ei = 1:length(elecs)
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], [], [], 'Band') % only for HFB
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], 200, true, 'Spec') % across frequencies of interest
    end
end

%% Branch 6 - Epoching, identification of bad epochs and baseline correction
%elecs =[51 32 23 41 97 98 99 100]%[1 2 51 52];%[12 13 53 54 55]
  
epoch_params = genEpochParams(project_name, 'stim');
epoch_params.blc.bootstrap = true;
for i = 1:length(block_names)
    bn ='E18-975_0007'% block_names{i};
    parfor ei = 1:length(elecs)
        EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
      %  EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
    end
end


plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.xlim = [-3 1]
 plot_params.noise_fields_trials ={'bad_epochs_HFO','bad_epochs_raw_HFspike'};%{'bad_epochs'}%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math'},plot_params,'Band') %{'autobio-specific','autobio-general'}

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','resp','condNames',{'autobio','math'},plot_params,'Band') %{'autobio-specific','autobio-general'}


plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
%plot_params.noise_fields_trials ={'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'};%;%{'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense','stim','condNames',{'autobio','math'},plot_params)


% for i = 1:length(block_names)
%     parfor ei = 1:length(elecs)
%         EpochDataAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei),'resp', -tmax, 1, 'HFB', [],[], blc_params)
%         EpochDataAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei),'resp', -tmax, 1, 'Spec', [],[], blc_params)
%     end
% end
% Bad epochs identification
%      Step 1. based on the raw signal
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the spikes in the HFB signal or other freq bands


%% DONE PREPROCESSING.
% Eventually replace globalVar to update dirs in case of working from an
% with an external hard drive
%UpdateGlobalVarDirs(sbj_name, project_name, block_name, dirs)

%% Branch 7 - Plotting
%elecs =[11:15];
load('cdcol.mat')
col = [
    cdcol.ultramarine;
    cdcol.carmine;
    cdcol.yellow;
    cdcol.grassgreen;
    cdcol.lilac;
    cdcol.turquoiseblue];

%%

x_lim = [-.5 tmax];
load('cdcol.mat')

col = [
    cdcol.ultramarine;
    cdcol.carmine;
    cdcol.yellow;
    cdcol.grassgreen;
    cdcol.lilac;
    cdcol.turquoiseblue];
%elecs=[];
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio','math'},'trials',[],'Band') %{'autobio-specific','autobio-general'}

PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'stim','condNames',{'autobio','math'},'trials',[],'SpecDense')



%% Compute PLV
elecs1=[65:74 81:89];
elecs2=[97:104];
plv_params.freq_range = [4 7];
plv_params.freq_band ='Theta';
plv_params.xlim=[-0.2 2];
plv_params.blc = true;
plv_params.plot = true;
computePLVAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','time','stim','condNames',{'autobio','math'},plv_params)


%%

% TODO:
% Allow conds to be any kind of class, logical, str, cell, double, etc.
% Input baseline correction flag to have the option.
% Include the lines option

%PlotERSPAll(sbj_name,project_name,block_names,dirs,elecs,'stim','condNames',{'math','autobio'},'trials',[])

%%  for multielectrode plots

elecs = [84 99];%[74 66];%[57 47]%[8 77];%[31 111 51]%[99 51 32 ]%[13 53]%[51 1]%[8 18 29]%[22 3 47]%[57 48];%[13 55];%[30 9]%[23 98]%[31 71 51];%[23 51 32];%[57 46];% [18 77];[23 98];%
conds={'autobio'};
plot_params = genPlotParams(project_name,'timecourse','HFB',true);
plot_params.legend = false;
plot_params.ylabel = 'z-scored power';%'z_power';
plot_params.xlim = [-.2 3];
%load cdcol.mat
%col = [cdcol.ultramarine; cdcol.carmine];
plot_params.multielec = true;
PlotTrialAvgAll_multiElecs(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',conds,col,'trials',plot_params,x_lim)


%% ROL

[ROL] = getROLAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',[],'condNames',conds);
plotROL(sbj_name,project_name,dirs,ROL,elecs,conds{1},'thr',30);


%% PLV Ying

elecs=[100 32];%[3 47]%[51 32]%[51 100] %51 41  99 98 32
phaseindx= 5;%:11

for pi=1:length(phaseindx)
    PlotPLVAll(sbj_name,project_name,block_names,dirs,elecs,'stim','condNames',{'autobio','math'},'trials',[],col,phaseindx(pi))%'autobio'
    
end


%% theta band multi electrode

elecs= [84 99];
plot_params = genPlotParams(project_name,'timecourse','Theta',true);
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'Spec','stim','condNames',{'autobio'},'trials',plot_params)%'HFB'


%% theta and HFB

elecs= [84];
plot_params = genPlotParams(project_name,'timecourse','Theta',true);
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'Spec','stim','condNames',{'autobio'},'trials',plot_params)%'HFB'

elecs= [99];
plot_params = genPlotParams(project_name,'timecourse','HFB',true);
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'autobio'},'trials',plot_params) %{'autobio-specific','autobio-general'}


%% Branch 8 - integrate brain and electrodes location MNI and native and other info
% Load and convert Freesurfer to Matlab
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);

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

boxplot(data_calc.RT(data_calc.Accuracy == 1), data_calc.CorrectResult(data_calc.Accuracy == 1))




