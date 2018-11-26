clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'Memoria';
center = 'Stanford';
regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S17_118_TW';'S18_119_AG';'S18_130_RH';'S18_131'};%};%;%;'S12_33_DA';
%datapath ='/Users/yingfang/Documents/data/Results/MMR/Group/Stats/';
locktype ='stim';

server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/GitHub/lbcn_preproc';
for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
     dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            %filename1=dir(fullfile(datapath,[sbj_name,'*',regions{ri},'.mat']));
           % load(fullfile(datapath,filename1.name));
            [ROL] = getROLAll(sbj_name,project_name,block_names,dirs,elecs,'Band','HFB','stim',[],'condNames',{'autobio'});
            
            
            for i=1:length(elecs)
                for j=1:4
                el_stats.ROLmedian(i,j)=nanmedian(ROL.autobio.thr{elecs(i),j});
                el_stats.ROLmean(i,j)=nanmean(ROL.autobio.thr{elecs(i),j});
                end
            end
            
            
            dir_out= [dirs.result_root,filesep,project_name,filesep,'Group',filesep,'ROL',filesep];
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