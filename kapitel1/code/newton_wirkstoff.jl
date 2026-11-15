# Abb. 1.35: Wann fällt der Wirkstoffspiegel unter 1 mg/l? (Buch, Abschnitt 1.5, Gl. 1.44)
# c(t) = 5 (exp(-0.2 t) - exp(-t)); Newton-Verfahren für g(t) = c(t) - 1 mit Startwert t_0 = 10 h
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

c(t) = 5 * (exp(-0.2t) - exp(-t))
dc(t) = 5 * (-0.2exp(-0.2t) + exp(-t))

t = zeros(6); t[1] = 10
for k in 1:5
    t[k + 1] = t[k] - (c(t[k]) - 1) / dc(t[k])
end
for k in 1:6
    @printf("t_%d = %.6f h\n", k - 1, t[k])
end

tt = range(0, 24, length = 500)
p = plot(tt, c.(tt), color = RGB(0.64, 0.08, 0.18), lw = 2, legend = false, xlims = (0, 24), ylims = (0, 3),
         xlabel = "Zeit t (h)", ylabel = "c(t) (mg/l)")
hline!(p, [1], color = :black); scatter!(p, [t[end]], [1], color = :black)
annotate!(p, t[end] + 0.5, 1.15, text(@sprintf("t* = %.2f h", t[end]), 9, :left))
display(p)
