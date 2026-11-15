% Abb. 2.7: Krankheitsverlauf als lineares System (Buch, Abschnitt 2.2, Gl. 2.8)
% x_{n+1} = A x_n mit x = (gesund, leicht erkrankt, schwer erkrankt), x_0 = (100000, 0, 0), ein Schritt = ein Jahr
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65];
N = 20;
X = zeros(3, N + 1);
X(:, 1) = [100000; 0; 0];
for k = 1:N
    X(:, k + 1) = A * X(:, k);           % Matrix mal Vektor
end
fprintf('x_20 = (%.0f, %.0f, %.0f)\n', X(:, end));
fprintf('Spaltensummen von A: %g %g %g -> die Gesamtzahl bleibt erhalten: %.0f\n', sum(A), sum(X(:, end)));

namen = {'gesund g_n', 'leicht erkrankt l_n', 'schwer erkrankt k_n'};
farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
for i = 1:3
    subplot(3, 1, i);
    plot(0:N, X(i, :), ['--' marker(i)], 'Color', farben(i, :)); legend(namen{i}, 'Location', 'southeast');
end
xlabel('n (Jahre)');
