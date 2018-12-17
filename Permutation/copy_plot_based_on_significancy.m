clear;clc;
load('/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats/Group_memoria_permutation_proportion_ave_bin_upaired_v222_real_diff.mat')
sbj_names ={'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;;

regions = {'Hippocampus';'PMC';'mPFC'};
periods = {'baseline','stim1','stim2','stim3','stim4'};

plotpath='/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria';
datapath='/Users/yingfang/Documents/Onedrive/OneDrive - Leland Stanford Junior University/Memoria_mmr_project/plots/Memoria/';
tag='Figures/BandData/HFB/stimlock/autobio_math';
project_name='Memoria';
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';
for si= 1:5
    for ri =1:length(regions)
        
        for ii=1:length(data.(regions{ri}).binpower(:,si))
            sbj_name=[];sbj_name=data.(regions{ri}).subname(ii);
            sbj_name=sbj_name{1};
            
            if data.(regions{ri}).sigbin(ii,si)==1
               elec=[]; elecs_all =[];globalVar=[];
                dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
                block_names = BlockBySubj(sbj_name,project_name);
                
                load(sprintf('%s/OriginalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
               
                elec=globalVar.channame(data.(regions{ri}).elecnum(ii));

                copypath=dir(fullfile(plotpath,sbj_name,tag,[sbj_name,'_',elec{1},'_*.png']));%_Memoria_HFB_stimlock_autobio_math
                copyfilename=[fullfile(plotpath,sbj_name,tag),filesep,copypath.name];
                if data.(regions{ri}).real_meandiff(ii,si)>0
                    
                    topath=fullfile(datapath,'all_baseline',regions{ri},periods{si},'positive');
                    
                elseif data.(regions{ri}).real_meandiff(ii,si)<0
                    topath=fullfile(datapath,'all_baseline',regions{ri},periods{si},'negtive');
                end
                
                tofilename=[topath,filesep,copypath.name];
                
                if ~exist(topath)
                    mkdir(topath)
                end
                
                copyfile(copyfilename,tofilename)
                
            else
                
                disp('not significant')
            end
            
        end
        
        
    end
end
