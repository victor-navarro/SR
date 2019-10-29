function plotCategorySpace(mod)
    figure
    subplot(1, 2, 1);
    scatter(mod.trainmat(:, 1, 1), mod.trainmat(:, 2, 1), [], mod.trainmat(:, 3, 1));
    title('Type 1');
    xlim([-1, 1]);
    ylim([-1, 1]);
    axis square
    subplot(1, 2, 2);
    scatter(mod.trainmat(:, 1, 2), mod.trainmat(:, 2, 2), [], mod.trainmat(:, 3, 2));
    xlim([-1, 1]);
    ylim([-1, 1]);
    axis square
    title('Type 2');