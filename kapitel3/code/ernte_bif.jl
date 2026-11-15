# Abb. 3.16: Fischbestand mit Ernte, stationäre Zustände in Abhängigkeit von der Ernterate (Buch, Abschnitt 3.3)
# dx/dt = r (1 - x/K) x - h x mit r = 0.5 pro Jahr, K = 100 (1000 t):  x_a* = 0 und x_b* = K (1 - h/r)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 0.5; K = 100
gruen = RGB(0, 0.39, 0)
h = range(0, 1, length = 301)
li = h .<= r; re = h .>= r; nah = (h .>= r) .& (h .<= 0.62)
p = plot(h[li], 0 .* h[li], ls = :dash, color = gruen, lw = 2, legend = false, ylims = (-30, 105),
         xlabel = "Ernterate h (pro Jahr)", ylabel = "x* (1000 t)")    # x_a* instabil für h < r
plot!(p, h[re], 0 .* h[re], color = gruen, lw = 3)                    # stabil für h > r
plot!(p, h[li], K .* (1 .- h[li] ./ r), color = gruen, lw = 3)        # x_b* stabil für h < r
plot!(p, h[nah], K .* (1 .- h[nah] ./ r), ls = :dash, color = gruen, lw = 2)
vline!(p, [r], ls = :dot, color = :black)
for hh in (0.1, 0.25, 0.4)
    @printf("h = %g: x_b* = %.0f,  Ertrag h x_b* = %.2f\n", hh, K * (1 - hh / r), hh * K * (1 - hh / r))
end
display(p)
