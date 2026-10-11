function g = imarith(f, op, h)
% ============================================================
%  Project 03-03  两幅图像（或图像与常数）的算术运算  [后续实验复用]
%  g = imarith(f, op, h)
%     op: '+' '-' '*' '/'
%     h : 第二幅图像，或常数（乘/除常数时 h 为标量）
%  结果按教材 p.112 的说明缩放到 [0,255]
% ============================================================
f = im2double(f);
if isscalar(h)
    q = h;
else
    q = im2double(h);
    if ~isequal(size(f), size(q))
        error('两幅图像尺寸必须相同（%dx%d 与 %dx%d）', ...
              size(f,1), size(f,2), size(q,1), size(q,2));
    end
end

switch op
    case '+'                                     % 加法
        r = f + q;
    case '-'                                     % 减法
        r = f - q;
    case '*'                                     % 乘法（含乘常数）
        r = f .* q;
    case '/'                                     % 除法（含除常数）
        q(q == 0) = eps;
        r = f ./ q;
    otherwise
        error('未知运算符: %s', op);
end

g = uint8(255 * mat2gray(r));    % 线性缩放到 [0,255]
end
