
clear;clc;

project_name='MMR'
sbj_names ={'S16_99_CJ'};%;'S18_131'


%'S18_128_CG';'S12_33_DA';'S12_38_LK';'S12_42_NC';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC''S17_118_TW';'S18_119_AG';'S18_124_JR2';
%'S14_69_RTb';;'S17_112_EA';'S18_126';'S18_127';'S18_130_RH';

% Create subject variable
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

% 
center = 'Stanford';
subjVar_created = nan(length(sbj_names),1,1);

for i = 1:length(sbj_names)
    % Load subjVar
     dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
      
    if exist([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat'], 'file')
        load([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat']);
        subjVar_created(i) = 2;
    else
        fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
        %dirs.freesurfer= fullfile('/Applications/freesurfer/subjects/',sbj_names{i});
        [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_names{i}, center);
       

         [subjVar,  subjVar_created(i)] = CreateSubjVar(sbj_names{i}, dirs, data_format, fsDir_local);
    end 
end