
clear;clc;

sbj_names ={'S12_33_DA';'S12_38_LK';'S12_42_NC';'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;


% Retrieve subjects info
[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_names = googleSheet.subject_name;
selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer)  ~cellfun(@(x) contains(x, 'both'), googleSheet.hemi)];
selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer)];
sbj_names = sbj_names(sum(selec_criteria,2) == size(selec_criteria,2));
sbj_names = sbj_names(subjVar_created == 0)


% Create subject variable
comp_root = '/Volumes/LBCN8T/Stanford/data';
server_root = '/Volumes/neurology_jparvizi$/';
code_root = '/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/';

center = 'Stanford';
subjVar_created = nan(length(sbj_names),1,1);

for i = 1:length(sbj_names)
    % Load subjVar
    if exist([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat'], 'file')
        load([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat']);
        subjVar_created(i) = 2;
    else
        fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
        [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_names{i}, center);
        dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
        [subjVar,  subjVar_created(i)] = CreateSubjVar(sbj_names{i}, dirs, data_format, fsDir_local);
    end 
end