
% Paired timing

% 1. select region
% 2. load the data from all subjects
% 3. paired regions
% 4. save data

clear all;clc;
project_name = 'Memoria';

regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S18_119_AG';'S18_130_RH';'S18_131_L';'S18_131_R'};%;'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%;'S18_125'
locktype ='stim';
datapath_sot= '/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats';
datapath_rol='/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/ROL'; % Memoria permutation results path, used for selected sig channel
regions={'Hippocampus','PMC','mPFC'};%

freq_band='HFB';

% time=-0.202:0.002:2;
% tindx=find(time>0);

for ri=1:length(regions)
    data.(regions{ri}).sot=[];
    data.(regions{ri}).rolmean=[];
    data.(regions{ri}).rolmedian=[];
    data.(regions{ri}).rolfitmean=[];
    data.(regions{ri}).rolfitmedian=[];
    for subi=1:length(sbj_names)
        elec_names=[];
        elecs=[];
        sbj_name = sbj_names{subi}
        
        for i=1:length(regions)
            %% selected the electrodes based on the anatomy
            ename{i}=[];
            if strncmp('S18_131',sbj_name,7)
                [elec_names{i},elecs{i}] = ElectrodeBySubj_LR(sbj_name,regions{i});
            else
                [elec_names{i},elecs{i}] = ElectrodeBySubj_amy_corrected(sbj_name,regions{i});
            end
        end
        if strncmp('S18_131',sbj_name,7)
            sbj_name='S18_131';
        end
        
        %% selected the significant one
        pfilename=dir(fullfile(datapath_rol,[sbj_name,'*',regions{ri},'.mat']));
        load (fullfile(datapath_rol,pfilename.name))
        
        enum=elecs{ri};
        filename1=dir(fullfile(datapath_sot,[sbj_name,'*',regions{ri},'.mat']));
        load(fullfile(datapath_sot,filename1.name));
        s_ele=find([el_stats.sig_hfb_autobio]>0);
        sot_ele= intersect(find(el_stats.hfb_start>=0.2),find(el_stats.hfb_start<=7));
        rolmean= intersect(find(ROL.mean>=0.2),find(ROL.mean<=7));
        rolmedian= intersect(find(ROL.median>=0.2),find(ROL.median<=7));
        rolfitmean= intersect(find(ROL.fitmean>=0.2),find(ROL.fitmean<=7));
        rolfitmedian= intersect(find(ROL.fitmedian>=0.2),find(ROL.fitmedian<=7));
        
        data.(regions{ri}).sot=[data.(regions{ri}).sot;el_stats.hfb_start(sot_ele)];
        data.(regions{ri}).rolmean=[data.(regions{ri}).rolmean;ROL.mean(intersect(sot_ele,rolmean))];
        data.(regions{ri}).rolmedian=[data.(regions{ri}).rolmedian;ROL.median(intersect(sot_ele,rolmedian))];
        
        data.(regions{ri}).rolfitmean=[data.(regions{ri}).rolfitmean;ROL.fitmean(intersect(sot_ele,rolfitmean))];
        data.(regions{ri}).rolfitmedian=[data.(regions{ri}).rolfitmedian;ROL.fitmedian(intersect(sot_ele,rolfitmedian))];    
        
    end
end
    %% paired the electrodes
    
    cate={'sot','rolmedian','rolmean','rolfitmedian','rolfitmean'};
    regions={'Hippocampus','PMC','mPFC',};%
    pair=[1 2; 1 3;2 3]
    
for i=1:length(cate)
     sdata.(cate{i})=table;
    for ri=1:length(regions)
        rname=regions{ri};
        tmp{ri}=data.(rname).(cate{i});
        sdata.(cate{i}).mean(ri,1)=mean(tmp{ri},1);
        sdata.(cate{i}).se(ri,1)=std(tmp{ri},1)/sqrt(size(tmp{ri},1));
    end  
       for pi=1:length(pair)
          
        [p, observeddifference, effectsize] = permutationTest(tmp{pair(pi,1)},tmp{pair(pi,2)},10000);
        sdata.(cate{i}).p(pi)=p;
        sdata.(cate{i}).diff(pi)= observeddifference;
        sdata.(cate{i}).effectsize(pi)=effectsize;
       end
    end




save ([datapath_sot,'/pairdata_Memoria_three_1207.mat'],'data','sdata');

%