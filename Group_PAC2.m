clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S12_42_NC'}%;'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW'};%;'S18_119_AG';'S18_124_JR2';'S18_125'};%'S12_33_DA'};%};%;%;'S13_47_JT2'};%'S12_38_LK'};%
locktype ='stim';

blc_params.run = true; % or false
blc_params.locktype = 'stim';
blc_params.win = [-.2 0];
tmax = 3;

for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs('Ying_iMAC', project_name,sbj_name, false);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            
            PAC = computePACAll(sbj_name,project_name,block_names,dirs,elecs,[],[],'SpecDense','stim','condNames',{'autobio','math'},[]);    
            plotPACAll(sbj_name,project_name,dirs,elecs,[],{'autobio','math'},'SpecDense')
            
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end