%% ============================================================
%  Project 03-02  直方图均衡化  [后续实验复用]
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig0308(a)(fractured_spine).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end

%% (a) 计算直方图
h  = my_hist(f);
%% (b) 直方图均衡化
g  = my_histeq(f);
hg = my_hist(g);
%% 均衡化变换函数 s(r)
cdf = cumsum(h) / numel(f);
sfn = round(cdf * 255);

figure('Name','P03-02');
subplot(2,3,1); imshow(f);  title('原图');
subplot(2,3,2); bar(0:255, h);  axis tight;
title('原图直方图'); xlabel('灰度级'); ylabel('像素数');
subplot(2,3,3); plot(0:255, sfn, 'LineWidth', 1.5); grid on;
title('均衡化变换函数 s(r)'); xlabel('r'); ylabel('s');
axis([0 255 0 255]);
subplot(2,3,4); imshow(g);  title('均衡化结果');
subplot(2,3,5); bar(0:255, hg); axis tight;
title('均衡化后直方图'); xlabel('灰度级'); ylabel('像素数');
% [截图 1] 整幅 2x3 图（原图、直方图、变换函数、结果图、结果直方图，
%          报告要求的 5 幅图一次截全）

%% 与 MATLAB 自带 histeq 对比验证（可选）
gref = histeq(f, 256);
figure; imshowpair(g, gref, 'montage'); title('自写程序 | MATLAB histeq');
% [截图 2]（可选）与工具箱结果对比，作为正确性验证

%% ------------------ 局部函数 ------------------
function h = my_hist(f)
% 256 级灰度直方图：h(k+1) = 灰度值 k 的像素个数
h = histcounts(double(f), 0:256);
end

function g = my_histeq(f)
% 直方图均衡化（教材 3.3.1）：
% sk = (L-1)*sum_{j=0..k} pr(j)，再四舍五入取整
h   = my_hist(f);
cdf = cumsum(h) / numel(f);
s   = round(cdf * 255);
g   = uint8(s(double(f) + 1));    % 灰度 r -> s(r) 映射
end
