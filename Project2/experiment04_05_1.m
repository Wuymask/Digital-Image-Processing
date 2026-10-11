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
F = fft2(figure1_padded);
Template_conj = conj(fft2(figure2_padded));

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