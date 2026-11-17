# Fig. 3.14: Phase line of the logistic model (book, Section 3.3, Eq. 3.22)
# f(x) = r (1 - x/K) x with r = 0.55, K = 210; where f > 0, x grows (arrow to the right), where f < 0, x decreases
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

r = 0.55; K = 210
f(x) = r * (1 - x / K) * x
df(x) = r * (1 - 2x / K)                 # derivative f'(x)
x = range(-30, 280, length = 400)
p = plot(x, f.(x), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "f(x) = r (1 - x/K) x", xlabel = "x")
hline!(p, [0], color = :black, label = "")
for (von, bis) in [(20, 185), (275, 225), (-8, -28)]          # phase line: direction of motion of x
    plot!(p, [von, bis], [0, 0], arrow = true, color = RGB(0.64, 0.08, 0.18), lw = 2.5, label = "")
end
scatter!(p, [0], [0], color = :white, msc = :black, ms = 7, label = ""); scatter!(p, [K], [0], color = :black, ms = 7, label = "")
for xs in (0, K)
    @printf("x* = %3d: f'(x*) = %5.2f -> %s\n", xs, df(xs), df(xs) < 0 ? "stable" : "unstable")
end
display(p)
