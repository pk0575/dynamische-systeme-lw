% Abb. 2.11: Krankheitsverlauf mit stationärem Zustand (Buch, Abschnitt 2.3, Gl. 2.8)
% Der stationäre Zustand x* = A x* ist ein Eigenvektor zum Eigenwert 1, skaliert auf 100000 Personen
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65];
[V, D] = eig(A);
w = diag(D);
fprintf('Eigenwerte: '); fprintf('%.4f  ', sort(real(w))); fprintf('\n');
[~, i1] = min(abs(w - 1));
v = real(V(:, i1));                      % Eigenvektor zum Eigenwert 1
xs = v / sum(v) * 100000;
fprintf('stationärer Zustand x* = (%.0f, %.0f, %.0f)\n', xs);

N = 30;
X = zeros(3, N + 1); X(:, 1) = [100000; 0; 0];
for k = 1:N
    X(:, k + 1) = A * X(:, k);
end
namen = {'g_n', 'l_n', 'k_n'};
farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
for i = 1:3
    subplot(3, 1, i);
    plot(0:N, X(i, :), ['--' marker(i)], 'Color', farben(i, :)); hold on
    plot([0 N], xs(i) * [1 1], 'k--'); hold off
    legend(namen{i}, 'Location', 'southeast');
end
xlabel('n (Jahre)');
