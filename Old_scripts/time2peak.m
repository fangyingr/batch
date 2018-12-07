function peaktime=time2peak(sbj_name,project_name,block_names,dirs,elecs,freq_band,locktype,column,conds,noise_method,plot_params,datatype)


%% Load data
load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])

dir_in = [dirs.data_root,'/',datatype,'Data/',freqs_name,'Data/',sbj_name,'/',block_names{1},'/EpochData/'];
load(sprintf('%s/%siEEG_stimlock_bl_corr_%s_%.2d.mat',dir_in,freqs_name,block_names{1},elecs(1)));
% ntrials = size(data.trialinfo,1);
nstim = size(data.trialinfo.allonsets,2); % (max) number of stim per trial 

    

%% calculate peak time

     movmean()
     



%% Save data

















end