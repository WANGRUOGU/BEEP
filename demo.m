%% load data
clear variables
path = './data/'; % Specify the path to the data here
name = {'AF488','AF514','AF532','ATTO542','AF555','RRX','AF594','AF610',...
    'ATTO620','AF633','AF647','ATTO655','AF660'}; % Fluorophore names
laser = {'445', '488', '514', '561', '594', '639'}; % Laser wavelengths
R = length(name);
L = length(laser);
T = 10; % time points
[ref, ref_2L, ref_3L, mix, C, loadTime]...
    = load_BEEP_data(name, laser, path, T);
%% image registration
[ref, mix(1, :), tform{1}, tform_mix{1}]...
    = imregt(ref, mix(1, :), name, laser, 'uni-laser');
[ref_2L, mix(2, 1:3), tform{2}, tform_mix{2}]...
    = imregt(ref_2L, mix(2, :), name, laser, 'bi-laser');
%% background removal
[ref, ref_2L, ref_3L, cleanTime]...
    = RemoveBackground_BEEP(ref, ref_2L, ref_3L, name, C, T);
%% signature extraction
timeFrame = [1, T];
[E, B] = ExtractSignature_BEEP(ref, ref_2L, ref_3L, name, timeFrame, C);
%% max submatrices for unmixing
sz_unmix = 50;
[row, col] = MaxSubimage_BEEP(ref, ref_2L, ref_3L, sz_unmix);
%% reference abundance estimation
[Aref, p]...
    = UnmixRef_BEEP(ref, ref_2L, ref_3L, name, timeFrame, E, B, C, row, col);
%% display estimated abundances of reference images
refAbundances(Aref, name)
%% unmix mixture
A_mix = UnmixMix_BEEP(mix, timeFrame, E, B, C);
%% display estimated abundances of mixture images
mixAbundances(A_mix, name)