# Abb. 3.12: logistisches Wachstum von Hefe (Buch, Abschnitt 3.2, Gl. 3.19 und 3.20)
# dx/dt = r (1 - x/K) x mit r = 0.55 pro Stunde, K = 210 (Millionen Zellen pro ml); Lösung x(t) = x0 K / (x0 + (K - x0) e^(-rt))
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 0.55; K = 210
x(t, x0) = x0 * K / (x0 + (K - x0) * exp(-r * t))
t = range(0, 20, length = 300)
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]
p = plot(xlabel = "t (h)", ylabel = "x(t)", legend = :bottomright)
for (i, x0) in enumerate([5, 50, 300])
    plot!(p, t, x.(t, x0), ls = [:solid, :dash, :dashdot][i], color = rot[i], lw = 2, label = "x0 = $x0")
    @printf("x0 = %3d: x(5) = %6.2f,  x(20) = %6.2f\n", x0, x(5, x0), x(20, x0))
end
hline!(p, [K], ls = :dash, color = :black, label = "")
display(p)
