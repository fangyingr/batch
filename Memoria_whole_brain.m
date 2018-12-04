
% Load and convert Freesurfer to Matlab
project_name = 'Memoria';
code_root = '/Users/yingfang/Documents/lbcn_preproc';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';

% sbj_names = {'S17_112_EA','S17_116'};
sbj_names = {'S18_119_AG';'S17_118_TW';'S18_130_RH'}%;'S18_131';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S14_69_RTb';'S17_110_SC';'S17_112_EA';};%
for i = 1:length(sbj_names)
    sbj_name = sbj_names{i};
    fsDir_local =[ '/Applications/freesurfer/subjects/',sbj_name];
    
    dirs = InitializeDirs(project_name, sbj_name, comp_root, server_root,code_root);
    
    center = 'Stanford';
    [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
    
    subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local);
end