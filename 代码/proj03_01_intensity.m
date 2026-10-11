%% ============================================================
%  Project 03-01  灰度变换增强（Fig 3.8(a) fractured_spine 骨折脊椎）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig0308(a)(fractured_spine).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end
r = im2double(f);

%% (a) 对数变换  s = c*log(1+r)
c = 1;
s_log = c * log(1 + r);

%% (b) 幂律(伽马)变换  s = c*r^gamma
gammas = [0.2 0.4 0.6 0.8];      % gamma<1 增强暗部
cg = 1;

figure('Name','P03-01 结果图');
subplot(2,3,1); imshow(r,[]);      title('原图');
subplot(2,3,2); imshow(s_log,[]);  title(sprintf('对数变换 c=%.1f', c));
for k = 1:numel(gammas)
    s = cg * r.^gammas(k);
    subplot(2,3,k+2); imshow(s,[]);
    title(sprintf('\\gamma=%.1f', gammas(k)));
end
% [截图 1] 整幅结果拼图（选出你认为视觉效果最好的一组参数）

figure('Name','P03-01 变换函数曲线');
rr = linspace(0,1,256)';
plot(rr, c*log(1+rr), 'LineWidth', 1.5); hold on;
for k = 1:numel(gammas)
    plot(rr, cg*rr.^gammas(k), 'LineWidth', 1.2);
end
plot(rr, rr, 'k--');
legend([{'对数'}, arrayfun(@(g)sprintf('\\gamma=%.1f',g), gammas, 'UniformOutput',false), {'恒等'}]);
grid on; xlabel('输入灰度 r'); ylabel('输出灰度 s'); title('灰度变换函数曲线');
% [截图 2] 变换函数曲线（报告技术讨论部分引用）

%% 参数细调：选定区间内再试几组，确定"最佳视觉"参数
% 例：gamma 在 0.3~0.7 之间细调，报告要说明你的选择理由
figure('Name','P03-01 细调');
for k = 1:4
    gm = 0.3 + 0.1*k;
    subplot(1,4,k); imshow(r.^gm, []); title(sprintf('\\gamma=%.1f', gm));
end
% [截图 3] 细调对比图
