function plotControl(mod)
    figure;
    subplot(1, 2, 1);
    scatter(mod.space(:, 1), mod.space(:, 2), [], mod.strs(:, 1));
    title('Select-control');
    axis square
    subplot(1, 2, 2);
    scatter(mod.space(:, 1), mod.space(:, 2), [], mod.strs(:, 2));
    title('Reject-control');
    axis square