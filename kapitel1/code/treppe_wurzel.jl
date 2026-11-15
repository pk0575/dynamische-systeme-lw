# Abb. 1.26: Treppendiagramme zu x_{n+1} = sqrt(x_n) (Buch, Abschnitt 1.4, Gl. 1.31)
# x_0 = 0.5 (links) und x_0 = 1.4 (rechts); die Treppe läuft auf den Schnittpunkt von f(x) = sqrt(x) mit y = x
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

function treppe(x, unten = 0.0)          # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
    px = [x[1]]; py = [unten]
    for k in 1:length(x) - 1
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    return px, py
end
xx = range(0, 1.5, length = 300)
N = 4
bilder = []
for x0 in (0.5, 1.4)
    x = zeros(N + 1); x[1] = x0
    for k in 1:N
        x[k + 1] = sqrt(x[k])
    end
    println(@sprintf("x_0 = %g: ", x0), join([@sprintf("%.4f", v) for v in x], "  "))
    p = plot(xx, sqrt.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (0, 1.5), ylims = (0, 1.5), xlabel = "x", ylabel = "f(x)")
    plot!(p, [0, 1.5], [0, 1.5], color = :black)
    plot!(p, treppe(x)..., color = RGB(0.64, 0.08, 0.18))
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 450)))
