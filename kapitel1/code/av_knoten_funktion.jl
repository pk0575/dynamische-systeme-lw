# Abb. 1.36: Aktualisierungsfunktion des AV-Knoten-Modells (Buch, Abschnitt 1.6, Gl. 1.47)
# f(V) = c V falls c V > V_g, sonst c V + u;  V_g = 1, u = 1;  links c = 1/3, rechts zusätzlich c = 0.6
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

Vg = 1; u = 1
farben = [RGB(0, 0.447, 0.741), RGB(0.45, 0.70, 0.90)]
bilder = []
for (p, cs) in enumerate([[1/3], [1/3, 0.6]])
    b = plot(xlims = (0, 4), ylims = (0, 2.7), xlabel = "V", ylabel = "f(V)", legend = :topleft)
    for (i, c) in enumerate(cs)
        s = Vg / c                       # Sprungstelle: c V = V_g
        links = range(0, min(s, 4), length = 200); rechts = range(s, 4, length = 200)
        plot!(b, links, c .* links .+ u, color = farben[i], lw = 2, label = @sprintf("c = %.3g", c))
        plot!(b, rechts, c .* rechts, color = farben[i], lw = 2, label = "")
        scatter!(b, [s], [c * s + u], color = farben[i], label = "")
        p == 2 && @printf("c = %.3g: Sprungstelle bei V = V_g/c = %.3f\n", c, s)
    end
    push!(bilder, b)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
