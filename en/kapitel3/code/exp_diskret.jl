# Fig. 3.9: Continuous and discrete exponential growth (book, Section 3.2, Eq. 3.17)
# x(t) = e^(0.5 t) and x_n = a^n with a = e^0.5: at the times t = n both agree
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

t = range(0, 6, length = 300); n = 0:6
a = exp(0.5)
p = plot(t, exp.(0.5 .* t), color = RGB(0.43, 0.04, 0.12), lw = 2, label = "x(t) = e^(0.5t)", xlabel = "t or n", ylabel = "x")
scatter!(p, n, a .^ n, color = RGB(0.89, 0.44, 0.49), ms = 6, label = @sprintf("x_n = a^n, a = %.4f", a))
@printf("a = e^0.5 = %.4f;  a^6 = %.4f,  e^3 = %.4f\n", a, a^6, exp(3))
display(p)
