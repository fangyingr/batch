clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'Memoria';
center = 'Stanford';
regions = {'PMC','mPFC';'Hippocampus','mPFC';'Hippocampus','PMC'};
sbj_names ={'S14_69_RTb';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_127';'S18_128_CG';'S17_105_TA';'S18_126';'S14_69_RTb';'S16_100_AF';'S18_130_RH';'S18_131';};%'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%
locktype ='stim';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';%'/Volumes/Ying_SEEG/ParviziLab';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

for subi=1:length(sbj_names)
    for ri =1:size(regions,1)
        sbj_name = sbj_names{subi};
        
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        clear elec*
        [elec_names1,elecs1] = ElectrodeBySubj_selected(sbj_name,regions{ri,1});
        [elec_names2,elecs2] = ElectrodeBySubj_selected(sbj_name,regions{ri,2});
        if ~isempty(elecs1) && ~isempty(elecs2)
            
            tag=regions(ri,:);
            
          PlotBinPowerAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','stim','HFB','condNames',{'autobio'},[],tag); %'math'
          
%             nelec1 = length(elecs1);
%             nelec2 = length(elecs2);
%             elecs1 = repmat(elecs1,[nelec2,1]);
%             elecs1 = reshape(elecs1,[1,nelec1*nelec2]);
%             elecs2 = repmat(elecs2,[1,nelec1]);
%             for ei=1:length(elecs1)
%              
%               PlotTrialAvgAll_Memoria(sbj_name,project_name,block_names,dirs,[elecs1(ei),elecs2(ei)],'HFB','stim','condNames',{'autobio'},[],'Band',tag)
%             end
%             
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end