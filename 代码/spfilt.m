function g = spfilt(f, mask)
% ============================================================
%  Project 03-04  3x3 空间滤波（通用程序）  [后续实验复用]
%  g = spfilt(f, mask)
%     f    : 输入图像
%     mask : 3x3 系数矩阵（系数为变量，可任意指定）
%  实现：空间相关（滤波），边界用复制方式填充
% ============================================================
f = im2double(f);
[mask_valid, ~] = size(mask);
if ~isequal(size(mask), [3 3])
    error('掩模必须是 3x3（当前 %dx%d）', mask_valid, size(mask,2));
end

[m, n] = size(f);
fp = padarray(f, [1 1], 'replicate');   % 边界复制填充
g  = zeros(m, n);
for i = 1:m
    for j = 1:n
        g(i,j) = sum(sum(fp(i:i+2, j:j+2) .* mask));
    end
end
end
