
% Paired timing

% 1. select region
% 2. load the data from all subjects
% 3. paired regions
% 4. save data

clear all;clc;
project_name = 'MMR';

regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S18_119_AG';'S18_130_RH';'S18_131_L';'S18_131_R'};%;'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%;'S18_125'
locktype ='stim';
datapath_sot= '/Volumes/Ying_SEEG/Data_lbcn/Results/MMR/Group/Stats';
datapath_rol='/Volumes/Ying_SEEG/Data_lbcn/Results/MMR/Group/ROL'; % mmr permutation results path, used for selected sig channel
regions={'Hippocampus','PMC','mPFC'};%

freq_band='HFB';

% time=-0.202:0.002:2;
% tindx=find(time>0);
pairdata=table;
k=1;
    for subi=1:length(sbj_names)
        elec_names=[];
        elecs=[];
        sbj_name = sbj_names{subi}
      
        for ri=1:length(regions)
            %% selected the electrodes based on the anatomy
            ename{ri}=[];
            if strncmp('S18_131',sbj_name,7)
                [elec_names{ri},elecs{ri}] = ElectrodeBySubj_LR(sbj_name,regions{ri});
            else
                [elec_names{ri},elecs{ri}] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
            end
       
%         if strncmp('S18_131',sbj_name,7)
%             sbj_name='S18_131';
%         end
        ename{ri}=elec_names{ri};
        %% selected the significant one
        pfilename=dir(fullfile(datapath_rol,[sbj_name(1:7),'*',regions{ri},'.mat']));
        load (fullfile(datapath_rol,pfilename.name))
        
        enum=elecs{ri};
        filename1=dir(fullfile(datapath_sot,[sbj_name(1:7),'*',regions{ri},'.mat']));
        load(fullfile(datapath_sot,filename1.name));
        s_ele{ri}=intersect(find([el_stats.sig_hfb_autobio]>0),find([el_stats.sig_hfb_automath]>0));
        sot_ele{ri}= intersect(find(el_stats.hfb_start>=0.15),find(el_stats.hfb_start<=1.5));
        m_ele=find(ismember([el_stats.elecnumber],elecs{ri})>0);
         f_ele=intersect(m_ele,sot_ele{ri})
        sig_e{ri}=f_ele;
        sot{ri}=el_stats.hfb_start(sig_e{ri});
        
        rolmean{ri}= intersect(find(ROL.mean>=0.2),find(ROL.mean<=1.5));
        rolmedian{ri}= intersect(find(ROL.median>=0.2),find(ROL.median<=1.5));
        rolfitmean{ri}= intersect(find(ROL.fitmean>=0.2),find(ROL.fitmean<=1.5));
        rolfitmedian{ri}= intersect(find(ROL.fitmedian>=0.2),find(ROL.fitmedian<=1.5));
        
        
        s_rolmean{ri}= intersect(rolmean{ri},sig_e{ri});
        s_rolmedian{ri}= intersect(rolmedian{ri},sig_e{ri});
        s_rolfitmean{ri}= intersect(rolfitmean{ri},sig_e{ri});
        s_rolfitmedian{ri}= intersect(rolfitmedian{ri},sig_e{ri});
        
        end
           if ~isempty( sig_e{1}) && ~isempty(sig_e{2})&& ~isempty(sig_e{3})
                      
            for i=1:length(sig_e{1})
                for   j=1:length(sig_e{2})
                    for m=1:length(sig_e{3})
                        
                        pairdata.subname(k)= {sbj_name};
                        pairdata.PMC_elecs(k)= ename{1}(i);
                        pairdata.mPFC_elecs(k)= ename{2}(j);
                        pairdata.Hippo_elecs(k)= ename{3}(m);
                        pairdata.sot(k,1)=sot{1}(i);
                        pairdata.sot(k,2)=sot{2}(j);
                        pairdata.sot(k,3)=sot{3}(m);
                        k=k+1;
                    end
                end
            end
            
        else
            disp('no sig channel in some ROI')
        end
        
    end
    
    a=mean(pairdata.sot)
    b=std(pairdata.sot)/sqrt(size(pairdata.sot,1));    
        
        %% paired
      
    
%     for ri=1:length(regions)
%     data.(regions{ri}).sot=[];
%     data.(regions{ri}).rolmean=[];
%     data.(regions{ri}).rolmedian=[];
%     data.(regions{ri}).rolfitmean=[];
%     data.(regions{ri}).rolfitmedian=[];
%     data.(regions{ri}).sot=[data.(regions{ri}).sot;el_stats.hfb_start(sot_ele)];
%         data.(regions{ri}).rolmean=[data.(regions{ri}).rolmean;ROL.mean(intersect(sot_ele,rolmean))'];
%         data.(regions{ri}).rolmedian=[data.(regions{ri}).rolmedian;ROL.median(intersect(sot_ele,rolmedian))'];
%         
%         data.(regions{ri}).rolfitmean=[data.(regions{ri}).rolfitmean;ROL.fitmean(intersect(sot_ele,rolfitmean))'];
%         data.(regions{ri}).rolfitmedian=[data.(regions{ri}).rolfitmedian;ROL.fitmedian(intersect(sot_ele,rolfitmedian))'];    
%     end
 
    %% paired the electrodes
    
    cate={'sot'}%,'rolmedian','rolmean','rolfitmedian','rolfitmean'};
    regions={'Hippocampus','PMC','mPFC',};%
    pair=[1 2; 1 3;2 3];
    
for ri=1:length(cate)
     sdata.(cate{ri})=table;
    for ri=1:length(regions)
        rname=regions{ri};
        tmp{ri}=pairdata.sot{ri};
        sdata.(cate{ri}).mean(ri,1)=mean(tmp{ri},1);
        sdata.(cate{ri}).se(ri,1)=std(tmp{ri},1)/sqrt(size(tmp{ri},1));
    end  
       for pi=1:length(pair)
          
        [p, observeddifference, effectsize] = permutationTest(tmp{pair(pi,1)},tmp{pair(pi,2)},10000);
        sdata.(cate{ri}).p(pi)=p;
        sdata.(cate{ri}).diff(pi)= observeddifference;
        sdata.(cate{ri}).effectsize(pi)=effectsize;
       end
    end




save ([datapath_sot,'/pairdata_MMR_three_1207.mat'],'data','sdata');

%