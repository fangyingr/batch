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
comp_root = '//Volumes/Ying_SEEG/Data_lbcn';%'/Users/yingfang/Documents/data';%
code_root = '/Users/yingfang/Documents/lbcn_preproc';%dtime=[-0.2:0.002:8];
for ri=1:length(regions)
    
    data.(regions{ri})=table;
    
    k=1;
    for subi=1:length(sbj_names)
        
        sbj_name = sbj_names{subi};
        
        dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root,code_root);
        block_names = BlockBySubj(sbj_name,project_name);
        
        load(sprintf('%s/OriginalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
        elecs_all = setdiff(1:globalVar.nchan,globalVar.refChan);
        
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            tag = 'stimlock_bl_corr';
            [p,p_fdr,sig,binpower,real_meandiff] = permutationStatsAll_memoria(sbj_name,project_name,block_names,dirs,elecs,tag,'condNames',{'autobio'},'HFB',[]);
            
            
            
            
            for ei=1:length(elecs)
                data.(regions{ri}).subname(k)={sbj_name};
                data.(regions{ri}).elecname(k)=elecs_all(elecs(ei));
                data.(regions{ri}).elecnum(k)=elecs(ei);
                data.(regions{ri}).binpower(k,:)=binpower(ei,:);
                data.(regions{ri}).sigbin(k,:)=sig(ei,:);
                data.(regions{ri}).pval(k,:)=p(ei,:);
                data.(regions{ri}).real_meandiff(k,:)= real_meandiff(ei,:);
                k=k+1;
            end
            
            %             dir_out= [dirs.result_root,filesep,project_name,filesep,'Group',filesep,'Stats',filesep];
            %             if ~exist(dir_out)
            %                 mkdir(dir_out)
            %             end
            %             save('/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats/Group_memoria_permutation_proportion_ave_bin_upaired_v3.mat','data')
            %
            %
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end


dir_out= [dirs.result_root,filesep,project_name,filesep,'Group',filesep,'Stats',filesep];
if ~exist(dir_out)
    mkdir(dir_out)
end
save('/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats/Group_memoria_permutation_proportion_ave_bin_upaired_v222_real_diff.mat','data')

regions = {'Hippocampus';'PMC';'mPFC'};
for ri=1:length(regions)
    for li=1:5
        sdata=[];
        sindx=find(data.(regions{ri}).real_meandiff(:,li)>0);
        sdata=data.(regions{ri}).sigbin(sindx,li);
        acc(ri,li)=sum(sdata)/size(data.(regions{ri}).binpower,1);
    end
    binpower(ri,:)=nanmean(data.(regions{ri}).binpower,1);
    se(ri,:) = std(data.(regions{ri}).binpower,1)./sqrt(size(data.(regions{ri}).binpower,1));
    
end


regions = {'Hippocampus';'PMC';'mPFC'};
for ri=1:length(regions)
    sdata=[];
    sindx=find((data.(regions{ri}).sigbin(:,1))<1);
    sdata=data.(regions{ri}).sigbin(sindx,:);;
    acc(ri,:)=sum(sdata)/size(sdata,1);
    binpower(ri,:)=nanmean(data.(regions{ri}).binpower,1);
    se(ri,:) = std(data.(regions{ri}).binpower,1)./sqrt(size(data.(regions{ri}).binpower,1));
end


for ri=1:length(regions)
    sdata=[];
    sindx1=find((data.(regions{ri}).sigbin(:,1))<1);
    sindx2=find((data.(regions{ri}).sigbin(:,5))>0);
    sindx =intersect(sindx1,sindx2);
    sdata=data.(regions{ri}).sigbin(sindx,:);
    acc(ri,:)=sum(sdata)/size(sdata,1);
    
end
