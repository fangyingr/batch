

global globalFsDir;
globalFsDir='/Applications/freesurfer/subjects/';

%load('/Users/yingfang/Documents/GitHub/lbcn_preproc/vizualization/colormaps/cdcol_2018.mat');
groupAvgCoords=[];
groupLabels=[];
groupIsLeft=[];


subs={'S18_128_CG';'S12_33_DA';'S12_38_LK';'S12_42_NC';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_118_TW';'S18_119_AG';'S18_124_JR2';};%
regions = {'PMC';'mPFC';'Hippocampus'};

for ri=1:length(regions)
    groupAvgCoords.(regions{ri})=[]
    for si=1:length(subs)
        sbj_name=subs{si};
        fprintf('Working on Participant %s\n',subs{si});
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_amy_corrected(sbj_name,regions{ri});
        
        if ~isempty(elecs)
            load (['/Volumes/Ying_SEEG/Data_lbcn/neuralData/originalData',filesep,sbj_name,filesep,'subjVar_',sbj_name])
            avgCoords=[];
            avgCoords=subjVar.MNI_coord(elecs,:);
            
            groupAvgCoords.(regions{ri})=[groupAvgCoords.(regions{ri}); avgCoords];
            % groupLabels=[groupLabels; elecNames];
            % groupIsLeft=[groupIsLeft; isLeft];
        else
            disp('No electrodes in this regions')
        end
    end
end


server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/Ying_SEEG/Data_lbcn';
code_root = '/Users/yingfang/Documents/lbcn_preproc';

%cortex

load([code_root filesep 'vizualization',filesep,'Colin_cortex_left.mat']);
cmcortex.left = cortex;
load([code_root filesep 'vizualization',filesep,'Colin_cortex_left.mat']);
cmcortex.right = cortex;

col_idx = reshape(col_idx,size(data_all.wave.(cond),1), size(data_all.wave.(cond),2));
MarkSizeEffect = 35;
if center_zero
    sizes = (abs(col_idx-50)+1)*MarkSizeEffect/100;
else
    sizes = col_idx*MarkSizeEffect/100;
end


figure('Position',[200 200 1000 500])
subplot(1,2,1)
ctmr_gauss_plot(cmcortex.left,[0 0 0], 0, 'l', 2)
alpha(0.7)

hold on
subplot(1,22)
ctmr_gauss_plot(cmcortex.right,[0 0 0], 0, 'r', 2)
alpha(0.7)
% Sort to highlight larger channels


cols=[255,0,0;
    0,255,0;
    0,0,255]./255;
hold on

for ri=1:length(regions)
    for i = 1:size(groupAvgCoords.(regions{ri}),1)
        col=cols(ri,:);
        f = plot3(groupAvgCoords.(regions{ri})(i,1),groupAvgCoords.(regions{ri})(i,2),groupAvgCoords.(regions{ri})(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', col, 'MarkerSize', 6);
    end
end
% electrode color
[col_idx,cols] = colorbarFromValues(data_all.wave.(cond)(:), colmap,clim,center_zero); % range = 1-100;

