clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'PMC','mPFC';'Hippocampus','mPFC';'Hippocampus','PMC'};
sbj_names ={'S12_42_NC';'S17_118_TW';'S18_119_AG';'S12_33_DA';'S12_38_LK'};%;'S12_33_DA'{}%;'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S18_124_JR2';'S18_125'};%'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%
locktype ='stim';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

for subi=1:length(sbj_names)
    for ri =1:size(regions,1)
        sbj_name = sbj_names{subi};
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        clear elec*
       % [elec_names1,elecs1] = ElectrodeBySubj_memoria(sbj_name,regions{ri,1});
        %[elec_names2,elecs2] = ElectrodeBySubj_memoria(sbj_name,regions{ri,2});
         elecs1= 73; elecs2 = 66; %33
        if ~isempty(elecs1) && ~isempty(elecs2)
       
            tag=regions(ri,:);
         %  PlotBinPowerAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','stim','HFB','condNames',{'autobio'},[],tag); %'math'
        
              PlotAveragePower_memory(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','stim','HFB','condNames',{'autobio'},[],tag)
          
            
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end