clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'mPFC';'Hippocampus';'PMC'};
sbj_names ={'S12_33_DA';'S12_38_LK';'S12_42_NC';'S17_118_TW';'S18_119_AG';'S18_130_RH'};
locktype ='stim';

server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Users/yingfang/Documents/data';

for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
    
    dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            
            %[~, ~, ~, ~, ~, ~, hfb_elecs_am] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense',locktype,'condNames',{'autobio','math'},[],'Spec',1,[],regions{ri});
            
            [~, ~, ~, ~, ~, ~, hfb_elecs_am] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',locktype,'condNames',{'autobio','math'},[],'Band',1,[],regions{ri});
            
            [~, ~, ~, ~, ~, hfb_timing,hfb_elecs_a] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',locktype,'condNames',{'autobio'},[],'Band',1,[],regions{ri});
            
            h_am=[];h_a=[];t_a=[];
            h_am=find(hfb_elecs_am>0);
            h_a=find(hfb_elecs_a>0);
            %t_a=find(theta_elecs_a>0);
            
            sig_elecs=[];
            sig_elecs=intersect(h_am,h_a);
            %sig_elecs=intersect(sig_elecs,t_a);
            
            sign=zeros(length(elecs),1);
            
            clear el_stats;
%             if isempty(h_am) && isempty(h_a) && isempty (t_a) 
%                 for i=1:length(elecs)
%                  el_stats(i).subject=sbj_name;
%                     el_stats(i).region =regions{ri};
%                     el_stats(i).elecname=elec_names(sel);
%                     el_stats(i).elecnumber=elecs(sel);
%                     el_stats(i).theta_start=nan;
%                     el_stats(i).theta_stop=nan;
%                     el_stats(i).theta_duration=nan;
%                     el_stats(i).hfb_start=nan;
%                     el_stats(i).hfb_stop=nan;
%                     el_stats(i).hfb_duration=nan;
%                     el_stats(i).sig_hfb_autobio = 0;
%                     el_stats(i).sig_hfb_automath =0;
%                     el_stats(i).sig_theta_autobio=0;
%                     el_stats(i).sig_all=0;
%                 end
%             else
                if ~ isempty(sig_elecs)
                    sign(sig_elecs)=1;
                end
                for i=1:length(elecs)         
                    el_stats(i).subject=sbj_name;
                    el_stats(i).region =regions{ri};
                    el_stats(i).elecname=elec_names(i);
                    el_stats(i).elecnumber=elecs(i);
%                    el_stats(i).theta_start=theta_timing(i).start;
%                     el_stats(i).theta_stop=theta_timing(i).stop;
%                     el_stats(i).theta_duration=theta_timing(i).duration;
                    el_stats(i).hfb_start=hfb_timing(i).start;
                    el_stats(i).hfb_stop=hfb_timing(i).stop;
                    el_stats(i).hfb_duration=hfb_timing(i).duration;
                    el_stats(i).sig_hfb_autobio = hfb_elecs_a(i);
                    el_stats(i).sig_hfb_automath =hfb_elecs_am(i);
        %            el_stats(i).sig_theta_autobio=theta_elecs_a(i);
                    el_stats(i).sig_all=sign(i);
                end
                
%             end
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