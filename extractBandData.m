function extractBandData(sbj_name,project_name,bn,dirs,el,freq_name,locktype,datatype)

bl_tag='bl_corr_';

if strcmp(freq_name, 'HFB')
    freq_band=[70 180];
elseif strcmp (freq_name, 'Theta')
    freq_band=[4 7];
end
% load data
dir_in = [dirs.data_root,'/','SpecData/',datatype,'Data/',sbj_name,'/',bn, '/EpochData'];
dir_out = [dirs.data_root,'/','BandData/',freq_name,'Data/',sbj_name,'/',bn, '/EpochData'];
if ~exist(dir_out)
    mkdir(dir_out)
end
fn_in = sprintf('%s/%siEEG_%slock_%s%s_%.2d.mat',dir_in,datatype,locktype,bl_tag,bn,el);
fn_out = sprintf('%s/%siEEG_%slock_%s%s_%.2d.mat',dir_out,freq_name,locktype,bl_tag,bn,el);
clear data;
load(fn_in)
% average data


data_new = [];
freq_indx = find(data.freqs>=freq_band(1) & data.freqs <= freq_band(2));
data_new.wave = squeeze(nanmean(data.wave(freq_indx,:,:)));

data_new.freqs = data.freqs(freq_indx);
data_new.wavelet_span= data.wavelet_span;
data_new.time = data.time;
data_new.fsample= data.fsample;
data_new.label = data.label;
data_new.trialinfo = data.trialinfo;
data_new.band = freq_name;

data=[];
data=data_new;


% save data
save(fn_out,'data')
disp(['Extrace:',freq_name,'Band_Block ', bn, ' ' bl_tag,' Elec ',num2str(el)])

end
