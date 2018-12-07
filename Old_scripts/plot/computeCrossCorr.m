function CrossCorr = computeCrossCorr(data1,data2,cond,elecnames1,elecnames2,CrossCorr_params)
%% INPUTS:
%       data1, data2: data structures containting 'wave','freqs','time',etc.
%
%       CrossCorr_params: (see genCrossCorrParams.m)
%% OUTPUT
%   CrossCorr

time_inds = find(data1.time >=CrossCorr_params.t_win(1) & data1.time <=CrossCorr_params.t_win(2));
CrossCorr.freqs = data1.freqs;
CrossCorr.time  = data1.time(time_inds);
CrossCorr.trialinfo = data1.trialinfo;
%% extract time point

wave1=[]; wave2=[];
wave1=data1.wave(:,time_inds);
wave2=data2.wave(:,time_inds);

%% trial-level lag correlations

for i=1:size(data1.wave,1)
    [lag_corr(i,:),lag_times(i,:)] = crosscorr(wave1(i,:),wave2(i,:),length(time_inds)-1);
end

lag_times=lag_times(1,:)/data1.fsample;

[~,max_indx] = max(lag_corr,[],2);
max_lag_corr_allTrials=lag_times(max_indx);

[~,min_indx] = min(lag_corr,[],2);
min_lag_corr_allTrials=lag_times(min_indx);


%% mean across trials
lag_corr_mean=nanmean(lag_corr,1);
lag_corr_SE=nanstd(lag_corr)/(sqrt(size(lag_corr,1)));

% time to peak
[lag_peak_max_corr,peak_max_ind]=max(lag_corr_mean);
[lag_peak_min_corr,peak_min_ind]=min(lag_corr_mean);
lag_peak_max_time=lag_times(peak_max_ind);
lag_peak_min_time=lag_times(peak_min_ind);

CrossCorr.vals=lag_corr;
CrossCorr.lag_time=lag_times;
CrossCorr.max_lag_corr_allTrials=max_lag_corr_allTrials;
CrossCorr.min_lag_corr_allTrials=min_lag_corr_allTrials;
CrossCorr.lag_peak_max_corr=lag_peak_max_corr;
CrossCorr.lag_peak_min_corr=lag_peak_min_corr;

CrossCorr.lag_peak_max_time=lag_peak_max_time;
CrossCorr.lag_peak_min_time=lag_peak_min_time;


%% plot
lineprops.style= '-';
lineprops.width = 2;
lineprops.edgestyle = '-';

figureDim = [0 0 .3 .4];
figure('units', 'normalized', 'outerposition', figureDim)
set(gcf,'color','white')
%mseb(lag_times,lag_corr_mean,lag_corr_SE,lineprops,1);
%hold on
plot(lag_times,lag_corr_mean,'LineWidth',4,'Color',([31,120,180])/255);

hold on
plot(lag_peak_max_time,lag_peak_max_corr,'*','LineWidth',8,'Color',([255,127,0])/255)
hold on
%h=plot(lag_times,lag_corr_mean,'LineWidth',2,'Color','b');

xlabel('Lag (sec)'); ylabel('Correlation');
set(gca,'Fontsize',20,'Fontweight','bold','LineWidth',2,'TickDir','out','box','off');
line([lag_times(1) lag_times(end)],[0 0],'LineWidth',1,'Color','k');
y_lim=ylim;
line([0 0],y_lim,'LineWidth',1,'Color',[0.5,0.5,0.5],'LineStyle','--');

title('PMC vs mPFC Lag Correlations')

title({[cond,': ' elecnames1 ' vs ' elecnames2 ' lag correlations']; ...
    ['Max Peak = ' num2str(lag_peak_max_time)]},'Fontsize',16);

 %set(gca,'fontsize',14);



%%
















