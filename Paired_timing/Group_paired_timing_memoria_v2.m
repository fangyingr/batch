
% Paired timing

% 1. select region
% 2. load the data from all subjects
% 3. paired regions
% 4. save data

clear all;clc;
project_name = 'Memoria';

regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names = {'S18_119_AG';'S14_69_RTb';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131_L';'S18_131_R'};%'S16_99_CJ';'S16_100_AF';'S17_105_TA';;

%{'S18_119_AG';'S18_130_RH';'S18_131_L';'S18_131_R'};%;'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%;'S18_125'
locktype ='stim';
datapath_rol= '/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/ROL/';
datapath_sot= '/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/Stats/';
%pdatapath='/Volumes/Ying_SEEG/Data_lbcn/Results/MMR/Group/Stats'; % mmr permutation results path, used for selected sig channel
%regions={'PMC','mPFC','Hippocampus'};%
pair_regions={'PMC','mPFC';'Hippocampus','PMC';'Hippocampus','mPFC'};%

% time=-0.202:0.002:2;
% tindx=find(time>0);
pairdata=table;

for rii=1:length(pair_regions)
    regions=pair_regions(rii,:);
    rname=[regions{1},'_',regions{2}];
    dataAll.(rname)=[]; dataAll.(rname)=table;
    for subi=1:length(sbj_names)
        elec_names=[];
        elecs=[];
        sbj_name = sbj_names{subi};
        
        for ri=1:length(regions)
            %% selected the electrodes based on the anatomy
            ename{ri}=[];
            if strncmp('S18_131',sbj_name,7)
                [elec_names{ri},elecs{ri}] = ElectrodeBySubj_LR(sbj_name,regions{ri});
            else
                [elec_names{ri},elecs{ri}] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
            end
            
        end
        if strncmp('S18_131',sbj_name,7)
            sbj_name='S18_131';
        end
        if ~isempty(elecs{1})&&~isempty(elecs{2})
            for ri=1:length(regions)
                clear el_stats ROL;
                pfilename=dir(fullfile(datapath_sot,[sbj_name,'*',regions{ri},'.mat']));
                load (fullfile(datapath_sot,pfilename.name))
                es{ri}=el_stats;
                rfilename=dir(fullfile(datapath_rol,[sbj_name,'*',regions{ri},'.mat']));
                load(fullfile(datapath_rol,rfilename.name));
                rol{ri}=ROL;
            end
            for i=1:length(elecs)
                %                 el_stats(i).ROLmedian=nanmedian(cell2mat(ROL.autobio.thr(elecs(i))));
                %                 el_stats(i).ROLmean=nanmean(cell2mat(ROL.autobio.thr(elecs(i))));
                %                 el_stats(i).ROLfitmedian=nanmedian(cell2mat(ROL.autobio.fit(elecs(i))));
                %                 el_stats(i).ROLfitmean=nanmean(cell2mat(ROL.autobio.fit(elecs(i))));
                %             end
                %
            end
            data=[];
            data=table;
            k=1;
            for i=1:length(elecs{1})
                for j=1:length(elecs{2})
                    
                    data.subject(k)={sbj_name};
                    % data.(rname)(k)={rname};
                    data.elecname(k,1)=elec_names{1}(i);
                    data.elecname(k,2)=elec_names{2}(j);
                    data.elecnum(k,1)=elecs{1}(i);
                    data.elecnum(k,2)=elecs{2}(j);
                    
                    sot1=[];sot2=[];
                    sot1=es{1};
                    sot2=es{2};
                    data.sot(k,1)=sot1.hfb_start(i);
                    data.sot(k,2)=sot2.hfb_start(j);
                    data.sig(k,1)=sot1.sig_hfb_autobio(i);
                    data.sig(k,2)=sot2.sig_hfb_autobio(j);
                    rol1=[];rol2=[];
                    rol1=rol{1};rol2=rol{2};
                    
                    data.rolmedian(k,1)=rol1.median(i);
                    data.rolmedian(k,2)=rol2.median(j);
                    
                    data.rolmean(k,1)=rol1.mean(i);
                    data.rolmean(k,2)=rol2.mean(j);
                    
                    data.rolfitmedian(k,1)=rol1.fitmedian(i);
                    data.rolfitmedian(k,2)=rol2.fitmedian(j);
                    
                    data.rolfitmean(k,1)=rol1.fitmean(i);
                    data.rolfitmean(k,2)=rol2.fitmean(j);
                    
                    k=k+1;
                end
            end
            
            dataAll.(rname)=[dataAll.(rname);data];
            
        else
            disp('No sig elecs in some ROI')
        end
        
        
    end
end


%% selected the significant one
time_thr=0.2;
for ri=1:length(pair_regions)
    clear s_elec sot_elec rol*
    regions=pair_regions(ri,:);
    rname=[regions{1},'_',regions{2}];
    s_elec=intersect(find(dataAll.(rname).sig(:,1)>0),find(dataAll.(rname).sig(:,2)>0));
    sot_elec=intersect(find(dataAll.(rname).sot(:,1)>time_thr),find(dataAll.(rname).sot(:,2)>time_thr));
    rol_median_elec=intersect(find(dataAll.(rname).rolmedian(:,1)>time_thr),find(dataAll.(rname).rolmedian(:,2)>time_thr));
    rol_mean_elec=intersect(find(dataAll.(rname).rolmean(:,1)>time_thr),find(dataAll.(rname).rolmean(:,2)>time_thr));
    rol_fitmedian_elec=intersect(find(dataAll.(rname).rolfitmedian(:,1)>time_thr),find(dataAll.(rname).rolfitmedian(:,2)>time_thr));
    rol_fitmean_elec=intersect(find(dataAll.(rname).rolfitmean(:,1)>time_thr),find(dataAll.(rname).rolfitmean(:,2)>time_thr));
    dataselect.sot.(rname)=table;
    dataselect.sot.(rname)=dataAll.(rname)(sot_elec,:);
    dataselect.rolmedian.(rname)=table;
    dataselect.rolmedian.(rname)=dataAll.(rname)(intersect(s_elec,rol_median_elec),:);
    
    dataselect.rolmean.(rname)=table;
    dataselect.rolmean.(rname)=dataAll.(rname)(intersect(s_elec,rol_mean_elec),:);
    
    dataselect.rolfitmedian.(rname)=table;
    dataselect.rolfitmedian.(rname)=dataAll.(rname)(intersect(s_elec,rol_median_elec),:);
    
    dataselect.rolfitmean.(rname)=table;
    dataselect.rolfitmean.(rname)=dataAll.(rname)(intersect(s_elec,rol_mean_elec),:);
    
end


a=dataselect.sot.PMC_mPFC.sot;
a=dataselect.sot.Hippocampus_PMC.sot;
a=dataselect.sot.Hippocampus_mPFC.sot;
[p, observeddifference, effectsize] = permutationTest(a(:,1),a(:,2),10000)
mean(a)

save ([datapath_rol,'/pairdata_memoria_1206.mat'],'dataAll','dataselect');

