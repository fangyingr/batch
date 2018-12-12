function  xcorr_all =laggedCorrPerm(sbj_name,project_name,block_names,dirs,elecs1,elecs2,freqband,xcorr_params,column,conds)
% This function 

%% OUTPUTS:
%    xcorr_all.zscore: z-score of lagged correlation peak (window around peak)
%                      relative to that of surrogate distribution
%                      (shuffling trials when pairing elecs)
%    xcorr_all.tlag_max: time (in s) at which max peak occurs in lagged
%                        correlation (neg. if elec1 leads elec2)
%    xcorr_all.trace_mn: mean of single-trial lagged correlation timecourses 
%                        between a pair of electrodes
%    xcorr_all.permtrace_mn: mean of permuted lagged correlation timecourses 
%                            (each of which is a mean across 'trials)
%                            between a pair of electrodes          
%    xcorr_all.permtrace_sd: std. of permuted lagged correlation timecourses


if isempty(conds)
    conds = unique(data.trialinfo.(column));
end

if isempty(xcorr_params)
    xcorr_params = genXCorrParams(project_name);
end

load([dirs.data_root,filesep,'OriginalData',filesep,sbj_name,filesep,'global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])

dir_in = [dirs.data_root,filesep,'BandData',filesep,freqband,filesep,sbj_name,filesep,block_names{1},'/EpochData/'];
load(sprintf('%s/%siEEG_stimlock_bl_corr_%s_%.2d.mat',dir_in,freqband,block_names{1},elecs1(1)));

%nperm = 200;
half_win = floor(xcorr_params.maxwin*data.fsample);
fs = data.fsample;
winSize = floor(fs*xcorr_params.sm_win);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

% if multiple stim per trial, get onset of each stim (relative to 1st stim)
stimtime = [0 cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)))];
stiminds = nan(size(stimtime));
for i = 1:length(stimtime)
    stiminds(i)= find(data.time>stimtime(i),1);
end

befInd = round(xcorr_params.pre_event * fs);
aftInd = round(xcorr_params.post_event * fs);
time = (befInd:aftInd)/fs;
siglength = length(time);

%% organize data
concatfield = {'wave'};
tag = 'stimlock';
if xcorr_params.blc
    tag = [tag,'_bl_corr'];
end

for ci = 1:length(conds)
    tmp_trials = find(strcmp(data.trialinfo.(column),conds{ci}));
    nstim(ci)=round(nanmedian(data.trialinfo.nstim(tmp_trials)));
    cond = conds{ci};
    sig.(cond) = cell(globalVar.nchan,nstim(ci));
end

disp('Concatenating data across blocks...')
elecs = union(elecs1,elecs2);
for ei = 1:length(elecs)
    el = elecs(ei);
    data_all = concatBlocks(sbj_name,block_names,dirs,el,freqband,'Band',concatfield,tag);
    if (xcorr_params.smooth)
        data_all.wave = convn(data_all.wave,gusWin','same');
    end
    [grouped_trials,grouped_condnames] = groupConds(conds,data_all.trialinfo,column,xcorr_params.noise_method,xcorr_params.noise_fields_trials,false);
    [grouped_trials_all,~] = groupConds(conds,data_all.trialinfo,column,'none',xcorr_params.noise_fields_trials,false);
    nconds = length(grouped_trials);
    for ci = 1:nconds
        ntrials(ci)=length(grouped_trials_all{ci});
        cond = grouped_condnames{ci};
        bad_trials = setdiff(grouped_trials_all{ci},grouped_trials{ci});
        bad_trials = find(ismember(grouped_trials_all{ci},bad_trials));
        for ii = 1:nstim(ci)
            %             sig.(cond){el,ii} = [sig.(cond){el,ii}; data_all.wave(grouped_trials_all{ci},stiminds(ii)+befInd:stiminds(ii)+aftInd)];
            sig.(cond){el,ii} = data_all.wave(grouped_trials_all{ci},stiminds(ii)+befInd:stiminds(ii)+aftInd);
            sig.(cond){el,ii}(bad_trials,:)=NaN;
        end
    end
end
disp('DONE')

% check if file exists already- load
fn_xcorr = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'ROL',filesep,'permuted_xcorr_',sbj_name,'_',freqband,'.mat'];
if exist(fn_xcorr)
    load(fn_xcorr)
else
    for ci = 1:length(conds)
        cond = conds{ci};
        xcorr_all.zscore.(cond) = nan(globalVar.nchan,globalVar.nchan,nstim(ci));
        xcorr_all.tlag_max.(cond) = nan(globalVar.nchan,globalVar.nchan,nstim(ci));
        xcorr_all.trace_mn.(cond) = cell(globalVar.nchan,globalVar.nchan,nstim(ci));
        xcorr_all.permtrace_mn.(cond) = cell(globalVar.nchan,globalVar.nchan,nstim(ci));
        xcorr_all.permtrace_sd.(cond) = cell(globalVar.nchan,globalVar.nchan,nstim(ci));
    end
