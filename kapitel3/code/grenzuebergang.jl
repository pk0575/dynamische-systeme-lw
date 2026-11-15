# Abb. 3.1: vom zeitdiskreten zum kontinuierlichen Wachstum (Buch, Abschnitt 3.1, Gl. 3.1 und 3.2)
# x(t + dt) = (1 + r dt) x(t) mit r = 0.5, x(0) = 1 für dt = 1, 0.5, 0.1; für dt -> 0 entsteht x(t) = e^(r t)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 0.5
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :utriangle]
p = plot(xlabel = "t", ylabel = "x", legend = :topleft)
for (i, dt) in enumerate([1, 0.5, 0.1])
    n = 0:round(Int, 4 / dt)
    x = (1 + r * dt) .^ n                # Lösung der Differenzengleichung
    scatter!(p, n .* dt, x, marker = zeichen[i], ms = [7, 5, 3][i], color = rot[i], label = "Δt = $dt")
    @printf("dt = %g: x(4) = %.4f\n", dt, x[end])
end
t = range(0, 4, length = 300)
plot!(p, t, exp.(r .* t), color = rot[1], lw = 2, label = "x(t) = e^(rt)")
@printf("e^(0.5*4) = %.4f\n", exp(2))
display(p)
