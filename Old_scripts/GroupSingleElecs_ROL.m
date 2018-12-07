clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'mPFC';'Hippocampus';'PMC'};%
sbj_names ={'S17_118_TW';'S12_42_NC';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S18_119_AG';'S18_124_JR2';'S18_125';'S13_47_JT2'};%'S12_33_DA';'S12_38_LK'};%
%{'S12_38_LK'};%;{'S13_47_JT2'}%;'S18_125'}%};'S18_119_AG'}%;%;'S17_110_SC''S16_99_CJ'}%;'S17_112_EA'};%'S12_33_DA';{'S12_38_LK'}%;'S18_124_JR2';}%'S12_42_NC'};%'S17_118_TW'}%;


blc_params.run = true; % or false
blc_params.locktype = 'stim';
blc_params.win = [-.2 0];
tag = 'stimlock_bl_corr';
tmax = 3;

for subi=1:length(sbj_names)
    ROL=[];
    peaktime=[];
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs('Ying_iMAC', project_name,sbj_name, false);
    block_names = BlockBySubj(sbj_name,project_name);
    
    
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        if ~isempty(elecs)                    
            %% statstics
            
       
            sp_theta = genStatsParams(project_name);
            sp_theta.task_win = [0.25 0.75];
            sp_theta.bl_win = [-0.2 -0.1];
            sp_theta.freq_range = [4 7];
            [theta_p,theta_p_fdr,theta_sig] = permutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,tag,'condNames',{'autobio'},'Theta',sp_theta,'Band');
      
            sp_hfb = genStatsParams(project_name);
            sp_hfb.task_win = [0 1.5];
            sp_hfb.bl_win = [-0.2 -0.1];
            sp_hfb.freq_range = [70 180];
            
            
            [hfb_p,hfb_p_fdr,hfb_sig] = permutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,tag,'condNames',{'autobio'},'HFB',sp_hfb,'Band');
            [chfb_p,chfb_p_fdr,chfb_sig] = permutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,tag,'condNames',{'autobio','math'},'HFB',sp_hfb,'Band');
            singlecs=[];
            sigelecs=intersect(elecs(theta_p<0.05),elecs(hfb_p<0.05));
            sigelecs=intersect(sigelecs,elecs(chfb_p<0.05));
            sig_elecs.(regions{ri})=sigelecs';
            
            if ~isempty(sigelecs)
                %% ROL
                ROL_Theta=[];ROL_HFB=[];
                [ROL_Theta] = getROLAll(sbj_name,project_name,block_names,dirs,sigelecs,'stim','Theta',[],'condNames',{'autobio'},'Trials','Band');
                [ROL_HFB] = getROLAll(sbj_name,project_name,block_names,dirs,sigelecs,'stim','HFB',[],'condNames',{'autobio'},'Trials','Band');
                
                for si=1:length(sigelecs)
                    ROL.theta_mean(si).(regions{ri})=nanmean(cell2mat(ROL_Theta.autobio.thr(sigelecs(si))));
                    ROL.HFB_mean(si).(regions{ri})=nanmean(cell2mat(ROL_HFB.autobio.thr(sigelecs(si))));
                    ROL.theta_median(si).(regions{ri})=nanmedian(cell2mat(ROL_Theta.autobio.thr(sigelecs(si))));
                    ROL.HFB_median(si).(regions{ri})=nanmedian(cell2mat(ROL_HFB.autobio.thr(sigelecs(si))));
                    peaktime.theta_mean(si).(regions{ri})=nanmean(cell2mat(ROL_Theta.autobio.peaktime(sigelecs(si))));
                    peaktime.HFB_mean(si).(regions{ri})=nanmean(cell2mat(ROL_HFB.autobio.peaktime(sigelecs(si))));
                    peaktime.theta_median(si).(regions{ri})=nanmedian(cell2mat(ROL_Theta.autobio.peaktime(sigelecs(si))));
                    peaktime.HFB_median(si).(regions{ri})=nanmedian(cell2mat(ROL_HFB.autobio.peaktime(sigelecs(si))));
                end
            else
                disp('No sigificant electrode in this region')
            end
        else
            disp('No electrodes in this region')
        end
        
    end
    save(['/Users/yingfang/Documents/data/Results/MMR/Group/ROL/',sbj_name,'_ROL_hfb_theta.mat'],'sig_elecs','ROL','peaktime');
end

