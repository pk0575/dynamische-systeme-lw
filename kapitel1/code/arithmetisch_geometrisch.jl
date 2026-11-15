# Abb. 1.11: arithmetische und geometrische Folge (Buch, Abschnitt 1.2, Gl. 1.11 und 1.13)
# oben: x_{n+1} = x_n + b mit x_0 = 20;  unten: x_{n+1} = a x_n mit x_0 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]   # Rottöne für mehrere Folgen
zeichen = [:circle, :rect, :diamond]

p1 = plot(xlabel = "n", ylabel = "x_n", legend = :topleft)
n = 0:10
for (i, b) in enumerate([2, 1, -1])
    x = 20 .+ b .* n                     # Lösungsformel (1.12)
    plot!(p1, n, x, ls = :dash, marker = zeichen[i], color = rot[i], label = "b = $b")
    @printf("b = %g:  x_10 = %g\n", b, x[end])
end

p2 = plot(xlabel = "n", ylabel = "x_n", legend = :topleft)
n = 0:5
for (i, a) in enumerate([1.2, 1.01, 0.5])
    x = a .^ n                           # Lösungsformel (1.14) mit x_0 = 1
    plot!(p2, n, x, ls = :dash, marker = zeichen[i], color = rot[i], label = "a = $a")
    @printf("a = %g:  x_5 = %.4f\n", a, x[end])
end
display(plot(p1, p2, layout = (2, 1), size = (700, 650)))
