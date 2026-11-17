# Fig. 3.10: Growth of E. coli with a doubling time of 20 minutes (book, Section 3.2, Eq. 3.18)
# x(t) = 1000 · 2^(t/20) = 1000 e^(r t) with r = ln(2)/20 per minute
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

tV = 20; x0 = 1000
r = log(2) / tV
t = range(0, 120, length = 300)
p = plot(t, x0 .* exp.(r .* t), color = RGB(0.64, 0.08, 0.18), lw = 2.5, legend = false, xticks = 0:20:120, xlabel = "t (min)", ylabel = "cells")
for k in 1:6
    plot!(p, [tV * k, tV * k], [0, x0 * 2^k], ls = :dot, color = :gray); scatter!(p, [tV * k], [x0 * 2^k], color = :black)
end
@printf("r = ln(2)/20 = %.5f per minute;  x(120) = %.0f cells\n", r, x0 * exp(r * 120))
display(p)
