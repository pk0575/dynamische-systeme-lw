# Abb. 1.17: geometrisches Wachstum mit Wachstumsrate r (Buch, Abschnitt 1.3, Gl. 1.24)
# x_{n+1} = (1 + r) x_n mit x_0 = 100; links x_n, rechts ln(x_n)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

x0 = 100; N = 30
n = 0:N
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :diamond]
p1 = plot(xlabel = "n", ylabel = "x_n", legend = :topleft)
p2 = plot(xlabel = "n", ylabel = "ln(x_n)", legend = :topleft)
for (i, r) in enumerate([1, 0.1, -0.5])
    x = x0 .* (1 + r) .^ n
    plot!(p1, n[1:5], x[1:5], ls = :dash, marker = zeichen[i], color = rot[i], label = "r = $r")
    plot!(p2, n, log.(x), ls = :dash, marker = zeichen[i], color = rot[i], label = "r = $r")
    @printf("r = %g:  Steigung von ln(x_n) = ln(1 + r) = %.4f\n", r, log(1 + r))
end
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
