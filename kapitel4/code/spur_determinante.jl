# Abb. 4.11: Spur-Determinanten-Ebene (Buch, Abschnitt 4.2)
# Die Spur T und die Determinante det A einer 2x2-Matrix entscheiden über Typ und Stabilität des Ursprungs; grau: stabil
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using LinearAlgebra
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

matrizen = [("Bsp. 1", [-2 1; 1 -2]), ("Bsp. 2", [-1 2; -2 -1]), ("Bsp. 3", [0 -2; 2 0]), ("PK", [-1 0; 1 -0.2])]
T = range(-5, 5, length = 400)
p = plot(Shape([-5, 0, 0, -5], [0, 0, 7.5, 7.5]), color = :gray90, lw = 0, label = "stabil",
         xlims = (-5, 5), ylims = (-2.5, 7.5), xlabel = "Spur T", ylabel = "Determinante det A", legend = :bottomleft)
plot!(p, T, T .^ 2 ./ 4, color = BL, lw = 2.5, label = "det A = T²/4")
hline!(p, [0], color = :black, label = ""); vline!(p, [0], color = :black, label = "")
for (name, A) in matrizen
    Sp = tr(A); De = det(A)
    typ = De < 0 ? "Sattel" : Sp == 0 ? "Zentrum" : Sp^2 >= 4De ? "Knoten" : "Spirale"
    @printf("%s: Spur = %4.1f,  det A = %4.1f  -> %s%s\n", name, Sp, De, typ, Sp < 0 && De > 0 ? ", stabil" : "")
    scatter!(p, [Sp], [De], color = :black, label = ""); annotate!(p, Sp + 0.15, De + 0.2, text(name, 9, :left, :bottom))
end
for (x, y, txt) in [(-3.3, 0.9, "Knoten stabil"), (-3.6, 6.2, "Spirale stabil"), (3.3, 0.9, "Knoten instabil"),
                    (2.2, 5.6, "Spirale instabil"), (2.2, -1.5, "Sattel")]
    annotate!(p, x, y, text(txt, 9))
end
display(p)
