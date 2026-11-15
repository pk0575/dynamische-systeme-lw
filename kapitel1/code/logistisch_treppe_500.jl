# Abb. 1.31: Treppendiagramme des logistischen Modells über 500 Schritte (Buch, Abschnitt 1.4)
# Startwert 0.05; a = 2 (Fixpunkt), 3.3 (2-Zyklus), 3.55 (8-Zyklus), 4 (aperiodisch)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

N = 500
xx = range(0, 1, length = 400)
bilder = []
for a in (2, 3.3, 3.55, 4)
    f(y) = a * y * (1 - y)
    y = zeros(N + 1); y[1] = 0.05
    for k in 1:N
        y[k + 1] = f(y[k])
    end
    px = [y[1]]; py = [0.0]                                # Treppe
    for k in 1:N
        append!(px, [y[k], y[k + 1]]); append!(py, [y[k + 1], y[k + 1]])
    end
    p = plot(xx, f.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1, xlims = (0, 1), ylims = (0, 1),
             xlabel = "x_n", ylabel = "f(x_n)", title = "a = $a")
    plot!(p, [0, 1], [0, 1], color = :black)
    plot!(p, px, py, color = RGB(0.64, 0.08, 0.18), lw = a < 4 ? 1.5 : 0.3)
    push!(bilder, p)
    werte = sort(unique(round.(y[end-15:end] .* 1e4) ./ 1e4))   # Langzeitverhalten: verschiedene Werte am Ende
    if length(werte) <= 8
        println(@sprintf("a = %g:  %d verschiedene Werte am Ende: ", a, length(werte)), join([@sprintf("%.4f", w) for w in werte], "  "))
    else
        @printf("a = %g:  %d verschiedene Werte am Ende: aperiodisch\n", a, length(werte))
    end
end
display(plot(bilder..., layout = (2, 2), size = (850, 850)))