end

% ntrials = length((ROL.autobio.thr{1,1}));
% siglength = size(ROL.autobio.traces{1,1},2);

% z_xcorr = nan(globalVar.nchan,globalVar.nchan);
% tmax_xcorr = nan(globalVar.nchan,globalVar.nchan);
% xcorr_real_all = cell(globalVar.nchan,globalVar.nchan);
% xcorr_perm_mean = cell(globalVar.nchan,globalVar.nchan);
% xcorr_perm_std = cell(globalVar.nchan,globalVar.nchan);

for e1 = elecs1
    for e2 = elecs2(elecs2>e1)
        for ci = 1:length(conds)
            cond = conds{ci};
            if strcmp(cond,'math')
                stim_nums = [3 5];
            elseif strcmp(cond,'autobio')
                stim_nums = 4;
            end
            for si = stim_nums
                if isnan(xcorr_all.zscore.(cond)(e1,e2,si)) % don't rerun if already saved previously
                    C_all = nan(ntrials(ci),siglength*2-1);
                    for i = 1:ntrials
                        % [C_all(i,:),lags] = crosscorr(ROL.autobio.traces{e1,4}(i,:),ROL.autobio.traces{e2,4}(i,:),'NumLags',nlags);
                        [C_all(i,:),lags] = xcorr(sig.(cond){e1,si}(i,:)/nanmax(sig.(cond){e1,si}(:)),sig.(cond){e2,si}(i,:)/nanmax(sig.(cond){e2,si}(:)));
                        % [C_all(i,:),lags] = xcov(normMinMax(ROL.autobio.HFB_traces{e1,4}(i,:)),normMinMax(ROL.autobio.HFB_traces{e2,4}(i,:)));
                    end
                    xcorr_all.lags = lags/fs;
                    C_real = nanmean(C_all);
                    xcorr_all.trace_mn.(cond){e1,e2,si}=C_real;
                    xcorr_all.trace_mn.(cond){e2,e1,si}=C_real(end:-1,1);
                    C_perm = nan(xcorr_params.nreps,siglength*2-1);
                    for ri = 1:xcorr_params.nreps
                        randinds = randperm(ntrials);
                        C_all = nan(ntrials(ci),siglength*2-1);
                        for i = 1:ntrials
                            %         [C_all(i,:),lags] = crosscorr(ROL.autobio.traces{e1,4}(i,:),ROL.autobio.traces{e2,4}(randinds(i),:),'NumLags',nlags);
                            [C_all(i,:),lags] = xcorr(sig.(cond){e1,si}(i,:)/nanmax(sig.(cond){e1,si}(:)),sig.(cond){e2,si}(randinds(i),:)/nanmax(sig.(cond){e2,si}(:)));
                            % [C_all(i,:),lags] = xcov(normMinMax(ROL.autobio.HFB_traces{e1,4}(i,:)),normMinMax(ROL.autobio.HFB_traces{e2,4}(i,:)));
                            C_perm(ri,:) = nanmean(C_all);
                        end
                    end
                    
                    xcorr_all.permtrace_mn.(cond){e1,e2,si}=nanmean(C_perm);
                    xcorr_all.permtrace_mn.(cond){e2,e1,si}=xcorr_all.permtrace_mn.(cond){e1,e2,si}(end:-1:1);
                    xcorr_all.permtrace_sd.(cond){e1,e2,si}=nanstd(C_perm);
                    xcorr_all.permtrace_sd.(cond){e2,e1,si}=xcorr_all.permtrace_sd.(cond){e1,e2,si}(end:-1:1);
                    
                    [~,maxind]=max(C_real);
                    
                    xcorr_all.tlag_max.(cond)(e1,e2,si)=lags(maxind)/fs;
                    xcorr_all.tlag_max.(cond)(e2,e1,si)=-lags(maxind)/fs;
                    
                    max_inds = maxind-half_win:maxind+half_win;
                    max_inds = max_inds(max_inds>0 & max_inds <= length(C_real));
                    realmax = nanmean(C_real(max_inds));
                    permmax = nanmean(C_perm(:,max_inds),2);
                    xcorr_all.zscore.(cond)(e1,e2,si)=(realmax-nanmean(permmax))/nanstd(permmax);
                    xcorr_all.zscore.(cond)(e2,e1,si)=xcorr_all.zscore.(cond)(e1,e2,si);
                    disp(['sbj: ',sbj_name,', e1: ',num2str(e1),', e2: ',num2str(e2),', condition: ',cond,', stim: ', num2str(si)])
                end
            end
        end
    end
end

% xcorr_all.lags = lags/fs;

dir_out = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep];
if ~exist([dir_out,'ROL'])
    mkdir(dir_out,'ROL')
end

save([dir_out,'ROL',filesep,'permuted_xcorr_',sbj_name,'_',freqband,'.mat'],'xcorr_all','xcorr_params')

