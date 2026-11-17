# Fig. 1.32: Steady state of x_{n+1} = exp(-x_n) (book, Section 1.5)
# left: intersection of f(x) = exp(-x) with y = x;  right: equivalently the root of g(x) = exp(-x) - x
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

x = 0.5
for n in 1:100                           # fixed-point iteration x_{n+1} = exp(-x_n)
    global x = exp(-x)
end
@printf("fixed-point iteration after 100 steps: x = %.10f\n", x)
@printf("g(x) = exp(-x) - x = %.1e\n", exp(-x) - x)

blau = RGB(0, 0.447, 0.741)
xx = range(0, 1, length = 200)
p1 = plot(xx, exp.(-xx), color = blau, lw = 2, label = "f(x) = exp(-x)", xlabel = "x")
plot!(p1, [0, 1], [0, 1], color = :black, label = "y = x"); scatter!(p1, [x], [x], color = :black, label = "")
p2 = plot(xx, exp.(-xx) .- xx, color = blau, lw = 2, label = "g(x) = exp(-x) - x", xlabel = "x")
hline!(p2, [0], color = :black, label = ""); scatter!(p2, [x], [0], color = :black, label = "")
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
