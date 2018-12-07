clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'Hippocampus','PMC';'PMC','mPFC';'Hippocampus','mPFC'};
sbj_names ={'S17_118_TW';'S18_119_AG';'S18_130_RH'};%{'S12_42_NC'}%;'S12_38_LK';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125'};%'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%
locktype ='stim';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';


for subi=1:length(sbj_names)
    for ri =1:size(regions,1)
    sbj_name = sbj_names{subi};
   dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root);
    block_names = BlockBySubj(sbj_name,project_name);
    
    clear elec*
    [elec_names1,elecs1] = ElectrodeBySubj(sbj_name,regions{ri,1});
    [elec_names2,elecs2] = ElectrodeBySubj(sbj_name,regions{ri,2});
     if ~isempty(elecs1) && ~isempty(elecs2)
     
    tag=[regions{ri,1},'_',regions{ri,2}];
    computePLVAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','time','stim','SpecDense','condNames',{'autobio','math'},[],tag)
    plotPLVAll(sbj_name,project_name,dirs,elecs1,elecs2,'all',{'autobio','math'},'SpecDense','time',tag,[])
    
    
            else
    
                disp('No electrodes in this regions')
    
            end
    end
end