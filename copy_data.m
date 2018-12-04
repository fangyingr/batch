
clear;clc;


subjs_to_copy = {'S18_126','S18_128_CG','S18_131','S18_130_RH'};
%{'S18_131','S18_130_RH','S12_33_DA','S12_38_LK','S12_42_NC','S14_69_RTb','S16_99_CJ','S16_100_AF','S17_105_TA','S17_110_SC','S17_112_EA','S17_118_TW','S18_119_AG','S18_124_JR2','S18_126'}
%'S18_127','S18_128_CG',

%{''};%
project_name = 'Memoria';
neuralData_folders = {'originalData';'CARData/CAR';'BandData/HFB'};%, 

code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc'; 
server_root = '/Volumes/neurology_jparvizi$/';
comp_root ='/Volumes/Ying_SEEG/Data_lbcn';%'/Users/yingfang/Documents/data'%%from path

to_path='/Volumes/AmyData/ParviziLab/';

 for i = 1:length(subjs_to_copy) 
    block_names = BlockBySubj(subjs_to_copy{i},project_name);
    dirs = InitializeDirs(project_name,subjs_to_copy{i},comp_root,server_root,code_root);
    CopySubject(subjs_to_copy{i}, dirs.psych_root, [to_path,'psychData'], dirs.data_root, [to_path,'neuralData'], neuralData_folders, project_name, block_names)
end

comp_root = to_path;
%% Run after having copied on the destination computer
for i = 1:length(subjs_to_copy)
    block_names = BlockBySubj(subjs_to_copy{i},project_name);
    dirs = InitializeDirs(project_name,subjs_to_copy{i},comp_root,server_root,code_root);
    UpdateGlobalVarDirs(subjs_to_copy{i}, project_name, block_names, dirs)
end