
clear;clc;


subjs_to_copy = {'S18_129'};%'S14_69_RTb';'S16_100_AF';'S17_104_SW';'S17_105_TA';'S18_127';'S18_128';
%{'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_130_RH';'S18_131'};%

%{''};%

project_name = 'Memoria';
neuralData_folders = {'originalData', 'CARData'};%'CompData',

server_root = '/Volumes/neurology_jparvizi$/';
comp_root ='/Volumes/Ying_SEEG/ParviziLab';% '/Users/yingfang/Documents/data';%
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';


for i = 1:length(subjs_to_copy) 
    block_names = BlockBySubj(subjs_to_copy{i},project_name);
    dirs = InitializeDirs(project_name,subjs_to_copy{i},comp_root,server_root,code_root);
    CopySubject(subjs_to_copy{i}, dirs.psych_root, '/Volumes/Ying_SEEG/Data_lbcn/psychData', dirs.data_root, '/Volumes/Ying_SEEG/Data_lbcn/neuralData', neuralData_folders, project_name, block_names)
end
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
%% Run after having copied on the destination computer
for i = 1:length(subjs_to_copy)
    block_names = BlockBySubj(subjs_to_copy{i},project_name);
    dirs = InitializeDirs(project_name,subjs_to_copy{i},comp_root,server_root,code_root);
    UpdateGlobalVarDirs(subjs_to_copy{i}, project_name, block_names, dirs)
end