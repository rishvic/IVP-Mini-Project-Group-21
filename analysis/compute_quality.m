opts = detectImportOptions("./sep_testlist.txt",ReadVariableNames=false,...
                           Delimiter=("/"));
opts = setvartype(opts,"char");
sep_tbl = readtable("./sep_testlist.txt", opts);

file_gen = @(dir) @(a,b) fullfile(".",dir,a,b,"im4.png");

input_frames = rowfun(file_gen("input"),sep_tbl).Var1;
out_frames = rowfun(file_gen("out1"),sep_tbl).Var1;
target_frames = rowfun(file_gen("target"),sep_tbl).Var1;

frame_table = table(input_frames,out_frames,target_frames,...
                    'VariableNames',["Input","Output","Target"]);
%%

rows = size(frame_table,1);
degResults = zeros(rows,2,4);
for idx = 1:rows
    degResults(idx,:,:) = computeDeg(frame_table{idx,:});
    if mod(idx,100) == 0
        fprintf("[%s] Processed %u rows.\n", string(datetime), idx);
    end
end

%%

in_mse = degResults(:,1,1);
in_ssim = degResults(:,1,2);
in_psnr = degResults(:,1,3);
in_snr = degResults(:,1,4);

out_mse = degResults(:,2,1);
out_ssim = degResults(:,2,2);
out_psnr = degResults(:,2,3);
out_snr = degResults(:,2,4);

%%

% SNR Histogram
binRange = 16:0.3:37;

hcx = histcounts(in_snr,[binRange Inf]);
hcy = histcounts(out_snr,[binRange Inf]);

figure;
bar(binRange,[hcx;hcy]);
title("Comparitive histogram of simple SNR");
xlabel("SNR (dB) -- Higher is Better");
ylabel("Frequency");
legend('Bicubic','BasicVSR');

fprintf("Mean SNR:\nIn = %g, Out = %g\n", mean(in_snr), mean(out_snr));
fprintf("Median SNR:\nIn = %g, Out = %g\n", median(in_snr), median(out_snr));

%%

% PSNR Histogram
binRange = 16:0.3:37;

hcx = histcounts(in_psnr,[binRange Inf]);
hcy = histcounts(out_psnr,[binRange Inf]);

figure;
bar(binRange,[hcx;hcy]);
title("Comparitive histogram of PSNR");
xlabel("PSNR (dB) -- Higher is Better");
ylabel("Frequency");
legend('Bicubic','BasicVSR');

fprintf("Mean PSNR:\nIn = %g, Out = %g\n", mean(in_psnr), mean(out_psnr));
fprintf("Median PSNR:\nIn = %g, Out = %g\n", median(in_psnr), median(out_psnr));

%%

% MSE Histogram
binRange = 0:5:250;

hcx = histcounts(in_mse,[binRange Inf]);
hcy = histcounts(out_mse,[binRange Inf]);

figure;
bar(binRange,[hcx;hcy]);
title("Comparitive histogram of MSE");
xlabel("MSE -- Lower is Better");
ylabel("Frequency");
legend('Bicubic','BasicVSR');

fprintf("Mean MSE:\nIn = %g, Out = %g\n", mean(in_mse), mean(out_mse));
fprintf("Median SE:\nIn = %g, Out = %g\n", median(in_mse), median(out_mse));

%%

% SSIM Histogram
binRange = 0:0.01:1;

hcx = histcounts(in_ssim,[binRange Inf]);
hcy = histcounts(out_ssim,[binRange Inf]);

figure;
bar(binRange,[hcx;hcy]);
title("Comparitive histogram of SSIM");
xlabel("SSIM -- Higher is better");
ylabel("Frequency");
legend('Bicubic','BasicVSR');

fprintf("Mean SSIM:\nIn = %g, Out = %g\n", mean(in_ssim), mean(out_ssim));
fprintf("Median SSIM:\nIn = %g, Out = %g\n", median(in_ssim), median(out_ssim));

%%

function info = computeDeg(files)
    in_img = rgb2ycbcr(imread(files(1)));
    in_luma = in_img(:,:,1);

    out_img = rgb2ycbcr(imread(files(2)));
    out_luma = out_img(:,:,1);

    tgt_img = rgb2ycbcr(imread(files(3)));
    tgt_luma = tgt_img(:,:,1);

    in_mse = immse(in_luma,tgt_luma);
    in_ssim = ssim(in_luma,tgt_luma);
    [in_psnr, in_snr] = psnr(in_luma,tgt_luma);

    out_mse = immse(out_luma,tgt_luma);
    out_ssim = ssim(out_luma,tgt_luma);
    [out_psnr, out_snr] = psnr(out_luma,tgt_luma);

    in_info = [in_mse in_ssim mag2db(in_psnr) mag2db(in_snr)];
    out_info = [out_mse out_ssim mag2db(out_psnr) mag2db(out_snr)];

    info = [in_info; out_info];
end

