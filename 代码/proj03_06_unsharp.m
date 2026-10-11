%% ============================================================
%  Project 03-06  反锐化掩模与高提升滤波（Fig 3.43(a)）
%  复用 spfilt.m（03-04）与 imarith.m（03-03）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig3.43(a).jpg'));
f = im2double(f);

%% (a) 高提升滤波：Eq.(3.7-8)   g = A*f - (f - f_bar)
% 平均（模糊）部分用 Fig 3.34(a) 的 3x3 均值掩模
avg  = ones(3)/9;
fbar = spfilt(f, avg);            % 模糊图像 f_bar
unsharp = f - fbar;               % 反锐化掩模（模版）

%% (b) 调整 A，使结果尽量接近教材 Fig 3.43(d)
Alist = [1.5 2 2.5 3];            % A=1 即经典反锐化掩模
figure('Name','P03-06');
subplot(2,3,1); imshow(f, []);    title('原图 Fig 3.43(a)');
subplot(2,3,2); imshow(fbar);     title('模糊图 \bar{f}（3\times3均值）');
subplot(2,3,3); imshow(unsharp, []); title('模版 f-\bar{f}');
for k = 1:numel(Alist)
    A = Alist(k);
    g = A*f - unsharp;            % Eq.(3.7-8)：g = A*f - (f - \bar{f})
    subplot(2,3,k+3); imshow(g, []);
    title(sprintf('A = %.1f', A));
end
% [截图 1] 整幅 2x3 图（选出最接近 Fig 3.43(d) 的 A）

%% 用选定的 A 出最终图（示例 A=2.5，按你上面的比较结果修改）
A = 2.5;
g = A*f - unsharp;
figure; imshow(g, []); title(sprintf('最终结果：高提升滤波 A=%.1f', A));
% [截图 2] 最终选定 A 的结果大图（报告"结果讨论"引用）
