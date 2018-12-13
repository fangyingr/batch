

global globalFsDir;
globalFsDir='/Applications/freesurfer/subjects/';

load('/Users/yingfang/Documents/GitHub/lbcn_preproc/vizualization/colormaps/cdcol_2018.mat');
groupAvgCoords=[];
groupLabels=[];
groupIsLeft=[];


subs={'S12_33_DA','S12_38_LK','S12_42_NC','S17_118_TW','S17_119_AG'};%
regions = {'PMC';'mPFC';'Hippocampus'};
for ri=1:length(regions)
    for si=1:length(subs)
        sbj_name=subs{si};
        fprintf('Working on Participant %s\n',subs{si});
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        
        
         [DOCID,GID] = getGoogleSheetInfo('chan_names_ppt', 'chan_names_fs_figures');
    
        googleSheet = GetGoogleSpreadsheet(DOCID, GID);
       
        result = GetGoogleSpreadsheet(DOCID) 
        
        if ~isempty(elecs)
            cfg=[];
            %cfg.rmDepths=1;
            [avgCoords, elecNames, isLeft]=sub2AvgBrain(sbj_name,cfg);
            
            https://docs.google.com/spreadsheets/d/1RSgUAGnngW-GLqtSkse05lZ3JGzJ6iImAQeeUrZzqwE/edit?usp=sharing
            
            groupAvgCoords=[groupAvgCoords; avgCoords];
            groupLabels=[groupLabels; elecNames];
            groupIsLeft=[groupIsLeft; isLeft];
        else
            disp('No electrodes in this regions')
        end
    end
end

close all;

parc_col = repmat(0.8*[255,255,255],8,1);
% Color parcel of interest
parc_col(8,:)=(cdcol.periwinkle_blue)*255;

cfg=[];
cfg.view='omni';
cfg.elecCoord=[groupAvgCoords groupIsLeft];
cfg.elecNames=groupLabels;
cfg.opaqueness=1;
cfg.elecSize=1;
cfg.elecShape= 'sphere';
cfg.showLabels='n';
cfg.overlayParcellation='Y7';
cfg.parcellationColors = parc_col;
cfg.title=[];
cfgOut=plotPialSurf('fsaverage',cfg);

saveas(gcf,'/Users/yingfang/Desktop/brains/group_electrodes_all_omni.jpg');



