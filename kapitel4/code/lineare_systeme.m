% Abb. 4.10: drei lineare Systeme dx/dt = A x mit x(0) = (1, 3) (Buch, Abschnitt 4.2, Gl. 4.8 und 4.10)
% oben stabiler Knoten A = (-2 1; 1 -2), Mitte stabile Spirale A = (-1 2; -2 -1), unten Zentrum A = (0 -2; 2 0)
% links Zeitverläufe (Lösungsformeln), rechts Phasenebene mit Richtungsfeld
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
namen = {'stabiler Knoten', 'stabile Spirale', 'Zentrum'};
As = {[-2 1; 1 -2], [-1 2; -2 -1], [0 -2; 2 0]};
t = linspace(0, 6, 800);
X1 = {2 * exp(-t) - exp(-3 * t), exp(-t) .* (cos(2 * t) + 3 * sin(2 * t)), cos(2 * t) - 3 * sin(2 * t)};   % Lösungsformeln
X2 = {2 * exp(-t) + exp(-3 * t), exp(-t) .* (3 * cos(2 * t) - sin(2 * t)), 3 * cos(2 * t) + sin(2 * t)};
[G1, G2] = meshgrid(linspace(-3.6, 3.6, 15));
for z = 1:3
    A = As{z};
    lam = eig(A); lam = sortrows([imag(lam) real(lam)]);   % nach Imaginär-, dann Realteil ordnen
    fprintf('%s: Eigenwerte %s\n', namen{z}, sprintf('%g%+gi  ', lam(:, [2 1])'));
    subplot(3, 2, 2 * z - 1);
    plot([0 6], [0 0], 'k'); hold on
    plot(t, X1{z}, 'Color', [0.43 0.04 0.12], 'LineWidth', 2);
    plot(t, X2{z}, 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
    title(namen{z}); legend('', 'x1(t)', 'x2(t)');
    subplot(3, 2, 2 * z);
    U = A(1, 1) * G1 + A(1, 2) * G2; V = A(2, 1) * G1 + A(2, 2) * G2; L = sqrt(U.^2 + V.^2) + 1e-12;
    quiver(G1, G2, U ./ L, V ./ L, 0.4, 'Color', [0.2 0.6 0.25]); hold on
    plot(X1{z}, X2{z}, 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
    plot(1, 3, 'o', 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18]); plot(0, 0, 'ko', 'MarkerFaceColor', 'k'); hold off
    axis equal; xlim([-3.6 3.6]); ylim([-3.6 3.6]);
end
subplot(3, 2, 5); xlabel('t'); subplot(3, 2, 6); xlabel('x1');
