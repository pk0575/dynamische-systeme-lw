# Fig. 4.11: Trace-determinant plane (book, Section 4.2)
# The trace T and the determinant det A of a 2x2 matrix determine the type and stability of the origin; gray: stable
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using LinearAlgebra
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

matrizen = [("Ex. 1", [-2 1; 1 -2]), ("Ex. 2", [-1 2; -2 -1]), ("Ex. 3", [0 -2; 2 0]), ("PK", [-1 0; 1 -0.2])]
T = range(-5, 5, length = 400)
p = plot(Shape([-5, 0, 0, -5], [0, 0, 7.5, 7.5]), color = :gray90, lw = 0, label = "stable",
         xlims = (-5, 5), ylims = (-2.5, 7.5), xlabel = "trace T", ylabel = "Determinant det A", legend = :bottomleft)
plot!(p, T, T .^ 2 ./ 4, color = BL, lw = 2.5, label = "det A = T²/4")
hline!(p, [0], color = :black, label = ""); vline!(p, [0], color = :black, label = "")
for (name, A) in matrizen
    Sp = tr(A); De = det(A)
    typ = De < 0 ? "saddle" : Sp == 0 ? "center" : Sp^2 >= 4De ? "node" : "spiral"
    @printf("%s: trace = %4.1f,  det A = %4.1f  -> %s%s\n", name, Sp, De, typ, Sp < 0 && De > 0 ? ", stable" : "")
    scatter!(p, [Sp], [De], color = :black, label = ""); annotate!(p, Sp + 0.15, De + 0.2, text(name, 9, :left, :bottom))
end
for (x, y, txt) in [(-3.3, 0.9, "stable node"), (-3.6, 6.2, "stable spiral"), (3.3, 0.9, "unstable node"),
                    (2.2, 5.6, "unstable spiral"), (2.2, -1.5, "saddle")]
    annotate!(p, x, y, text(txt, 9))
end
display(p)
