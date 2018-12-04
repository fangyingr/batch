%% Create subjVar (containing native cortex, electrode coords in native and MNI space)
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
code_root = '/Users/amydaitch/Dropbox/Code/MATLAB/lbcn_preproc';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/AmyData/ParviziLab';
dirs = InitializeDirs(project_name, sbj_name, comp_root, server_root,code_root); 

sbj_name = 'S18_124';
center = 'Stanford';
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local);

%% create video showing activations across time

sbj_names = {'S14_69b_RT','S15_89b_JQ','S16_99_CJ','S17_104_SW','S17_105_TA','S17_106_SD','S17_110_SC','S17_112_EA','S17_114','S17_115','S17_116','S17_118','S18_119','S18_120','S18_124','S18_127','S18_131'};
norm_by_subj = false; 
project_name = 'Memoria';

conds_avg_field = 'condNames'; % column of trialinfo 
conds_avg_conds = {'math', 'autobio'}; % condition names
decimate = true;
fs_ds = 50; % downsampled rate
concat_params = genConcatParams(decimate,fs_ds);
concat_params.noise_method = 'timepts'; % 'timepts' or 'trials'

data_all = makeVid(sbj_names,project_name,concat_params,conds_avg_field,conds_avg_conds,norm_by_subj);
