# Abb. 1.25: Treppendiagramm zu x_{n+1} = x_n + 0.5 (Buch, Abschnitt 1.4)
# x_0 = 0.25; links ein Schritt, rechts vier Schritte. Der Graph von f schneidet y = x nicht: kein stationärer Zustand.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

f(x) = x + 0.5
x = zeros(5); x[1] = 0.25
for k in 1:4
    x[k + 1] = f(x[k])
end
println("x_0 ... x_4 = ", join([@sprintf("%g", v) for v in x], "  "))

function treppe(x, unten = 0.0)          # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
    px = [x[1]]; py = [unten]
    for k in 1:length(x) - 1
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    return px, py
end
rot = RGB(0.64, 0.08, 0.18)
bilder = []
for s in (1, 4)
    p = plot([0, 3], [f(0), f(3)], color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (0, 3), ylims = (0, 3), xlabel = "x", ylabel = "f(x)")
    plot!(p, [0, 3], [0, 3], color = :black)
    plot!(p, treppe(x[1:s + 1])..., color = rot)
    scatter!(p, x[1:s], x[2:s + 1], color = rot)          # Punkte (x_n, x_{n+1})
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 450)))
