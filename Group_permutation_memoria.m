clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'Memoria';
center = 'Stanford';
regions = {'PMC';'mPFC';'Hippocampus'};
sbj_names ={'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%;
%{'S17_110_SC';'S17_118_TW';};

locktype ='stim';

server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';
dtime=[-0.2:0.002:8]
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
            
            %[~, ~, ~, ~, ~, ~, hfb_elecs_am] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'SpecDense',locktype,'condNames',{'autobio','math'},[],'Spec',1,[],regions{ri});
            
            %  [~, ~, ~, ~, ~, ~, hfb_elecs_am] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',locktype,'condNames',{'autobio','math'},[],'Band',1,[],regions{ri});
            
            [pval, t_orig, ~, ~, ~, hfb_timing,hfb_elecs_a,time_events] = clusterPermutationStatsAll(sbj_name,project_name,block_names,dirs,elecs,'HFB',locktype,'condNames',{'autobio'},[],'Band',1,[],regions{ri}); %
            
            te=[];te=[0 time_events];
            for ei=1:length(elecs)
                data.(regions{ri}).subname(k)={sbj_name};
                data.(regions{ri}).elecname(k)=elec_names(ei);
                data.(regions{ri}).elecnum(k)=elecs(ei);
                for si=1:length(te)-1
                    sigindx=[];timeindx=[];sigbinindx=[]; sg=[];
                    sigindx=intersect(find(pval{ei}<0.05),find(t_orig{ei}>0));
                    timeindx=intersect(find(dtime>te(si)),find(dtime<=te(si+1)));
                    sigbinindx=intersect(sigindx,timeindx);
                    if isempty(sigbinindx)
                        sg=0;
                        sonset=nan;
                        sonset_raleticve=nan;
                    else
                        sg=1;
                        sonset=dtime(sigbinindx(1));
                        sonset_raleticve=dtime(sigbinindx(1))-te(si);
                    end
                    
                    data.(regions{ri}).sigbin(k,si)=sg;
                    data.(regions{ri}).sonset(k,si)=sonset;
                    data.(regions{ri}).sonset_raleticve(k,si)=sonset_raleticve;
                end
                k=k+1;
            end
                      
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end

save('/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats/Group_memoria_permutation_proportion.mat','data')

for ri=1:length(regions)
 sdata=[];
 sdata=data.(regions{ri}).sigbin;
 acc(ri,:)=sum(sdata)/size(sdata,1);
 
end

for ri=1:length(regions)
 sdata=[];
 sindx=find((data.(regions{ri}).sigbin(:,4))>0);
 sdata=data.(regions{ri}).sigbin(sindx,:);
 acc(ri,:)=sum(sdata)/size(sdata,1);
 
end
