% Abb. 2.15: SIR-Modell, Szenarien A und B (Buch, Abschnitt 2.4, Gl. 2.21)
% S_{n+1} = S_n - beta S_n I_n + alpha N - alpha S_n,  I_{n+1} = I_n + beta S_n I_n - (gamma + alpha) I_n,  R_{n+1} = R_n + gamma I_n - alpha R_n
% N = 100000, alpha = gamma = 0.1;  A: beta = 1.2e-6, S_0 = 70000, I_0 = 30000;  B: beta = 7.6e-6, S_0 = 99999, I_0 = 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N = 100000; alpha = 0.1; gamma = 0.1;
namen = 'AB';
betas = [1.2e-6 7.6e-6]; S0s = [70000 99999]; I0s = [30000 1]; schritte = [60 80];
farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd'; lab = {'S_n', 'I_n', 'R_n'};
for sp = 1:2
    beta = betas(sp); M = schritte(sp);
    X = zeros(3, M + 1);                  % Zeilen: S, I, R
    X(:, 1) = [S0s(sp); I0s(sp); N - S0s(sp) - I0s(sp)];
    for k = 1:M
        S = X(1, k); I = X(2, k); R = X(3, k);
        X(:, k + 1) = [S - beta * S * I + alpha * N - alpha * S;
                       I + beta * S * I - (gamma + alpha) * I;
                       R + gamma * I - alpha * R];
    end
    R0 = beta * N / (gamma + alpha);      % Basisreproduktionszahl
    fprintf('Szenario %s: R_0 = %.1f,  (S, I, R) nach %d Schritten = (%.0f, %.0f, %.0f)\n', namen(sp), R0, M, X(:, end));
    for z = 1:3
        subplot(3, 2, 2 * (z - 1) + sp);
        plot(0:M, X(z, :), ['--' marker(z)], 'Color', farben(z, :), 'MarkerSize', 3); legend(lab{z}, 'Location', 'east');
        if z == 1, title(sprintf('Szenario %s, beta = %g', namen(sp), beta)); end
    end
    xlabel('n');
end
