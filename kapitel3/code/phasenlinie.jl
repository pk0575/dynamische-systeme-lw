# Abb. 3.14: Phasenlinie des logistischen Modells (Buch, Abschnitt 3.3, Gl. 3.22)
# f(x) = r (1 - x/K) x mit r = 0.55, K = 210; wo f > 0 ist, wächst x (Pfeil nach rechts), wo f < 0 ist, fällt x
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 0.55; K = 210
f(x) = r * (1 - x / K) * x
df(x) = r * (1 - 2x / K)                 # Ableitung f'(x)
x = range(-30, 280, length = 400)
p = plot(x, f.(x), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "f(x) = r (1 - x/K) x", xlabel = "x")
hline!(p, [0], color = :black, label = "")
for (von, bis) in [(20, 185), (275, 225), (-8, -28)]          # Phasenlinie: Bewegungsrichtung von x
    plot!(p, [von, bis], [0, 0], arrow = true, color = RGB(0.64, 0.08, 0.18), lw = 2.5, label = "")
end
scatter!(p, [0], [0], color = :white, msc = :black, ms = 7, label = ""); scatter!(p, [K], [0], color = :black, ms = 7, label = "")
for xs in (0, K)
    @printf("x* = %3d: f'(x*) = %5.2f -> %s\n", xs, df(xs), df(xs) < 0 ? "stabil" : "instabil")
end
display(p)
