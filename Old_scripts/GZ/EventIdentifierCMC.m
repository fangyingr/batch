function EventIdentifierCMC (sbj_name, project_name, block_names, dirs, pdio_chan)
%% Globar Variable elements

%% loop across blocks
for bi = 1:length(block_names)
    bn = block_names{bi};
    
    %% Load globalVar
    
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    iEEG_rate=globalVar.iEEG_rate;
    
    %% reading analog channel from neuralData directory
    
    figureDim = [0 0 1 1];
    figure('units', 'normalized', 'outerposition', figureDim)
    subplot(2,3,1:3)
    onsets=[]; offsets=[];dur=[];
    
    for ci=1:length(pdio_chan)
        anlg=[];   pdio=[];
        load(sprintf('%s/Pdio%s_%.2d.mat',globalVar.originalData, bn, pdio_chan(ci))); % going to be present in the globalVar
        pdio = anlg/max(double(anlg))*2;
        
        
        %% Thresholding the signal
        ind_above= pdio > 0.5;
        ind_df= diff(ind_above);
        clear ind_above
        onset= find(ind_df==1);
        offset= find(ind_df==-1);
        pdio_onset= onset/globalVar.Pdio_rate;
        pdio_offset= offset/globalVar.Pdio_rate;
        
        if ~isequal(length(pdio_onset),length(pdio_offset))
            disp('onset and offset mismatch'),return
        end
        
        %get osnets from diode
        ind_df(offset)=0;
        all_ind(ci,:)=ind_df;
        plot(onset,2^(ci-1)*ones(length(onset),1),'r*');
        hold on
        clear ind_df onset offset
    end
    
    
    all_ind(2,all_ind(2,:)==1)=2;
    all_ind(3,all_ind(3,:)==1)=4;
    all_ind(4,all_ind(4,:)==1)=8;
    total=sum(all_ind);
    
    % if the indx of onset in differect channel mismatch
    oneset=find(total>0);
    ind=oneset(diff(oneset)<=5); % if two digits are too close to each other, they should be added
    if ~isempty(ind)
        total(ind)=total(ind)+total(ind+1);
        total(ind+1)=0;
    end
    
    ind_d=find(total==13);
    if ~isnan(ind_d)
        total_xx1=[];
        total_xx1=[total(1:ind_d-1) 1 12 total(ind_d+1:length(total))];
        total=[];
        total=total_xx1;
    end
    plot(total);
    
    %% calculate onsets
    onsets=find(total>0);
    triggers=total(onsets);
    
    dummy=find(triggers==15);
    dummy=dummy(dummy<10);  %% selet the 15 trigger in the first 10 triggers
    triggers=triggers(dummy(end):end);
    selec_trig=[4 5 6 8 9 10];
    trigger=triggers(ismember(triggers,selec_trig)); 
    onsets=sort(onsets(dummy(end):end));
    all_stim_onset=onsets(ismember(triggers,selec_trig))/globalVar.Pdio_rate;
    
%     if ismember(sbj_name,'S09_XKW')
%         all_stim_onset=all_stim_onset(1:end-1);
%         trigger=trigger(1:end-1);
%     end
    %% Comparing photodiod with behavioral data
    
    load([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
    StimulusOnsetTime = trialinfo.StimulusOnsetTime; % **
    
    %for just the first stimulus of each trial
    df_SOT= diff(StimulusOnsetTime)';
    % df_stim_onset= diff(stim_onset_fifth); %fifth? why?
    df_stim_onset = diff(all_stim_onset);
    %plot overlay
    subplot(2,3,4)
    plot(df_SOT,'o','MarkerSize',8,'LineWidth',3),hold on, plot(df_stim_onset,'r*')
    df= df_SOT - df_stim_onset;
    
    %plot diffs, across experiment and histogram
    subplot(2,3,5)
    plot(df);
    title('Diff. behavior diode (exp)');
    xlabel('Trial number');
    ylabel('Time (ms)');
    subplot(2,3,6)
    hist(df)
    title('Diff. behavior diode (hist)');
    xlabel('Time (ms)');
    ylabel('Count');
    
    %flag large difference
    if ~all(abs(df)<.1)
        disp('behavioral data and photodiod mismatch'),return
    end
    
    % selec_trig=[4 5 6 8 9 10];
    condNames={'Audi-CC','Audi-II','Audi-IE','Visu-CC','Visu-II','Visu-IE'};
    cn=trialinfo.condNames6;
    for i=1:length(condNames)
        scn=ismember(cn,condNames{i});
        stn=ismember(trigger',selec_trig(i));
        if ~isequal(scn,stn)
            disp('condition labels mismatch'),return
        end
    end
        %% Updating the events with onsets
        trialinfo.trigger=trigger';
        trialinfo.allonsets = all_stim_onset';
        trialinfo.RT_lock = trialinfo.RT + trialinfo.allonsets;
        
        fn= sprintf('%s/trialinfo_%s.mat',globalVar.result_dir,bn);
        save(fn, 'trialinfo');
        
    end
end


