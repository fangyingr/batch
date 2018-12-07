function OrganizeTrialInfoCMC(sbj_name, project_name, block_names, dirs)

for i = 1:length(block_names)
    bn = block_names{i};
    
    %% Load globalVar
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    
    % Load behavioral file
    soda = dir(fullfile(globalVar.psych_dir, '*.log'));
    fid=fopen([globalVar.psych_dir '/' soda.name]);
    dm=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s','Delimiter','\t','HeaderLines',3);
    fclose(fid);
    
    dn=cell(size(dm{1},1), size(dm,2));
    for i = 1:size(dm,2)
        dn(:,i)=dm{1,i};
    end
    dn1=[];
    dn1=dn(1,:);
    dn2=dn(2:length(dn),:);
    
    %% seperate data
    codeindx=find(ismember(dn1,'Code'));
    type6=[]; type6=dn(:,codeindx);
    TRsec1=[]; TRsec1=str2double(dn(:,codeindx+1));
    endind=find(ismember(type6,'end'));
    type=[];type=type6(1:endind,1);
    TRsec=[]; TRsec=TRsec1(1:endind,1);
    
    % find trigger
    dummyind=find(ismember(type(1:10,1),'15'));%%the lastest 15 as the trigger;
    start=dummyind(end);
    trigger_onset =TRsec(start) ;
    TR=[];TR=(TRsec-trigger_onset)/10000;
    
    condNames_Orig= {'Visu_C_','Audi_C_','Visu_IE','Visu_II','Audi_IE','Audi_II'};
    condNames_6={'Visu-CC','Audi-CC','Visu-IE','Visu-II','Audi-IE','Audi-II'};
    condNames_4={'Visu-CC','Audi-CC','Visu-IC','Visu-IC','Audi-IC','Audi-IC'};
    condNames_va = {'Attend-V','Attend-A','Attend-V','Attend-V','Attend-A','Attend-A'};
    condNames_cic={'C','C','IC','IC','IC','IC'};
    
    trialinfo = table;  k=1;
    type6=type;type4=type;typecic=type;typeva=type;
    onset=[];response=[];RT=[];correct=[];
    condNamesOrig=[];condNames6=[];condNames4=[];condNamescic=[];condNamesva=[];
    for ci=1:length(condNames_Orig)
        cind=[];crt=[];
        cind=find(strncmp(type,condNames_Orig{ci},7));
        type6(cind)=condNames_6(ci);
        type4(cind)=condNames_4(ci);
        typecic(cind)=condNames_cic(ci);
        typeva(cind)=condNames_va(ci);
        condNamesOrig=[condNamesOrig;type(cind)];
        condNames6=[condNames6;type6(cind)];
        condNames4=[condNames4;type4(cind)];
        condNamescic=[condNamescic;typecic(cind)];
        condNamesva=[condNamesva;typeva(cind)];
        onset=[onset;TR(cind)];
        response=[response;type(cind+1)];
        crt=TR(cind+1)-TR(cind);
        max=mean(crt)+3*std(crt);
        min=mean(crt)-3*std(crt);
        corr=ones(length(cind),1);
        corr(crt>max|crt<min)=-1;
        correct=[correct;corr];
        RT=[RT;crt];

    end
    correct(~ismember(response,'11')&~ismember(response,'12'))=0;
    [onsets,indx]=sort(onset);
    trialinfo.condNames_Orig = condNamesOrig(indx);
    trialinfo.condNames6 = condNames6(indx);
    trialinfo.condNames4 = condNames4(indx);
    trialinfo.condNamescic = condNamescic(indx);
    trialinfo.condNamesva = condNamesva(indx);
    trialinfo.StimulusOnsetTime=onsets;
    trialinfo.key=response(indx);
    trialinfo.RT=RT(indx);
    trialinfo.Accuracy=correct(indx);
    
    save([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
end

end
