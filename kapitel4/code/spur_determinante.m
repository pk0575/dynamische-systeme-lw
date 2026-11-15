% Abb. 4.11: Spur-Determinanten-Ebene (Buch, Abschnitt 4.2)
% Die Spur T und die Determinante det A einer 2x2-Matrix entscheiden über Typ und Stabilität des Ursprungs; grau: stabil
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
namen = {'Bsp. 1', 'Bsp. 2', 'Bsp. 3', 'PK'};
As = {[-2 1; 1 -2], [-1 2; -2 -1], [0 -2; 2 0], [-1 0; 1 -0.2]};
T = linspace(-5, 5, 400);
fill([-5 0 0 -5], [0 0 7.5 7.5], [0.9 0.9 0.9], 'EdgeColor', 'none'); hold on
plot(T, T.^2 / 4, 'Color', [0 0.447 0.741], 'LineWidth', 2.5);
plot([-5 5], [0 0], 'k'); plot([0 0], [-2.5 7.5], 'k');
for i = 1:4
    A = As{i}; Sp = trace(A); De = det(A);
    if De < 0, typ = 'Sattel';
    elseif Sp == 0, typ = 'Zentrum';
    elseif Sp^2 >= 4 * De, typ = 'Knoten';
    else, typ = 'Spirale';
    end
    if Sp < 0 && De > 0, typ = [typ ', stabil']; end
    fprintf('%s: Spur = %4.1f,  det A = %4.1f  -> %s\n', namen{i}, Sp, De, typ);
    plot(Sp, De, 'ko', 'MarkerFaceColor', 'k'); text(Sp + 0.15, De + 0.2, namen{i});
end
text(-3.3, 0.9, 'Knoten stabil', 'HorizontalAlignment', 'center'); text(-3.6, 6.2, 'Spirale stabil', 'HorizontalAlignment', 'center');
text(3.3, 0.9, 'Knoten instabil', 'HorizontalAlignment', 'center'); text(2.2, 5.6, 'Spirale instabil', 'HorizontalAlignment', 'center');
text(2.2, -1.5, 'Sattel', 'HorizontalAlignment', 'center'); hold off
xlim([-5 5]); ylim([-2.5 7.5]); xlabel('Spur T'); ylabel('Determinante det A');
legend('stabil', 'det A = T^2/4', 'Location', 'southwest');
