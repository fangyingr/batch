
function  LagCorr = computeCrossCorrAll (sbj_name,project_name,block_names,dirs,elecs1,elecs2,pairing,locktype,freq_band,column,conds,crosscorr_params,region_tag)

%% INPUTS
%       sbj_name: subject name
%       project_name: name of task
%       block_names: blocks to be analyed (cell of strings)
%       dirs: directories pointing to files of interest (generated by InitializeDirs)
%       elecs1, elecs2: pairs of electrodes b/w which to compute PLV
%                       (can either be vectors of elec #s or cells of elec names)
%       pairing: 'all' (compute PLV between all sites in elecs1 and all
%                       sites in elecs2) or
%                'one' (compute PLV between corresponding entries in elecs1
%                       and elecs2; elecs1 and elecs2 must be same size)
%
%       locktype: 'stim' or 'resp' (which event epoched data is locked to)
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)



%% load data
nelec1 = length(elecs1);
nelec2 = length(elecs2);
LagCorr=[];
if isempty(crosscorr_params)
    crosscorr_params = genCrossCorrParams(project_name);
end

% load globalVar
load([dirs.data_root,filesep,'originalData',filesep,sbj_name,filesep,'global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])
if iscell(elecs1)
    elecnums1 = ChanNamesToNums(globalVar,elecs1);
    elecnames1 = elecs1;
else
    elecnums1 = elecs1;
    elecnames1 = ChanNumsToNames(globalVar,elecs1);
end
if iscell(elecs2) % if names, convert to numbers
    elecnums2 = ChanNamesToNums(globalVar,elecs2);
    elecnames2 = elecs2;
else
    elecnums2 = elecs2;
    elecnames2 = ChanNumsToNames(globalVar,elecs2);
end

% if pairing all elecs1 to all elecs2, reshape them so one-to-one
if strcmp(pairing,'all')
    elecnums1 = repmat(elecnums1,[nelec2,1]);
    elecnums1 = reshape(elecnums1,[1,nelec1*nelec2]);
    elecnums2 = repmat(elecnums2,[1,nelec1]);
    
    elecnames1 = repmat(elecnames1,[nelec2,1]);
    elecnames1 = reshape(elecnames1,[1,nelec1*nelec2]);
    elecnames2 = repmat(elecnames2,[1,nelec1]);
end

tag = [locktype,'lock'];
if crosscorr_params.blc
    tag = [tag,'_bl_corr'];
end
concatfield = {'wave'}; % concatenate phase across blocks

dir_out = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'allblocks',filesep];

if crosscorr_params.smooth
dir_out_fig= [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'Figures',filesep,'LagCorr',filesep,[freq_band,'_smoothed']];
fn = [dir_out,project_name,'_CrossCorr_',freq_band,'_',region_tag,'_smoothed.mat'];

else
dir_out_fig= [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'Figures',filesep,'LagCorr',filesep,freq_band];
fn = [dir_out,project_name,'_CrossCorr_',freq_band,'_',region_tag,'.mat'];
 
end



if exist(fn,'file')
    load(fn,'CrossCorr')
end

if ~exist(dir_out,'dir')
    mkdir(dir_out)
end

if ~exist(dir_out_fig,'dir')
    mkdir(dir_out_fig)
end


for ei = 1
    data_tmp = concatBlocks(sbj_name,block_names,dirs,elecnums1(ei),freq_band,'Band',concatfield,tag);
    if isempty(conds)
        tmp = find(~cellfun(@isempty,(data_tmp.trialinfo.(column))));
        conds = unique(data_tmp.trialinfo.(column)(tmp));
    end
    [grouped_trials_all,grouped_condnames] = groupConds(conds,data_tmp.trialinfo,column,crosscorr_params.noise_method,crosscorr_params.noise_fields_trials,false);
end

for gi = 1:length(grouped_trials_all)
    numtrials_tot.(grouped_condnames{gi})=length(grouped_trials_all);
end

for ei = 1:length(elecnums1)
    el1 = elecnums1(ei);
    el2 = elecnums2(ei);
    if el1 ~= el2
        % concatenate across blocks
        data_all1 = concatBlocks(sbj_name,block_names,dirs,el1,freq_band,'Band',concatfield,tag);
        data_all2 = concatBlocks(sbj_name,block_names,dirs,el2,freq_band,'Band',concatfield,tag);
        [grouped_trials_all1,~] = groupConds(conds,data_all1.trialinfo,column,crosscorr_params.noise_method,crosscorr_params.noise_fields_trials,false);
        [grouped_trials_all2,~] = groupConds(conds,data_all2.trialinfo,column,crosscorr_params.noise_method,crosscorr_params.noise_fields_trials,false);
        
        data_tmp1 = data_all1;
        data_tmp2 = data_all2;
        for ci = 1:length(grouped_trials_all)
            grouped_trials_tmp = intersect(grouped_trials_all1{ci},grouped_trials_all2{ci});
            data_tmp1.wave = data_all1.wave(grouped_trials_tmp,:);
            data_tmp2.wave = data_all2.wave(grouped_trials_tmp,:);
            if  crosscorr_params.smooth
                winSize = floor(data_all1.fsample*crosscorr_params.sm);
                gusWin= gausswin(winSize)/sum(gausswin(winSize));
                data_tmp1.wave = convn(data_tmp1.wave,gusWin','same');
                data_tmp2.wave = convn(data_tmp2.wave,gusWin','same');
            end
            elec_label=['elec',elecnames1{ei},'_',elecnames2{ei}];
            CrossCorr_tmp =[];
            CrossCorr_tmp = computeCrossCorr(data_tmp1,data_tmp2,conds{ci},elecnames1{ei},elecnames2{ei},crosscorr_params);
            
            LagCorr.(grouped_condnames{ci}).vals.(elec_label)= CrossCorr_tmp.vals;
            LagCorr.(grouped_condnames{ci}).elecslabels{ei,1} = elec_label;
            LagCorr.(grouped_condnames{ci}).lag_peak_max_corr(ei,1)=CrossCorr_tmp.lag_peak_max_corr;
            LagCorr.(grouped_condnames{ci}).lag_peak_min_corr(ei,1)=CrossCorr_tmp.lag_peak_min_corr;
            
            LagCorr.(grouped_condnames{ci}).lag_peak_max_time(ei,1)=CrossCorr_tmp.lag_peak_max_time;
            LagCorr.(grouped_condnames{ci}).lag_peak_min_time(ei,1)=CrossCorr_tmp.lag_peak_min_time;
            
            LagCorr.(grouped_condnames{ci}).numtrials(ei,1)=length(grouped_trials_tmp);
            LagCorr.freqs = CrossCorr_tmp.freqs;
            LagCorr.trialinfo = CrossCorr_tmp.trialinfo;
            LagCorr.time = CrossCorr_tmp.time;
            
            fn_out = sprintf('%s/%s_%s_%s_%slock_%s_%s_lag_corr.png',dir_out_fig,sbj_name,project_name,freq_band,locktype,elecnames1{ei},elecnames2{ei});
            savePNG(gcf, 200, fn_out)
            close
        end
        
        disp(['Computed Cross Correlation between ',elecnames1{ei},' and ',elecnames2{ei}])
    end
    
    
end

save(fn,'LagCorr')

end



