% Make sure your are connected to CISCO and logged in the server
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';
code_root = '/Users/yingfang/Documents/toolbox/lbcn_preproc';
dirs = InitializeDirs(project_name,'S13_46_JDB',comp_root,server_root,code_root);



subjs_to_copy = {'S13_46_JDB'};
project_name = 'MMR';
neuralData_folders = {'originalData', 'CARData'};
block_names = {};

for i = 1:length(subjs_to_copy) 
    block_names{i} = BlockBySubj(subjs_to_copy{i},project_name);
end

parfor i = 1:3% 5:9 10:6 length(subjs_to_copy)
    CopySubject(subjs_to_copy{i}, dirs.psych_root, '/Volumes/LBCN30GB/Stanford/data/psychData', dirs.data_root, '/Volumes/LBCN30GB/Stanford/data/neuralData', neuralData_folders, project_name, block_names{i})
end