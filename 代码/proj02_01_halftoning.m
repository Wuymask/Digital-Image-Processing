%% ============================================================
%  Project 02-01  基于半色调(Halftoning)的图像打印程序
%  使用前：MATLAB 当前目录 = 实验根目录（数字图像处理实验），
%          并已执行  addpath('代码')
%% ============================================================
clear; close all; clc;

%% (b) 生成 256x256 灰度楔形测试图（第1列全0，…，最后一列全255）
wedge = repmat(uint8(0:255), 256, 1);
figure('Name','P02-01 楔形原图'); imshow(wedge);
title('256\times256 灰度楔形测试图');
% [截图 1] 楔形原图

%% 用半色调程序"打印"楔形图
halftone_print(wedge, 'P02-01_wedge_halftone.png');
% [截图 2] 楔形图的半色调结果

%% (c) 打印 Fig 2.22(a)(b)(c)
imgs = {'Fig0222(a)(face).jpg', 'Fig0222(b)(cameraman).jpg', 'Fig0222(c)(crowd).jpg'};
for k = 1:3
    f = imread(fullfile('实验图片', imgs{k}));
    if size(f,3) == 3, f = rgb2gray(f); end
    halftone_print(f, sprintf('P02-01_fig22_%c_halftone.png', 'a'+k-1));
    % [截图 3~5] 三幅图像的半色调结果
end

%% ------------------ 局部函数 ------------------
function halftone_print(f, outname)
% 半色调打印：每个输入像素 -> 3x3 黑白点阵，共 10 个灰度级(0~9)
% (1) 尺寸缩放：3 倍放大后不得超过 8.5x11 英寸纸面
%     按 100dpi、四周各留 0.75 英寸边距 => 可打印区约 700x950 像素
%     => 输入图像最大约 233 列 x 316 行
maxRows = floor(950/3);  maxCols = floor(700/3);
if size(f,1) > maxRows || size(f,2) > maxCols
    sc = min([maxRows, maxCols] ./ [size(f,1), size(f,2)]);
    f = imresize(f, round(sc*[size(f,1), size(f,2)]), 'nearest');
end
% (2) 灰度级缩放：把 0~255 线性映射到 0~9（10 级）
g = floor(im2double(f) * 9.999);        % 0..9
% (3) 10 种 3x3 点阵图案（true=白点，false=黑点），白点由中心向外生长
%     注意：请与教材 Project 02-01 插图中点的生长顺序核对，
%     如有出入只需修改 order 数组（不影响算法正确性）
order = [5 4 8 6 2 1 3 7 9];  % 中心->上->右->下->左->四角
P = false(3,3,10);
for k = 0:9
    p = false(3,3);  p(order(1:k)) = true;  P(:,:,k+1) = p;
end
% (4) 组装输出：空间分辨率降为 1/3，灰度由点阵近似
[M,N] = size(g);
out = false(3*M, 3*N);
for i = 1:M
    for j = 1:N
        out(3*i-2:3*i, 3*j-2:3*j) = P(:,:,g(i,j)+1);
    end
end
figure('Name','Halftone');
imshow(out, 'InitialMagnification', 100);
title('半色调打印结果');
print(gcf, '-dpng', '-r100', outname);
fprintf('已保存 %s （输出尺寸 %dx%d，输入 %dx%d）\n', ...
        outname, size(out,1), size(out,2), M, N);
end
