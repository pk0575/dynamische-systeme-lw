% Abb. 2.9: Leslie-Modell mit drei Altersklassen (Buch, Abschnitt 2.2, Gl. 2.11)
% x_{n+1} = L x_n mit Geburtenrate 9 der Klasse 3 und Überlebensraten 0.1 und 0.6, x_0 = (0, 0, 1000)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
L = [0   0   9;
     0.1 0   0;
     0   0.6 0];
N = 20;
X = zeros(3, N + 1);
X(:, 1) = [0; 0; 1000];
for k = 1:N
    X(:, k + 1) = L * X(:, k);
end
fprintf('Klasse 3 alle drei Schritte: '); fprintf('%.1f  ', X(3, 1:3:end)); fprintf('\n');
fprintf('Faktor pro Periode: 9 * 0.1 * 0.6 = %g < 1, die Population stirbt aus\n', 9 * 0.1 * 0.6);

farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
for i = 1:3
    subplot(3, 1, i);
    plot(0:N, X(i, :), ['--' marker(i)], 'Color', farben(i, :)); legend(sprintf('Klasse %d', i));
end
xlabel('n');
