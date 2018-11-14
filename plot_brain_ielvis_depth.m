clc;clear;
global globalFsDir;
globalFsDir = '/Applications/freesurfer/subjects/'

subjects={'S18_130_RH_B'}%'S17_119_AG';'S17_118_TW'};%,'S12_33_DA';'S12_38_LK';'S12_42_NC';
savepath='/Users/yingfang/Documents/data/Results/MMR/Group/Brains/';
load('cdcol.mat')
for subi=1:numel(subjects)
    
    cfg=[];parcOut=[];
    
    fsub=subjects{subi};
    
    [averts(:,1), label(:,1), col]=read_annotation(fullfile(getFsurfSubDir(),'fsaverage','label','lh.Yeo2011_7Networks_N1000.annot'));
    [averts(:,2), label(:,2), col_r]=read_annotation(fullfile(getFsurfSubDir(),'fsaverage','label','rh.Yeo2011_7Networks_N1000.annot'));
   
    
    % Network you want to plot
    id = 8;
    % Make verteces gray
    
    parc_col = repmat(0.9*[255,255,255],8,1);%.8.*255.*ones(size(col.table(:,1:3)));
    % Color parcel of interest
    parc_col(id,:)=(cdcol.sky_blue)*255;%(cdcol.grey_blue)*255;
    
    
    
    [~, elecLabels, elecRgb, elecPairs, elecPresent]=mgrid2matlab(fsub);
    nElec=length(elecLabels);
    
    elecLabel=erase(elecLabels,'LD_');
    elecLabel=erase(elecLabels,'RD_');
    ecolor=repmat([0 0 0],nElec,1);
    
    
    cfg=[];
    cfg.view=['r','omni'];
    %cfg.figId=fLoop+(hemLoop-1)*10;
    cfg.elecSize=1.2;
    cfg.elecShape= 'sphere';
    cfg.elecColors=ecolor;
    cfg.elecNames=elecLabel;
    cfg.elecCbar='n';
    cfg.ignoreDepthElec='n';
    cfg.title=fsub;
    cfg.opaqueness=0.5;
    %cfg.title=[];
    %   cfg.pairs=elecPairs;
    %cfg.pairs=elecPairs(useIds,:);
    
    cfg.overlayParcellation='Y7';
    cfg.parcellationColors = parc_col;
    %cfg.rotate3d='n';
    cfgOut=plotPialSurf(fsub,cfg);
     saveas(gcf,[savepath,subjects{subi},'_electrodes_omni.jpg']);
    
    
    
    
    
    cfg=[];
    cfg.view='omni';%'omni';%'l';%
    cfg.opaqueness=0.6;
    cfg.overlayParcellation='Y7';
    cfg.title= [];%subjects{subi};
    cfg.showLabels='n';
    cfg.ignoreDepthElec='n';
    cfg.elecSize=1.2;
    cfg.elecShape= 'sphere';
    cfg.parcellationColors = parc_col;
    plotPialSurf(fsub,cfg);
    
    set(gcf,'color','w')
    
    save([savepath,'/',subjects{subi},'_electrode_labels_Y7.mat'],'parcOut');
    saveas(gcf,[savepath,subjects{subi},'_electrodes_lm.jpg']);
    
    close;
    
    cfg=[];
    cfg.view='rm';%'omni';%'l';%
    cfg.overlayParcellation='Y7';
    cfg.title= [];%subjects{subi};
    cfg.showLabels='n';
    cfg.ignoreDepthElec='n';
    cfg.elecSize=1.2;
    cfg.elecShape= 'sphere';
    cfg.parcellationColors = parc_col;
    cfgOut=plotPialSurf(fsub,cfg);
    parcOut=elec2Parc(fsub,'Y7');
    set(gcf,'color','w')
    
    % save([savepath,'/',subjects{subi},'_electrode_labels_Y7.mat'],'electrodes','parcOut');
    saveas(gcf,[savepath,subjects{subi},'_electrodes_rm.jpg']);
    close;
    
    cfg=[];
    cfg.view='omni';%'omni';%'l';%
    cfg.opaqueness=0.6;
    % cfg.overlayParcellation='Y7';
    cfg.title= [];%subjects{subi};
    cfg.showLabels='n';
    cfg.ignoreDepthElec='n';
    cfg.elecSize=1.2;
    cfg.elecShape= 'sphere';
    %cfg.parcellationColors = parc_col;
    plotPialSurf(fsub,cfg);
    parcOut=elec2Parc(fsub,'Y7');
    set(gcf,'color','w')
    
    % save([savepath,'/',subjects{subi},'_electrode_labels_Y7.mat'],'electrodes','parcOut');
    saveas(gcf,[savepath,subjects{subi},'_electrodes_all.jpg']);
    close;
end

