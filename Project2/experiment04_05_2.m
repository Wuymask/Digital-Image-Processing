%% fft1D
function X = myfft1D(x)
    N = length(x);
    x = x(:).';

    x = myBitrevorder(x);

    len = 2;
    while len <= N
        half = len / 2;
        W = exp(-1j * 2*pi * (0:half-1) / len);

        for i = 1:len:N
            % 向量化：一次处理 half 个蝶形
            a = x(i : i+half-1);
            b = x(i+half : i+len-1) .* W;
            x(i : i+half-1)     = a + b;
            x(i+half : i+len-1) = a - b;
        end
        len = len * 2;
    end

    X = x;
end

%% fft2D
function F = myFFT2D(f)
% 自动补零到 2 的幂

    [M, N] = size(f);
    f = double(f);

    % 补零到 2 的幂
    M2 = 2^nextpow2(M);
    N2 = 2^nextpow2(N);

    f_padded = zeros(M2, N2);
    f_padded(1:M, 1:N) = f;

    % 第一步：对每一行做一维 FFT（长度 N2）
    F1 = zeros(M2, N2);
    for i = 1:M2
        F1(i, :) = myfft1D(f_padded(i, :).');
    end

    % 第二步：对每一列做一维 FFT（长度 M2）
    F2 = zeros(M2, N2);
    for j = 1:N2
        F2(:, j) = myfft1D(F1(:, j));
    end

    F = F2;
end

%% Mybitrevorder
function y = myBitrevorder(x)
% MYBITREVORDER 手动位反转排序（纯位运算版，更快）
% 要求 length(x) 是 2 的幂

N = length(x);
nbits = log2(N);
y = zeros(size(x));

    for i = 0:N-1
        idx = i;
        rev = 0;

        for b = 1:nbits
            % 取 idx 的最低位，放到 rev 的最低位（相当于逐位反转）
            rev = bitor(bitshift(rev, 1), bitand(idx, 1));
            idx = bitshift(idx, -1);   % idx 右移一位
        end

        y(rev + 1) = x(i + 1);
    end

end

%% 读取图像
figure1 = imread("4.41a.jpg");
figure2 = imread("4.41b.png");

% 若为彩色，转灰度
if size(figure1, 3) == 3
    figure1 = rgb2gray(figure1);
end
if size(figure2, 3) == 3
    figure2 = rgb2gray(figure2);
end

% 转 double
figure1 = im2double(figure1);
figure2 = im2double(figure2);

[M1, N1] = size(figure1);
[M2, N2] = size(figure2);

M = M1 + M2 - 1;
N = N1 + N2 - 1;

%% 创建全零矩阵
figure1_padded = zeros(M, N);
figure2_padded = zeros(M, N);

%% 把原图放到左上角（零延拓）
figure1_padded(1:M1, 1:N1) = figure1;
figure2_padded(1:M2, 1:N2) = figure2;

%% 傅里叶变换
%F = fft2(figure1_padded);
%Template_conj = conj(fft2(figure2_padded));

F = myFFT2D(figure1_padded);
Template_conj = conj(myFFT2D(figure2_padded));

%% 相关性计算
G = real(ifft2(F.* Template_conj));   % 点乘后反变换，取实部


%% 峰值查找
[max_val, max_idx] = max(G(:));
[ypeak, xpeak] = ind2sub(size(G), max_idx);

fprintf("xpeak = %d, ypeak = %d\n", xpeak, ypeak);

%% 查看图片
figure;
imshow(figure1);

figure;
imshow(figure2);

figure;
imshow(G, []);