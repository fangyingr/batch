
function updateGlobalVar(project_name,sbj_name,dirs,previous_root,comp_root,block_names)
for i = 1:length(block_names)
    bn = block_names{i};
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    folder_sublayers=fieldnames(globalVar);
    pn=length(previous_root);
    cn=length(comp_root);
    for ii = 1:length(folder_sublayers)
        if strncmp(previous_root,globalVar.(folder_sublayers{ii}),pn)
            globalVar.(folder_sublayers{ii})=strrep(globalVar.(folder_sublayers{ii}),previous_root,comp_root);
        end
    end
    if ~strncmp(comp_root,globalVar.psych_dir,cn)

        proot=regexp(globalVar.psych_dir, 'psychData', 'split');   
        
    end  
    save(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn),'globalVar')
end
end


