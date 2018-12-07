clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'mPFC';'PMC';'Hippocampus'};
sbj_names = {'S17_105_TA'};
%{'S12_33_DA';'S12_38_LK';'S12_42_NC';'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_130_RH';'S18_131'};%;
%;
%sbj_names ={'S18_119_AG';'S12_33_DA';'S12_38_LK';'S12_42_NC';'S17_118_TW';'S18_130_RH';'S18_131'};
locktype ='stim';

server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
    
    dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            
            
            [~, ~, ~, ~, ~, ~, hfb_elecs_am] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',locktype,'condNames',{'autobio','math'},[],'Band',1,[],regions{ri});
            
            [~, ~, ~, ~, ~, hfb_timing,hfb_elecs_a] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',locktype,'condNames',{'autobio'},[],'Band',1,[],regions{ri});
            
           
            
            clear el_stats;
             el_stats=table;
                for i=1:length(elecs)         
                    el_stats.subject(i)={sbj_name};
                    el_stats.region(i) =regions(ri);
                    el_stats.elecname(i)=elec_names(i);
                    el_stats.elecnumber(i)=elecs(i);
                    el_stats.hfb_start(i)=hfb_timing(i).start;
                    el_stats.hfb_stop(i)=hfb_timing(i).stop;
                    el_stats.hfb_duration(i)=hfb_timing(i).duration;
                    el_stats.sig_hfb_autobio(i) = hfb_elecs_a(i);
                    el_stats.sig_hfb_automath(i) =hfb_elecs_am(i); 
                end
                
            dir_out= [dirs.result_root,filesep,project_name,filesep,'Group',filesep,'Stats',filesep];
            if ~exist(dir_out)
                mkdir(dir_out)
            end
            fm_out = sprintf('%s/%s_%s_%slock_%s.mat',dir_out,sbj_name,project_name,locktype,regions{ri});
            save(fm_out,'el_stats')
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end