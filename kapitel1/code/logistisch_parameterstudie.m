% Abb. 1.22: Parameterstudie zum logistischen Wachstumsmodell (Buch, Abschnitt 1.3, Gl. 1.28)
% y_{n+1} = a y_n (1 - y_n) mit y_0 = 0.008 und a = 0.75, 3.3, 3.55, 4
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
y0 = 0.008; N = 24;
n = 0:N;
as = [0.75 3.3 3.55 4];
for p = 1:4
    a = as(p);
    y = zeros(1, N + 1);
    y(1) = y0;
    for k = 1:N
        y(k + 1) = a * y(k) * (1 - y(k));
    end
    subplot(2, 2, p);
    plot(n, y, '--o', 'Color', [0.64 0.08 0.18], 'DisplayName', sprintf('a = %g', a)); hold on
    if a > 1
        plot([0 N], [1 - 1/a, 1 - 1/a], 'k--', 'HandleVisibility', 'off');   % stationärer Zustand 1 - 1/a
    end
    hold off; xlabel('n'); ylabel('y_n'); legend('show', 'Location', 'northwest');
    fprintf('a = %g:  y_21 ... y_24 = ', a); fprintf('%.4g  ', y(22:25)); fprintf('\n');
end
