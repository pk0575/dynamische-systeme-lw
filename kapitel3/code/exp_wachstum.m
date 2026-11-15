% Abb. 3.8: exponentielles Wachstum und Abklingen (Buch, Abschnitt 3.2, Gl. 3.15 und 3.16)
% x(t) = e^(0.5 t) und x(t) = e^(-0.5 t); links lineare, rechts logarithmische Achse (dort werden beide zu Geraden)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
t = linspace(0, 6, 300);
for i = 1:2
    subplot(1, 2, i);
    if i == 1
        plot(t, exp(0.5 * t), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
        plot(t, exp(-0.5 * t), '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
        title('lineare Achse'); legend('e^{0.5t} (Wachstum)', 'e^{-0.5t} (Abklingen)', 'Location', 'northwest');
    else
        semilogy(t, exp(0.5 * t), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
        semilogy(t, exp(-0.5 * t), '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
        title('logarithmische Achse: Geraden');
    end
    xlabel('t');
end
fprintf('Verdopplungszeit ln(2)/0.5 = %.4f,  Halbwertszeit = %.4f\n', log(2) / 0.5, log(2) / 0.5);
