# Abb. 3.17: Ernte mit fester Fangquote (Buch, Abschnitt 3.3)
# dx/dt = r (1 - x/K) x - q mit r = 0.5, K = 100;  stationär bei x* = K/2 (1 ± sqrt(1 - 4q/(rK))), solange q <= rK/4 = 12.5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

r = 0.5; K = 100
gruen = RGB(0, 0.39, 0)
x = range(0, 100, length = 300)
p1 = plot(x, r .* x .* (1 .- x ./ K), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "Zuwachs", xlabel = "x (1000 t)",
          title = "Zuwachs r x (1 - x/K) und Fang q", titlefontsize = 10)
for (q, stil) in zip([8, 12.5, 16], [:solid, :dash, :dot])
    hline!(p1, [q], ls = stil, color = RGB(0.64, 0.08, 0.18), lw = 2, label = "q = $q")
end
q = range(0, 12.5, length = 300)
w = sqrt.(max.(0, 1 .- 4 .* q ./ (r * K)))     # max(0, ...) fängt Rundungsfehler bei q = rK/4 ab
p2 = plot(q, K / 2 .* (1 .+ w), color = gruen, lw = 3, label = "x₊* stabil", xlims = (0, 21), legend = :bottomright,
          xlabel = "Fangquote q (1000 t/Jahr)", title = "Bifurkationsdiagramm", titlefontsize = 10)
plot!(p2, q, K / 2 .* (1 .- w), ls = :dash, color = gruen, lw = 2, label = "x₋* instabil"); scatter!(p2, [12.5], [50], color = :black, label = "")
for qq in (8, 12.5)
    ww = sqrt(max(0, 1 - 4qq / (r * K)))
    @printf("q = %g: x_- = %.2f,  x_+ = %.2f\n", qq, K / 2 * (1 - ww), K / 2 * (1 + ww))
end
@printf("größte Fangquote (MSY): q = rK/4 = %g\n", r * K / 4)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
