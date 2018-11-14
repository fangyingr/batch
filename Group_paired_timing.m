% Paired timing

% 1. select region
% 2. load the data from all subjects
% 3. paired regions
% 4. save data

clear all;clc;
project_name = 'MMR';

regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S12_42_NC';'S17_118_TW';'S18_119_AG';'S12_33_DA';'S12_38_LK';'S18_130_RH'};%;'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%;'S18_125'
locktype ='stim';
datapath= '/Users/yingfang/Documents/data/Results/MMR/Group/ROL/';
pair_regions={'PMC','mPFC';'Hippocampus','PMC';'Hippocampus','mPFC'};%

freq_band='HFB';

time=-0.202:0.002:2;
tindx=find(time>0);
pairdata=cell(length(pair_regions),1);
pairROL=cell(length(pair_regions),1);
pairele=cell(length(pair_regions),1);
for ri=1:length(pair_regions)
    pairdata{ri}=[];
    pairROL{ri}=[];
    pairele{ri}=[];
    sbj{ri}=[];
    lag{ri}=[];
    for subi=1:length(sbj_names)
        sbj_name = sbj_names{subi};
        
        
        elec_names1=[];elecs1=[];elec_names2=[];elecs2=[];
        
        [elec_names1,elecs1] = ElectrodeBySubj(sbj_name,pair_regions{ri,1});
        [elec_names2,elecs2] = ElectrodeBySubj(sbj_name,pair_regions{ri,2});
        
        
        if ~isempty(elecs1) && ~isempty(elecs2)
            
            clear el_stats sindx1 s1 start1 rol1 rol11 rol111 ele1 ele11 ti01 si01
            filename1=dir(fullfile(datapath,[sbj_name,'*',pair_regions{ri,1},'.mat']));
            load(fullfile(datapath,filename1.name));
            ti01=intersect(intersect(find([el_stats.ROLmean]>=0.1),find([el_stats.ROLmean]<=2)),intersect(find([el_stats.hfb_start]>=0.1),find([el_stats.hfb_start]<=2)));
            si01=intersect(find([el_stats.sig_hfb_autobio]>0),find([el_stats.sig_hfb_automath]>0));
            %sindx1=si01;
            sindx1=intersect(ti01,si01);
            s1=[el_stats.hfb_start];
            rol1=[el_stats.ROLmean];
            
            clear el_stats sindx s2 start2 st1 st2 rol2 rol22 rol22 ele2 ele22 ti01 si01
            filename2=dir(fullfile(datapath,[sbj_name,'*',pair_regions{ri,2},'.mat']));
            load(fullfile(datapath,filename2.name));
            ti01=intersect(find([el_stats.ROLmean]>0.1),find([el_stats.hfb_start]>0.1));
            si01=intersect(find([el_stats.sig_hfb_autobio]>0),find([el_stats.sig_hfb_automath]>0));
            sindx=intersect(ti01,si01);
            
            s2=[el_stats.hfb_start];
            rol2=[el_stats.ROLmean];
            
            if ~isempty(sindx1) && ~isempty(sindx)
                
                
                start1=s1(sindx1);
                rol11=rol1(sindx1);
                ele1=elecs1(sindx1);
                
                
                
                start2=s2(sindx);
                rol22=rol2(sindx);
                ele2 = elecs2(sindx);
                ele11=[];ele22=[];
                ele11=repmat(ele1',length(ele2),1);
                ele22=repmat(ele2',length(ele1),1);
                
                pairele1=nan(length(start1)*length(start2),2);
                pairele1(:,1)=ele11;
                pairele1(:,2)=ele22;
                server_root = '/Volumes/neurology_jparvizi$/';
                comp_root = '/Users/yingfang/Documents/data';
                
                dirs = InitializeDirs(project_name,sbj_name,comp_root,server_root);
                block_names = BlockBySubj(sbj_name,project_name);
                region_tag=[pair_regions{ri,1},'_',pair_regions{ri,2}];
                crosscorr = computeCrossCorrAll(sbj_name,project_name,block_names,dirs,ele11,ele22,'one',locktype,'HFB','condNames',{'autobio'},[],region_tag)
                
                
                st1=repmat(start1',length(start2),1);
                st2=repmat(start2',length(start1),1);
                rol111=repmat(rol11',length(rol22),1);
                rol221=repmat(rol22',length(rol11),1);
                pairdata1=nan(length(start1)*length(start2),2);
                pairROL1 = nan(length(start1)*length(start2),2);
                pairdata1(:,1)=st1;
                pairdata1(:,2)=st2;
                pairROL1(:,1) = rol111;
                pairROL1(:,2) = rol221;
                
                pairele{ri} =[pairele{ri};pairele1];
                pairdata{ri}=[pairdata{ri};pairdata1];
                pairROL{ri}=[pairROL{ri};pairROL1];
                sbj{ri}=[sbj{ri};repmat({sbj_name},size(pairROL1,1),1)];
                lag{ri}=[lag{ri};[crosscorr.autobio.lag_peak_max_time]];
                disp([sbj_name,pair_regions{ri,1},pair_regions{ri,2}]);
            else
                disp('no enough significant electrodes')
                
            end
        else
            
            disp('no enough electrodes')
            
        end
        
    end
end
for i=1:length(pair_regions)
    
    data.([pair_regions{i,1},'_',pair_regions{i,2}])=table;
    data.([pair_regions{i,1},'_',pair_regions{i,2}]).subname=sbj{i}
    data.([pair_regions{i,1},'_',pair_regions{i,2}]).elec=pairele{i}
    data.([pair_regions{i,1},'_',pair_regions{i,2}]).rol=pairROL{i}
    data.([pair_regions{i,1},'_',pair_regions{i,2}]).sig_onset=pairdata{i}
    data.([pair_regions{i,1},'_',pair_regions{i,2}]).lag=lag{i}
end



save ('pairdata.mat','data');


a=pairdata{1}(:,2);
b=pairdata{1}(:,1);

a=pairROL{1}(:,2);
b=pairROL{1}(:,1);
a=[data.PMC_mPFC.lag];
b=zeros(length(a),1);

[p, observeddifference, effectsize] = permutationTest(a,b,10000)

subplot (1,3,1)
boxplot(pairROL{1})
subplot (1,3,2)
boxplot(pairROL{2})
subplot (1,3,3)
boxplot(pairROL{3})

subplot (1,3,1)
boxplot(pairdata{1})
subplot (1,3,2)
boxplot(pairdata{2})
subplot (1,3,3)
boxplot(pairdata{3})



sig_onset=median(pairdata{1});
rol_onset=median(pairROL{1});

sig_onset=mean(pairdata{1});
rol_onset=mean(pairROL{1});

bar([sig_onset;rol_onset]);

sonset=diff(pairROL{1},[],2).*1000

ronset=diff(pairdata{1},[],2).*1000

boxplot(sonset)
boxplot(ronset)

a=diff(pairdata{1},[],2)


median(a)


