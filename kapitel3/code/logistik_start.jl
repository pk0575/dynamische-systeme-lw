# Abb. 3.15: Lösungen des logistischen Modells zu verschiedenen Startwerten (Buch, Abschnitt 3.3)
# r = 0.55, K = 210; die stationären Lösungen x = 0 und x = K werden von keiner anderen Lösung erreicht oder überquert
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 0.55; K = 210
x(t, x0) = x0 * K / (x0 + (K - x0) * exp(-r * t))
t = range(0, 20, length = 300)
p = plot(t, zero.(t), color = RGB(0.43, 0.04, 0.12), lw = 3, label = "x0 = 0", xlabel = "t (h)", ylabel = "x(t)", legend = :right)
plot!(p, t, zero.(t) .+ K, color = RGB(0.43, 0.04, 0.12), lw = 3, label = "x0 = K")
plot!(p, t, x.(t, 30), ls = :dash, color = RGB(0.64, 0.08, 0.18), lw = 2, label = "x0 = 30")
plot!(p, t, x.(t, 300), ls = :dash, color = RGB(0.89, 0.44, 0.49), lw = 2, label = "x0 = 300")
for x0 in (30, 300)
    @printf("x0 = %d: x(20) = %.3f,  Abstand zu K: %.3f\n", x0, x(20, x0), abs(x(20, x0) - K))
end
display(p)
