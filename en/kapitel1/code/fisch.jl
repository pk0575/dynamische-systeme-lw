# Fig. 1.1: Fish length after n years (book, Section 1.1, Eq. 1.1)
# explicit sequence x_n = 60 n / (n + 2)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

n = 0:10                           # n = 0, 1, ..., 10
x = 60 .* n ./ (n .+ 2)            # formula for the n-th term (elementwise with dot)

println(join([@sprintf("%.1f", v) for v in x], "  "))   # 0.0  20.0  30.0  36.0 ...

rot = RGB(0.64, 0.08, 0.18)
p = plot(n, x, ls = :dash, marker = :circle, color = rot, legend = false, ylims = (-3, 60),
         xlabel = "n (years)", ylabel = "Fish length x_n (cm)")
annotate!(p, [(n[k], x[k] + 2.5, text(@sprintf("%.1f", x[k]), 8, rot)) for k in eachindex(n)])
display(p)
