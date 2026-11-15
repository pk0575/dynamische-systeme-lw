% Abb. 2.18: Anfangsphase der Epidemie und Neuinfektionen (Buch, Abschnitt 2.4, Gl. 2.21 und 2.20)
% links: I_n in Szenario B logarithmisch mit dem Wachstumsfaktor lambda = 1 + (gamma + alpha)(R_0 - 1);
% rechts: Neuinfektionen beta S_n I_n pro Zeitschritt für R_0 = 2, 3, 4 (I_0 = 1, alpha = gamma = 0.1)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N = 100000; alpha = 0.1; gamma = 0.1;

% links: Szenario B
beta = 7.6e-6; M = 40;
S = zeros(1, M + 1); I = zeros(1, M + 1); S(1) = N - 1; I(1) = 1;
for k = 1:M
    S(k + 1) = S(k) - beta * S(k) * I(k) + alpha * (N - S(k));
    I(k + 1) = I(k) + beta * S(k) * I(k) - (gamma + alpha) * I(k);
end
lam = 1 + (gamma + alpha) * (beta * N / (gamma + alpha) - 1);
fprintf('Wachstumsfaktor am Anfang: lambda = %.2f;  I_10 = %.1f,  lambda^10 = %.1f\n', lam, I(11), lam^10);
n = 0:M;
subplot(1, 2, 1);
semilogy(n, lam.^n, 'Color', [0 0.447 0.741]); hold on
semilogy(n, I, 's--', 'Color', [0.89 0.44 0.49]); hold off
xlabel('n'); legend(sprintf('lambda^n, lambda = %.2f', lam), 'I_n');

% rechts: Neuinfektionen für R_0 = 2, 3, 4
subplot(1, 2, 2); hold on
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'osd';
M = 100;
for j = 1:3
    R0 = j + 1;
    beta = R0 * (gamma + alpha) / N;
    S = zeros(1, M + 1); I = zeros(1, M + 1); S(1) = N - 1; I(1) = 1;
    for k = 1:M
        S(k + 1) = S(k) - beta * S(k) * I(k) + alpha * (N - S(k));
        I(k + 1) = I(k) + beta * S(k) * I(k) - (gamma + alpha) * I(k);
    end
    neu = beta * S .* I;
    plot(0:M, neu, ['--' marker(j)], 'Color', rot(j, :), 'MarkerSize', 3, 'DisplayName', sprintf('R_0 = %d', R0));
    [m, im] = max(neu);
    fprintf('R_0 = %d: höchstens %.0f Neuinfektionen im Schritt n = %d\n', R0, m, im - 1);
end
hold off; xlabel('n'); ylabel('Neuinfektionen'); legend('show');
