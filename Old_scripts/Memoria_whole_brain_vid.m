

clear;clc;
sbj_names = {'S18_119_AG';'S17_118_TW'};%'S18_131';;'S18_130_RH'
%{'S14_69b_RT','S15_89b_JQ','S16_99_CJ','S17_104_SW','S17_105_TA','S17_106_SD','S17_110_SC','S17_112_EA','S17_114','S17_115','S17_116','S17_118','S18_119','S18_120','S18_124','S18_127','S18_131'};
% sbj_names = {'S14_69b_RT'};
norm_by_subj = true;
project_name = 'Memoria';
code_root = '/Users/yingfang/Documents/lbcn_preproc';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';

dirs = InitializeDirs(project_name, sbj_names{1}, comp_root, server_root,code_root); 

conds_avg_field = 'condNames'; % column of trialinfo 
conds_avg_conds = {'math', 'autobio'}; % condition names
decimate = true;
fs_ds = 50; % downsampled rate
concat_params = genConcatParams(decimate,fs_ds);
concat_params.noise_method = 'timepts'; % 'timepts' or 'trials'

data_all = makeVid(sbj_names,project_name,concat_params,conds_avg_field,conds_avg_conds,norm_by_subj);