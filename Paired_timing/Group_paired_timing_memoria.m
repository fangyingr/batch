% Paired timing

% 1. select region
% 2. load the data from all subjects
% 3. paired regions
% 4. save data

clear all;clc;
project_name = 'Memoria';

regions = {'Hippocampus';'PMC';'mPFC'};
sbj_names ={'S14_69_RTb';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_127';'S18_128_CG';'S18_130_RH';'S18_131'};%'S16_99_CJ';'S16_100_AF';'S17_105_TA';;

%{'S17_118_TW';'S18_119_AG';'S18_130_RH';'S18_131_L';'S18_131_R'};%;'S12_33_DA'};%};%;%;'S13_47_JT2'};%};%;'S18_125'
locktype ='stim';
datapath= '/Volumes/Ying_SEEG/Data_lbcn/Results/Memoria/Group/ROL/';
pdatapath='/Volumes/Ying_SEEG/Data_lbcn/Results/MMR/Group/ROL'; % mmr permutation results path, used for selected sig channel
pair_regions={'PMC','mPFC';'Hippocampus','PMC';'Hippocampus','mPFC'};%

freq_band='HFB';

% time=-0.202:0.002:2;
% tindx=find(time>0);
pairdata=cell(length(pair_regions),1);
pairROL=cell(length(pair_regions),1);
pairele=cell(length(pair_regions),1);

