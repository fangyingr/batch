clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'Memoria';
center = 'Stanford';
regions = {'PMC';'mPFC';'Hippocampus';};
sbj_names ={'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;

%sbj_names ={'S17_118_TW';'S18_119_AG';'S18_130_RH';'S18_131'};%};%;%;'S12_33_DA';
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
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            %filename1=dir(fullfile(datapath,[sbj_name,'*',regions{ri},'.mat']));
           % load(fullfile(datapath,filename1.name));
           [rol_raw] = getROLAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',[],'condNames',{'autobio'},regions{ri});
            
            ROL=table;
            for i=1:length(elecs)
                ROL.median(i)=nanmedian(cell2mat(rol_raw.autobio.thr(elecs(i))));
                ROL.mean(i)=nanmean(cell2mat(rol_raw.autobio.thr(elecs(i))));
                ROL.fitmedian(i)=nanmedian(cell2mat(rol_raw.autobio.fit(elecs(i))));
                ROL.fitmean(i)=nanmean(cell2mat(rol_raw.autobio.fit(elecs(i))));    
            end
            
            
            dir_out= [dirs.result_root,filesep,project_name,filesep,'Group',filesep,'ROL',filesep];
            if ~exist(dir_out)
                mkdir(dir_out)
            end
            fm_out = sprintf('%s/%s_%s_%slock_%s.mat',dir_out,sbj_name,project_name,locktype,regions{ri});
            save(fm_out,'ROL')
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end