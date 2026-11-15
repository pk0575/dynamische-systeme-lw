# Abb. 1.33: die ersten Schritte des Newton-Verfahrens (Buch, Abschnitt 1.5, Gl. 1.44)
# x_{n+1} = x_n - g(x_n)/g'(x_n) für g(x) = exp(-5x) - x mit x_0 = 0.05
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

g(x) = exp(-5x) - x
dg(x) = -5exp(-5x) - 1

x = zeros(7); x[1] = 0.05
for k in 1:6
    x[k + 1] = x[k] - g(x[k]) / dg(x[k])
end
for k in 1:7
    @printf("x_%d = %.12f\n", k - 1, x[k])   # die Anzahl richtiger Stellen verdoppelt sich etwa pro Schritt
end

xx = range(0, 0.35, length = 300)
bilder = []
for p in 1:2
    b = plot(xx, g.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, xlims = (0, 0.35), ylims = (-0.35, 1), xlabel = "x")
    hline!(b, [0], color = :black)
    for j in 1:p                         # Tangente an der Stelle x_{j-1}, ihre Nullstelle ist x_j
        plot!(b, xx, g(x[j]) .+ dg(x[j]) .* (xx .- x[j]), color = :black)
        plot!(b, [x[j], x[j]], [0, g(x[j])], ls = :dot, color = :black)
    end
    scatter!(b, x[1:p + 1], zeros(p + 1), color = RGB(0.64, 0.08, 0.18))
    push!(bilder, b)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
