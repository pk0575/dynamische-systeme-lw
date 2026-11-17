% Fig. 4.11: Trace-determinant plane (book, Section 4.2)
% The trace T and the determinant det A of a 2x2 matrix determine the type and stability of the origin; gray: stable
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
namen = {'Ex. 1', 'Ex. 2', 'Ex. 3', 'PK'};
As = {[-2 1; 1 -2], [-1 2; -2 -1], [0 -2; 2 0], [-1 0; 1 -0.2]};
T = linspace(-5, 5, 400);
fill([-5 0 0 -5], [0 0 7.5 7.5], [0.9 0.9 0.9], 'EdgeColor', 'none'); hold on
plot(T, T.^2 / 4, 'Color', [0 0.447 0.741], 'LineWidth', 2.5);
plot([-5 5], [0 0], 'k'); plot([0 0], [-2.5 7.5], 'k');
for i = 1:4
    A = As{i}; Sp = trace(A); De = det(A);
    if De < 0, typ = 'saddle';
    elseif Sp == 0, typ = 'center';
    elseif Sp^2 >= 4 * De, typ = 'node';
    else, typ = 'spiral';
    end
    if Sp < 0 && De > 0, typ = [typ ', stable']; end
    fprintf('%s: trace = %4.1f,  det A = %4.1f  -> %s\n', namen{i}, Sp, De, typ);
    plot(Sp, De, 'ko', 'MarkerFaceColor', 'k'); text(Sp + 0.15, De + 0.2, namen{i});
end
text(-3.3, 0.9, 'stable node', 'HorizontalAlignment', 'center'); text(-3.6, 6.2, 'stable spiral', 'HorizontalAlignment', 'center');
text(3.3, 0.9, 'unstable node', 'HorizontalAlignment', 'center'); text(2.2, 5.6, 'unstable spiral', 'HorizontalAlignment', 'center');
text(2.2, -1.5, 'saddle', 'HorizontalAlignment', 'center'); hold off
xlim([-5 5]); ylim([-2.5 7.5]); xlabel('trace T'); ylabel('Determinant det A');
legend('stable', 'det A = T^2/4', 'Location', 'southwest');
