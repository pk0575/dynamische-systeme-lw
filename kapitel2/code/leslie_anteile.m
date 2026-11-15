% Abb. 2.12: stabile Altersverteilung im Leslie-Modell (Buch, Abschnitt 2.3, Gl. 2.17)
% L mit b_2 = 5: die Anteile der Klassen nähern sich dem Eigenvektor v_1 zum dominanten Eigenwert lambda_1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
L = [0   5   9;
     0.1 0   0;
     0   0.6 0];
[V, D] = eig(L);
w = diag(D);
[~, i1] = max(abs(w));
v1 = real(V(:, i1)); v1 = v1 / sum(v1);
fprintf('dominanter Eigenwert lambda_1 = %.4f\n', real(w(i1)));
fprintf('stabile Altersverteilung v_1 = (%.3f, %.3f, %.3f)\n', v1);

N = 30;
X = zeros(3, N + 1); X(:, 1) = [0; 0; 1000];
for k = 1:N
    X(:, k + 1) = L * X(:, k);
end
P = X ./ sum(X, 1);                      % Anteile der Klassen
farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
hold on
for i = 1:3
    plot(0:N, P(i, :), ['-' marker(i)], 'Color', farben(i, :), 'DisplayName', sprintf('Klasse %d', i));
    plot([0 N], v1(i) * [1 1], '--', 'Color', farben(i, :), 'HandleVisibility', 'off');
end
hold off; xlabel('n'); ylabel('Anteil der Klasse'); legend('show');
