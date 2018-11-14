
subjID = 'S07_YHY';

mri = ft_read_mri('/Users/yingfang/Desktop/ctt1_yhy/YHY_T1.nii.gz');

ft_determine_coordsys(mri)

cfg = [];
cfg.method = 'interactive'; cfg.coordsys = 'acpc';
mri_acpc = ft_volumerealign(cfg, mri);


cfg = [];
cfg.filename = [subjID '_MR_acpc']; cfg.filetype = 'nifti'; cfg.parameter = 'anatomy'; ft_volumewrite(cfg, mri_acpc);

pial_lh = ft_read_headshape('/Users/yingfang/Desktop/ctt1_yhy/lh.pial'); pial_lh.coordsys = 'acpc';
ft_plot_mesh(pial_lh);
lighting gouraud;camlight;
pial_rh = ft_read_headshape('/Users/yingfang/Desktop/ctt1_yhy/rh.pial'); pial_rh.coordsys = 'acpc';
ft_plot_mesh(pial_rh);
lighting gouraud;camlight;


fsmri_acpc = ft_read_mri('/Users/yingfang/Desktop/ctt1_yhy/T1.mgz'); fsmri_acpc.coordsys = 'acpc';

ct = ft_read_mri('/Users/yingfang/Desktop/ctt1_yhy/YHY_CT.nii.gz');

ft_determine_coordsys (ct);

cfg = [];
cfg.method = 'interactive';
cfg.coordsys = 'ctf';
ct_ctf = ft_volumerealign(cfg, ct);

ct_acpc = ft_convert_coordsys(ct_ctf, 'acpc');

cfg = [];
cfg.method = 'spm';
cfg.spmversion = 'spm12';
cfg.coordsys = 'acpc';
cfg.viewresult = 'yes';
ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);

cfg = [];
cfg.filename = [subjID '_CT_acpc_f']; cfg.filetype = 'nifti';
cfg.parameter = 'anatomy'; ft_volumewrite(cfg, ct_acpc_f);


hdr =ft_read_header('/Volumes/Ying_SEEG/CMC/edf/S07_YHY.edf');