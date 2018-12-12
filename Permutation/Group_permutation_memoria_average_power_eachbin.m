clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'Memoria';
center = 'Stanford';
regions = {'Hippocampus';'PMC';'mPFC'};

sbj_names ={'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;

%{'S14_69_RTb';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S16_99_CJ';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;

%{'S17_110_SC';'S17_118_TW';};

locktype ='stim';

server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';
%dtime=[-0.2:0.002:8];
for ri=1:length(regions)
    
    data.(regions{ri})=table;
    
    k=1;
    for subi=1:length(sbj_names)
        
        sbj_name = sbj_names{subi};
        
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            tag = 'stimlock_bl_corr';
            [p,p_fdr,sig,binpower] = permutationStatsAll_memoria(sbj_name,project_name,block_names,dirs,elecs,tag,'condNames',{'autobio'},'HFB',[]);
            
            
            
            
            for ei=1:length(elecs)
                data.(regions{ri}).subname(k)={sbj_name};
                data.(regions{ri}).elecname(k)=elec_names(ei);
                data.(regions{ri}).elecnum(k)=elecs(ei);
                data.(regions{ri}).binpower(k,:)=binpower(ei,:);
                data.(regions{ri}).sigbin(k,:)=sig(ei,:);
                data.(regions{ri}).pval(k,:)=p(ei,:);
                k=k+1;
            end
            
            dir_out= [dirs.result_root,filesep,project_name,filesep,'Group',filesep,'Stats',filesep];
            if ~exist(dir_out)
                mkdir(dir_out)
            end
            save('/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats/Group_memoria_permutation_proportion_ave_bin_upaired_v2.mat','data')

            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end

regions = {'Hippocampus';'PMC';'mPFC'};
for ri=1:length(regions)
    sdata=[];
    sdata=data.(regions{ri}).sigbin;
    acc(ri,:)=sum(sdata)/size(sdata,1);
    binpower(ri,:)=nanmean(data.(regions{ri}).binpower,1);
    se(ri,:) = std(data.(regions{ri}).binpower,1)./sqrt(size(data.(regions{ri}).binpower,1));
end



for ri=1:length(regions)
    sdata=[];
    sindx=find((data.(regions{ri}).sigbin(:,4))>0);
    sdata=data.(regions{ri}).sigbin(sindx,:);
    acc(ri,:)=sum(sdata)/size(sdata,1);
    
end
