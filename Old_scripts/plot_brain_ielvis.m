clc;clear;startup;
global FsDir;
FsDir = '/Applications/freesurfer/subjects/'

subjects={'S18_119_AG'};%'S12_33_DA';'S12_38_LK';'S12_42_NC';'S17_118_TW';,S13_60_DY,'S14_80b_KBb','S15_87_RL'};'S13_60_DY'%'S13_59_SRR','S13_47_JT2','S14_80b_KBb'
%'S17_118_TW','S17_116_AA','S17_115_MP','S17_114_EB','S15_89_JQ','S15_90_SO','S16_93_MA','S16_94_DR','S16_96_LF','S17_104_SW','S17_108_AH','S17_113_CAM',
savepath='/Users/yingfang/Documents/data/Results/MMR/Group/Brains/';
 load('cdcol.mat')
for subi=1:numel(subjects)
    
    cfg=[];parcOut=[];
    
    fsSub=subjects{subi};
    
    % Network you want to plot
    id = 8;
    % Make verteces gray
    
    parc_col = repmat(0.9*[255,255,255],8,1);%.8.*255.*ones(size(col.table(:,1:3)));
    % Color parcel of interest
    parc_col(id,:)=(cdcol.sky_blue)*255;%(cdcol.grey_blue)*255;

   
    
    cfg=[];
    cfg.view='lm';%'omni';%'l';%
    cfg.overlayParcellation='Y7';
    cfg.title= [];%subjects{subi};
    cfg.showLabels='n';
    cfg.ignoreDepthElec='n';
    cfg.elecSize=1.2;
    cfg.elecShape= 'sphere';
    cfg.parcellationColors = parc_col;
    cfgOut=plotPialSurf(fsSub,cfg);
    parcOut=elec2Parc(fsSub,'Y7');   
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
    cfgOut=plotPialSurf(fsSub,cfg);
    parcOut=elec2Parc(fsSub,'Y7');   
    set(gcf,'color','w')
   
   % save([savepath,'/',subjects{subi},'_electrode_labels_Y7.mat'],'electrodes','parcOut');  
    saveas(gcf,[savepath,subjects{subi},'_electrodes_rm.jpg']);
    close;
    
        cfg=[];
    cfg.view='omni';%'omni';%'l';%
    cfg.overlayParcellation='Y7';
    cfg.title= [];%subjects{subi};
    cfg.showLabels='n';
    cfg.ignoreDepthElec='n';
    cfg.elecSize=1.2;
    cfg.elecShape= 'sphere';
    cfg.parcellationColors = parc_col;
    cfgOut=plotPialSurf(fsSub,cfg);
    parcOut=elec2Parc(fsSub,'Y7');   
    set(gcf,'color','w')
   
   % save([savepath,'/',subjects{subi},'_electrode_labels_Y7.mat'],'electrodes','parcOut');  
    saveas(gcf,[savepath,subjects{subi},'_electrodes_all.jpg']);
    close;
end

