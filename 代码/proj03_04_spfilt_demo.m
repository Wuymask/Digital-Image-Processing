%% ============================================================
%  Project 03-04  空间滤波演示（调用 spfilt.m）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig0222(b)(cameraman).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end

%% 三个典型 3x3 掩模（系数即变量输入）
m_avg = ones(3)/9;                                  % 平滑（均值）
m_lap4 = [0 -1  0; -1  4 -1;  0 -1  0];             % 拉普拉斯(4邻域)
m_shp = [0 -1  0; -1  5 -1;  0 -1  0];              % 锐化（拉普拉斯增强）

figure('Name','P03-04');
subplot(2,2,1); imshow(f);                    title('原图');
subplot(2,2,2); imshow(spfilt(f, m_avg));     title('3\times3 均值滤波（平滑）');
subplot(2,2,3); imshow(spfilt(f, m_lap4), []); title('拉普拉斯滤波（[]缩放显示）');
subplot(2,2,4); imshow(spfilt(f, m_shp));     title('锐化掩模');
% [截图 1] 整幅演示图（证明掩模系数作为变量可任意输入）

%% 与工具箱 imfilter 对比验证（可选）
gref = imfilter(im2double(f), m_avg, 'replicate');
fprintf('均值滤波与 imfilter 最大误差 = %.2e\n', max(abs(spfilt(f,m_avg(:,:))-gref(:)),[],'all'));
% [截图 2]（可选）命令窗口误差输出，验证正确性
