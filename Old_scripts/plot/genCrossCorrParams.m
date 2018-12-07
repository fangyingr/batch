function crosscorr_params = genCrossCorrParams(project_name)

switch project_name
    case 'MMR'
        crosscorr_params.t_win = [0 2];
        crosscorr_params.blc = true;
        crosscorr_params.correct_only =false;
    case 'Memoria'
        crosscorr_params.t_win = [0 6];
        crosscorr_params.blc = true;
        crosscorr_params.correct_only =false;
end
crosscorr_params.smooth = true;%false;
crosscorr_params.sm = 0.01;
crosscorr_params.noise_method = 'trials';
crosscorr_params.noise_fields_trials= {'bad_epochs_HFO','bad_epochs_raw_LFspike','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