for si=1:4
    for ri=1:length(pair_regions)
        pairdata{ri}=[];
        pairROL{ri}=[];
        pairele{ri}=[];
        sbj{ri}=[];
        lag{ri}=[];
        for subi=1:length(sbj_names)
            sbj_name = sbj_names{subi};
            
            
            elec_names1=[];elecs1=[];elec_names2=[];elecs2=[];
            
            [elec_names1,elecs1] = ElectrodeBySubj_LR(sbj_name,pair_regions{ri,1});%ElectrodeBySubj_amy_corrected
            [elec_names2,elecs2] = ElectrodeBySubj_LR(sbj_name,pair_regions{ri,2});
            if strncmp('S18_131',sbj_name,7)
                [elec_names1LR,elecs1LR] = ElectrodeBySubj_LR(sbj_name,pair_regions{ri,1});
                [elec_names2LR,elecs2LR] = ElectrodeBySubj_LR(sbj_name,pair_regions{ri,2});
            end
            
            if ~isempty(elecs1) && ~isempty(elecs2)
                
                if strncmp('S18_131',sbj_name,7)
                    sbj_name='S18_131';
                    [elec_names1,elecs1] = ElectrodeBySubj(sbj_name,pair_regions{ri,1});
                    [elec_names2,elecs2] = ElectrodeBySubj(sbj_name,pair_regions{ri,2});
                end
                clear p_el_stats el_stats sindx1 s1 start1 rol1 rol11 rol111 ele1 ele11 ti01 si01
                
                % load mmr permutation result used for selected significant
                % channel
                
                pfilename1=dir(fullfile(pdatapath,[sbj_name,'*',pair_regions{ri,1},'.mat']));
                load (fullfile(pdatapath,pfilename1.name))
                p_el_stats=el_stats;
                si01=intersect(find([p_el_stats.sig_hfb_autobio]>0),find([p_el_stats.sig_hfb_automath]>0));
                clear el_stats
                % load the rol result
                filename1=dir(fullfile(datapath,[sbj_name,'*',pair_regions{ri,1},'.mat']));
                load(fullfile(datapath,filename1.name));
                ti01=intersect(find(el_stats.ROLmean(:,si)>=0.05),find(el_stats.ROLmean(:,si)<=1));
                %sindx1=si01;
                sindx1=intersect(ti01,si01);
                rol1=el_stats.ROLmean(:,si);
                
                clear p_el_stats el_stats sindx s2 start2 st1 st2 rol2 rol22 rol22 ele2 ele22 ti01 si01
                
                pfilename2=dir(fullfile(pdatapath,[sbj_name,'*',pair_regions{ri,2},'.mat']));
                load (fullfile(pdatapath,pfilename2.name));
                p_el_stats=el_stats;
                si01=intersect(find([p_el_stats.sig_hfb_autobio]>0),find([p_el_stats.sig_hfb_automath]>0));
                clear el_stats
                filename2=dir(fullfile(datapath,[sbj_name,'*',pair_regions{ri,2},'.mat']));
                load(fullfile(datapath,filename2.name));
                ti01=intersect(find(el_stats.ROLmean(:,si)>=0.05),find(el_stats.ROLmean(:,si)<=1));
                
                sindx=intersect(ti01,si01);
                rol2=el_stats.ROLmean(:,si);
                
                if ~isempty(sindx1) && ~isempty(sindx)
                    ele1 = elecs1(sindx1);
                    ele2 = elecs2(sindx);
                    if strncmp('S18_131',sbj_name,7)
                        ele1 = intersect(ele1,elecs1LR);
                        [~,sindx1]=ismember(ele1,elecs1);
                        ele2 = intersect(ele2,elecs2LR);
                        [~,sindx]=ismember(ele2,elecs2);
                    end
                    
                    
                    rol11=rol1(sindx1);
                    
                    rol22=rol2(sindx);
                    
                    ele11=[];ele22=[];
                    ele11=repmat(ele1',length(ele2),1);
                    ele22=repmat(ele2',length(ele1),1);
                    
                    pairele1=nan(length(sindx1)*length(sindx),2);
                    pairele1(:,1)=ele11;
                    pairele1(:,2)=ele22;
                    
                    
                    rol111=repmat(rol11,length(rol22),1);
                    rol221=repmat(rol22,length(rol11),1);
                    
                    pairROL1 = nan(length(sindx1)*length(sindx),2);
                    
                    pairROL1(:,1) = rol111;
                    pairROL1(:,2) = rol221;
                    
                    pairele{ri} =[pairele{ri};pairele1];
                    
                    pairROL{ri}=[pairROL{ri};pairROL1];
                    sbj{ri}=[sbj{ri};repmat({sbj_name},size(pairROL1,1),1)];
                    
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
        
        data.(['stim',num2str(si)]).([pair_regions{i,1},'_',pair_regions{i,2}])=table;
        data.(['stim',num2str(si)]).([pair_regions{i,1},'_',pair_regions{i,2}]).subname=sbj{i};
        data.(['stim',num2str(si)]).([pair_regions{i,1},'_',pair_regions{i,2}]).elec=pairele{i};
        data.(['stim',num2str(si)]).([pair_regions{i,1},'_',pair_regions{i,2}]).rol=pairROL{i};
        
        
    end
    
end

save ([datapath,'/pairdata_memoria.mat'],'data');

% C = [
%     0.90    0.55    0.55
%     0.62    0.76    0.84
%     0.89    0.10    0.11
%     0.12    0.47    0.70
%     ];

for i= 1:length(pair_regions)
    rol_meandata.([pair_regions{i,1},'_',pair_regions{i,2}])=table;
    Y.([pair_regions{i,1},'_',pair_regions{i,2}])=[]; 
    E.([pair_regions{i,1},'_',pair_regions{i,2}])=[];
    N.([pair_regions{i,1},'_',pair_regions{i,2}])=[];
    p.([pair_regions{i,1},'_',pair_regions{i,2}])=[];
    for si=1:4
        rol=[];
        % plot    
        rol=data.(['stim',num2str(si)]).([pair_regions{i,1},'_',pair_regions{i,2}]).rol;
        N.([pair_regions{i,1},'_',pair_regions{i,2}])(si,1)=size(rol,1);
        Y.([pair_regions{i,1},'_',pair_regions{i,2}])(si,:)=nanmean(rol);
        E.([pair_regions{i,1},'_',pair_regions{i,2}])(si,:)=nanstd(rol)/sqrt(size(rol,1));pfilename2
       [p.([pair_regions{i,1},'_',pair_regions{i,2}])(si,1), observeddifference, effectsize] = permutationTest(rol(:,1),rol(:,2),10000);
        
    end 
    rol_meandata.([pair_regions{i,1},'_',pair_regions{i,2}]).rol=Y.([pair_regions{i,1},'_',pair_regions{i,2}]);
    rol_meandata.([pair_regions{i,1},'_',pair_regions{i,2}]).se =E.([pair_regions{i,1},'_',pair_regions{i,2}]);
    rol_meandata.([pair_regions{i,1},'_',pair_regions{i,2}]).elecN=N.([pair_regions{i,1},'_',pair_regions{i,2}]);
    rol_meandata.([pair_regions{i,1},'_',pair_regions{i,2}]).p=p.([pair_regions{i,1},'_',pair_regions{i,2}]);
end






save([datapath,'/rol_meandata'],'rol_meandata');
%C = reshape(C, [2 2 3]);
        
        %% plot
%         
%         X_name={'Stim1','Stim1';
%             'Stim2','Stim2';
%             'Stim3','Stim3';
%             'Stim4','Stim4'};
%         
%         x_name={'','','Stim1','','Stim2','', 'Stim3','','Stim4',''}
%         X=[1 2; 3 4;5 6 ;7 8]
%         
%         hf = figure('Position', [100 100 850 400]);
%         
%         P = nan(numel(Y), numel(Y));
%         P(1,2) = p(1);
%         P(3,4) = p(2);
%         P(5,6) = p(3);
%         P(7,8) = p(4);
%         % Make P symmetric, by copying the upper triangle onto the lower triangle
%         PT = P';
%         lidx = tril(true(size(P)), -1);
%         P(lidx) = PT(lidx);
%         superbar(X,Y, 'E', E, 'Orientation', 'v', ...
%              'PLineOffset', 2);    
%         
%          set(gca,'xticklabel',x_name);
%         
%         % superbar(Y, 'E', E, 'P', P, 'BarFaceColor', C, 'Orientation', 'v','BarWidth', 2, ...
%          %   'ErrorbarStyle', 'T', 'PLineOffset', 3);    
   % end

