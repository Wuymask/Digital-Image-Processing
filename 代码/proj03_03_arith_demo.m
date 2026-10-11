%% ============================================================
%  Project 03-03  算术运算演示（调用 imarith.m）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig0222(a)(face).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end
fneg = 255 - f;                       % 负片（第二幅同尺寸图像）

figure('Name','P03-03');
subplot(2,3,1); imshow(f);          title('图像 f');
subplot(2,3,2); imshow(fneg);       title('图像 h（负片）');
subplot(2,3,3); imshow(imarith(f,'+',fneg)); title('f + h');
subplot(2,3,4); imshow(imarith(f,'-',fneg)); title('f - h');
subplot(2,3,5); imshow(imarith(f,'*',1.5));  title('f * 1.5（乘常数）');
subplot(2,3,6); imshow(imarith(f,'/',2));    title('f / 2（除常数）');
% [截图 1] 整幅演示图
% 报告说明：加法平均可去噪、减法可检测变化、乘除用于校正/掩蔽，
% 本演示验证四种运算及结果缩放策略（mat2gray）。
