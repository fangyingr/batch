function [p,binpower] = permutationStats_memoria(data,column,conds,stats_params)

% This function takes in a data structure (trials x time) for a single
% channel and compares either two conditions (if conds has two elements) or
% a single condition vs. baseline (if conds has a single element)

%% INPUTS:
%       data:           data structure
%       column:         column name of data.trialinfo where conds are found
%       conds:          cell containing cond name(s) (1 or 2) to compare
%       stats_params:   .task_win:   2-element vector specifying window of time to use in stats (in sec)
%                       .bl_win:     2-element vector specifying window to use for baseline (in sec)- only relevent when 1 condition
%                       .paired:     true or false:
%                                    when comparing two conditions, can only do unpaired test (i.e. false)
%                                    when comparing one condition to baseline, can do paired or unpaired test
%                                    (for paired, will only use baseline periods just prior to trials of interest;
%                                    for unpaired, will use baseline periods from all trials)
%                       .nreps:      # of reps for permutation: default = 10000
%                       .noise_method:   'trials' or 'timepts': how to eliminate trials
%                       .freq_range:    2-element vector specifying freq range to use for stats
%                                       (for spectral data only)


%%

if ndims(data.wave)== 3 %if spectral data, average across frequencies of interest
    freq_inds = find(data.freqs >= stats_params.freq_range(1) & data.freqs <= stats_params.freq_range(2));
    data.wave = squeeze(nanmean(data.wave(freq_inds,:,:)));
end

%if strcmp(stats_params.noise_method,'trials') % eliminate noisy trials
    [grouped_trials,cond_names] = groupConds(conds,data.trialinfo,column,'trials',stats_params.noise_fields_trials,1);
for ci=1:length(conds)
tmp_data{ci}=data.wave(grouped_trials{ci},:);
end
%end
time_events = cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)));
time_events =[-0.5 0 time_events];
bl_inds = find(data.time >= stats_params.bl_win(1) & data.time <= stats_params.bl_win(2));
   
for si=1:length(time_events)-1
    task_win=[time_events(si),time_events(si)+1];
    task_inds = find(data.time >= task_win(1) & data.time <= task_win(2));
    
    
    dataA = nanmean(tmp_data{1}(:,task_inds),2); % average across timepts within each trial
    binpower (1,si) =nanmean(dataA);
    if length(conds)==1 % comparing one condition vs. baseline
        if stats_params.paired
            dataB = nanmean(tmp_data{1}(:,bl_inds),2);
            p(1,si) = permutation_paired(dataA,dataB,stats_params.nreps);
        else
             dataB = nanmean(data.wave(:,bl_inds),2);
            p(1,si) = permutation_unpaired(dataA,dataB,stats_params.nreps);
        end
    else  % comparing two conditions
        dataB = nanmean(tmp_data{2}(:,task_inds),2);
        p(1,si) = permutation_unpaired(dataA,dataB,stats_params.nreps);
    end
end


