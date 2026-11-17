% Fig. 3.8: Exponential growth and decay (book, Section 3.2, Eq. 3.15 and 3.16)
% x(t) = e^(0.5 t) and x(t) = e^(-0.5 t); left linear, right logarithmic axis (where both become straight lines)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
t = linspace(0, 6, 300);
for i = 1:2
    subplot(1, 2, i);
    if i == 1
        plot(t, exp(0.5 * t), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
        plot(t, exp(-0.5 * t), '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
        title('linear axis'); legend('e^{0.5t} (growth)', 'e^{-0.5t} (decay)', 'Location', 'northwest');
    else
        semilogy(t, exp(0.5 * t), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
        semilogy(t, exp(-0.5 * t), '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
        title('logarithmic axis: straight lines');
    end
    xlabel('t');
end
fprintf('doubling time ln(2)/0.5 = %.4f,  half-life = %.4f\n', log(2) / 0.5, log(2) / 0.5);
