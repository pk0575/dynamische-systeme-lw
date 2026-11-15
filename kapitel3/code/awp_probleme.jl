# Abb. 3.6: Anfangswertprobleme ohne eindeutige oder ohne globale Lösung (Buch, Abschnitt 3.1)
# links dx/dt = t/x, x(0) = 0: x(t) = t und x(t) = -t lösen beide;  rechts dx/dt = x^2, x(0) = 1: x(t) = 1/(1 - t) nur für t < 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

t = range(0, 2, length = 100)
p1 = plot(t, t, color = RGB(0.43, 0.04, 0.12), lw = 2, label = "x₁(t) = t", title = "dx/dt = t/x, x(0) = 0", xlabel = "t")
plot!(p1, t, -t, ls = :dash, color = RGB(0.89, 0.44, 0.49), lw = 2, label = "x₂(t) = -t"); scatter!(p1, [0], [0], color = :black, label = "")
t = range(0, 0.95, length = 200)
p2 = plot(t, 1 ./ (1 .- t), color = RGB(0.64, 0.08, 0.18), lw = 2, legend = false, xlims = (0, 1.2), ylims = (0, 20),
          title = "dx/dt = x², x(0) = 1", xlabel = "t")
vline!(p2, [1], ls = :dash, color = :black); scatter!(p2, [0], [1], color = :black)
for tt in (0.5, 0.9, 0.99)
    @printf("x(%g) = 1/(1 - %g) = %.0f\n", tt, tt, 1 / (1 - tt))
end
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
