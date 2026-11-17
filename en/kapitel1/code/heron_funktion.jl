# Fig. 1.7: Update function of Heron's method (book, Section 1.1, Eq. 1.4)
# f(x) = (x + 2/x)/2 and first step x_0 = 0.5 -> x_1 = f(x_0)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

f(x) = 0.5 * (x + 2 / x)
x0 = 0.5
x1 = f(x0)
@printf("x_0 = %g,  x_1 = f(x_0) = %g\n", x0, x1)       # x_1 = 2.25

rot = RGB(0.64, 0.08, 0.18); blau = RGB(0, 0.447, 0.741)
x = range(0.16, 4.3, length = 400)
p = plot(x, f.(x), color = blau, lw = 2, label = "f(x) = (x + 2/x)/2", xlims = (0, 4.3), ylims = (0, 6.5),
         xlabel = "x", ylabel = "f(x)")
plot!(p, [x0, x0, 0], [0, x1, x1], ls = :dash, color = rot, label = "")   # up to the curve, then to the y-axis
scatter!(p, [x0, 0], [0, x1], color = rot, label = "")
display(p)
