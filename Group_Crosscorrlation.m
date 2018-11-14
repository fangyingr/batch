
clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'Hippocampus','PMC';'PMC','mPFC';'Hippocampus','mPFC'};
sbj_names ={'S12_42_NC';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125';'S12_33_DA';'S12_38_LK';};%};%};%;%;'S13_47_JT2'};%};%
locktype = 'stim';
pairing = 'all';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';

for subi=1:length(sbj_names)
    for ri =1:size(regions,1)
        sbj_name = sbj_names{subi};
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        region_tag=[regions{ri,1},'_',regions{ri,2}];
        clear elec*
        [elec_names1,elecs1] = ElectrodeBySubj(sbj_name,regions{ri,1});
        [elec_names2,elecs2] = ElectrodeBySubj(sbj_name,regions{ri,2});
        elecs1=73;
        elecs2=66;
        if ~isempty(elecs1) && ~isempty(elecs2)
             
           crosscorr = computeCrossCorrAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,pairing,locktype,'HFB','condNames',{'autobio'},[],region_tag)   
        else
            disp('No electrodes in this regions')
        end
    end
end