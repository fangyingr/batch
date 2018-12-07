
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
datapath= '/Users/yingfang/Documents/data/Results/MMR/Group/ROL_125_5_4';
pdatapath='/Volumes/Ying_SEEG/Data_lbcn/Results/MMR/Group/ROL'; % mmr permutation results path, used for selected sig channel
regions={'PMC','mPFC','Hippocampus'};%

freq_band='HFB';

% time=-0.202:0.002:2;
% tindx=find(time>0);
pairdata=table;
for si=4
    
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
        end
        if strncmp('S18_131',sbj_name,7)
            sbj_name='S18_131';
        end
        for ri=1:length(regions)
            %% selected the significant one
            pfilename=dir(fullfile(pdatapath,[sbj_name,'*',regions{ri},'.mat']));
            load (fullfile(pdatapath,pfilename.name))
            for i=1:length(el_stats)
                enames(i)=el_stats(i).elecname;
            end
            enum=[el_stats.elecnumber];
            m_ele=find(ismember([el_stats.elecnumber],elecs{ri})>0);
            s_ele=intersect(find([el_stats.sig_hfb_autobio]>0),find([el_stats.sig_hfb_automath]>0));
            f_ele=intersect(m_ele,s_ele);
           % clear el_stats
            % load the rol result
          %  filename1=dir(fullfile(datapath,[sbj_name,'*',regions{ri},'.mat']));
          %  load(fullfile(datapath,filename1.name));
            r_ele=intersect(find([el_stats.ROLmean]>=0.05),find([el_stats.ROLmean]<=1.5));
            
            finalelec{ri}=intersect(f_ele,r_ele);
            rol_all=[el_stats.ROLmean];
            rol{ri}=rol_all(finalelec{ri});
            en{ri}=enum(finalelec{ri});
            ename{ri}=enames(finalelec{ri});
            
        end
        
        %% paired the electrodes
        
        
        if ~isempty(ename{1}) && ~isempty(ename{2})&& ~isempty(ename{3})
            
            
            
            for i=1:length(ename{1})
                for   j=1:length(ename{2})
                    for m=1:length(ename{3})
                        
                        pairdata.subname(k)= {sbj_name};
                        pairdata.PMC_elecs(k)= ename{1}(i);
                        pairdata.mPFC_elecs(k)= ename{2}(j);
                        pairdata.Hippo_elecs(k)= ename{3}(m);
                        pairdata.ROL(k,1)=rol{1}(i);
                        pairdata.ROL(k,2)=rol{2}(j);
                        pairdata.ROL(k,3)=rol{3}(m);
                        k=k+1;
                    end
                end
            end
            
        else
            disp('no sig channel in some ROI')
        end
    end
end

a=mean(pairdata.ROL)';
se=std(pairdata.ROL)'./sqrt(length(pairdata.ROL))
[p, observeddifference, effectsize] = permutationTest(pairdata.ROL(:,1),pairdata.ROL(:,2),10000)



save ([datapath,'/pairdata_MMR_three.mat'],'pairdata');

% C = [
%     0.90    0.55    0.55
%     0.62    0.76    0.84
%     0.89    0.10    0.11
%     0.12    0.47    0.70
%     ];

for i= 1:length(regions)
    rol_meandata.([regions{i,1},'_',regions{i,2}])=table;
    Y.([regions{i,1},'_',regions{i,2}])=[];
    E.([regions{i,1},'_',regions{i,2}])=[];
    N.([regions{i,1},'_',regions{i,2}])=[];
    p.([regions{i,1},'_',regions{i,2}])=[];
    for si=1:4
        rol=[];
        % plot
        rol=data.(['stim',num2str(si)]).([regions{i,1},'_',regions{i,2}]).rol;
        N.([regions{i,1},'_',regions{i,2}])(si,1)=size(rol,1);
        Y.([regions{i,1},'_',regions{i,2}])(si,:)=nanmean(rol);
        E.([regions{i,1},'_',regions{i,2}])(si,:)=nanstd(rol)/sqrt(size(rol,1));pfilename2
        [p.([regions{i,1},'_',regions{i,2}])(si,1), observeddifference, effectsize] = permutationTest(rol(:,1),rol(:,2),10000);
        
    end
    rol_meandata.([regions{i,1},'_',regions{i,2}]).rol=Y.([regions{i,1},'_',regions{i,2}]);
    rol_meandata.([regions{i,1},'_',regions{i,2}]).se =E.([regions{i,1},'_',regions{i,2}]);
    rol_meandata.([regions{i,1},'_',regions{i,2}]).elecN=N.([regions{i,1},'_',regions{i,2}]);
    rol_meandata.([regions{i,1},'_',regions{i,2}]).p=p.([regions{i,1},'_',regions{i,2}]);
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

