# Abb. 1.29: stationäre Zustände des logistischen Modells und ihre Stabilität (Buch, Abschnitt 1.4, Gl. 1.35)
# y*_alpha = 0 und y*_beta = 1 - 1/a (durchgezogen stabil, gestrichelt instabil) mit dem Bifurkationsdiagramm
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Plots

blau = RGB(0, 0.447, 0.741)
a = range(3.0, 4.0, length = 1001)       # Bifurkationsdiagramm (hellgrün) für 3 <= a <= 4
y = fill(0.5, length(a))
for k in 1:2000
    global y = a .* y .* (1 .- y)
end
A = Float64[]; Y = Float64[]
for k in 1:300
    global y = a .* y .* (1 .- y)
    append!(A, a); append!(Y, y)
end
p = scatter(A, Y, ms = 0.5, msw = 0, color = RGB(0.47, 0.71, 0.47), legend = false,
            xlims = (0, 4), ylims = (-0.25, 1.05), xlabel = "a", ylabel = "y")
plot!(p, [0, 1], [0, 0], color = blau, lw = 2); plot!(p, [1, 4], [0, 0], ls = :dash, color = blau, lw = 2)   # y*_alpha = 0
for (von, bis, stil) in [(0.8, 1, :dash), (1, 3, :solid), (3, 4, :dash)]                                   # y*_beta = 1 - 1/a
    aa = range(von, bis, length = 100)
    plot!(p, aa, 1 .- 1 ./ aa, ls = stil, color = blau, lw = 2)
end
vline!(p, [1, 3], ls = :dot, color = :gray)
println("f'(y) = a (1 - 2y):  f'(0) = a, f'(1 - 1/a) = 2 - a")
println("y*_alpha stabil für a < 1, y*_beta stabil für 1 < a < 3")
display(p)
