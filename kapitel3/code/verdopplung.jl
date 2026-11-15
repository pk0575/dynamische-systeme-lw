# Abb. 3.10: Wachstum von E. coli mit der Verdopplungszeit 20 Minuten (Buch, Abschnitt 3.2, Gl. 3.18)
# x(t) = 1000 · 2^(t/20) = 1000 e^(r t) mit r = ln(2)/20 pro Minute
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

tV = 20; x0 = 1000
r = log(2) / tV
t = range(0, 120, length = 300)
p = plot(t, x0 .* exp.(r .* t), color = RGB(0.64, 0.08, 0.18), lw = 2.5, legend = false, xticks = 0:20:120, xlabel = "t (min)", ylabel = "Zellen")
for k in 1:6
    plot!(p, [tV * k, tV * k], [0, x0 * 2^k], ls = :dot, color = :gray); scatter!(p, [tV * k], [x0 * 2^k], color = :black)
end
@printf("r = ln(2)/20 = %.5f pro Minute;  x(120) = %.0f Zellen\n", r, x0 * exp(r * 120))
display(p)
