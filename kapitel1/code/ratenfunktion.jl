# Abb. 1.18: Ratenfunktion des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.26)
# R(x) = r (1 - x/K): bei kleinem Bestand wächst er fast mit der Rate r, bei x = K kommt das Wachstum zum Erliegen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 1; K = 5
R(x) = r * (1 - x / K)
for x in (0, 1, 2.5, 5)
    @printf("R(%g) = %.2f\n", x, R(x))
end

x = range(0, K, length = 100)
display(plot(x, R.(x), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, xlabel = "x", ylabel = "R(x)",
             xticks = ([0, K], ["0", "K"]), yticks = ([0, r], ["0", "r"])))
