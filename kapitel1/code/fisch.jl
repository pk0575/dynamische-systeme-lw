# Abb. 1.1: Fischlänge nach n Jahren (Buch, Abschnitt 1.1, Gl. 1.1)
# explizite Folge x_n = 60 n / (n + 2)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

n = 0:10                           # n = 0, 1, ..., 10
x = 60 .* n ./ (n .+ 2)            # Formel für das n-te Folgenglied (elementweise mit Punkt)

println(join([@sprintf("%.1f", v) for v in x], "  "))   # 0.0  20.0  30.0  36.0 ...

rot = RGB(0.64, 0.08, 0.18)
p = plot(n, x, ls = :dash, marker = :circle, color = rot, legend = false, ylims = (-3, 60),
         xlabel = "n (Jahre)", ylabel = "Fischlänge x_n (cm)")
annotate!(p, [(n[k], x[k] + 2.5, text(@sprintf("%.1f", x[k]), 8, rot)) for k in eachindex(n)])
display(p)
