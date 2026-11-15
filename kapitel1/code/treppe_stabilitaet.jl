# Abb. 1.28: Treppendiagramme mit stabilen und instabilen stationären Zuständen (Buch, Abschnitt 1.4, Gl. 1.34)
# oben: f(x) = x - 2x(0.5 - x)(1 - x) mit Fixpunkten 0 und 1 (stabil) sowie 0.5 (instabil)
# unten: f(x) = exp(-2x) (spiralförmige Annäherung) und f(x) = exp(-5x) (spiralförmige Entfernung), jeweils x_0 = 0.2
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

function treppe(x, unten = 0.0)          # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
    px = [x[1]]; py = [unten]
    for k in 1:length(x) - 1
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    return px, py
end
g(x) = x - 2 * x * (0.5 - x) * (1 - x)
faelle = [(g, "f(x) = x - 2x(0.5-x)(1-x)", [0.6], 20, 0.5, 1.0),
          (g, "f(x) = x - 2x(0.5-x)(1-x)", [0.4, 0.6], 20, 0.0, 1.0),
          (x -> exp(-2x), "f(x) = exp(-2x)", [0.2], 20, 0.0, 1.0),
          (x -> exp(-5x), "f(x) = exp(-5x)", [0.2], 7, 0.0, 1.0)]
bilder = []
for (f, name, starts, N, lo, hi) in faelle
    xx = range(lo, hi, length = 400)
    p = plot(xx, f.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (lo, hi), ylims = (lo, hi), xlabel = "x_n", ylabel = "f(x_n)", title = name, titlefontsize = 9)
    plot!(p, [lo, hi], [lo, hi], color = :black)
    for x0 in starts
        x = zeros(N + 1); x[1] = x0
        for k in 1:N
            x[k + 1] = f(x[k])
        end
        plot!(p, treppe(x, lo)..., color = RGB(0.64, 0.08, 0.18))
        @printf("%s, x_0 = %g:  x_%d = %.4f\n", name, x0, N, x[end])
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (2, 2), size = (850, 850)))

# Stabilitätskriterium |f'(x*)| < 1 an den Fixpunkten
for c in (2, 5)
    xs = 0.5
    for k in 1:100                       # Fixpunkt mit dem Newton-Verfahren
        xs = xs - (exp(-c * xs) - xs) / (-c * exp(-c * xs) - 1)
    end
    @printf("f(x) = exp(-%dx):  x* = %.4f,  f'(x*) = %.4f\n", c, xs, -c * exp(-c * xs))
end
