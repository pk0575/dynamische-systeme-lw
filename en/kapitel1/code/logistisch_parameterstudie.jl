# Fig. 1.22: Parameter study of the logistic growth model (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n) with y_0 = 0.008 and a = 0.75, 3.3, 3.55, 4
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

y0 = 0.008; N = 24
n = 0:N
bilder = []
for a in (0.75, 3.3, 3.55, 4)
    y = zeros(N + 1)
    y[1] = y0
    for k in 1:N
        y[k + 1] = a * y[k] * (1 - y[k])
    end
    p = plot(n, y, ls = :dash, marker = :circle, color = RGB(0.64, 0.08, 0.18), label = "a = $a", legend = :topleft,
             xlabel = "n", ylabel = "y_n")
    a > 1 && hline!(p, [1 - 1/a], ls = :dash, color = :black, label = "")   # steady state 1 - 1/a
    push!(bilder, p)
    println(@sprintf("a = %g:  y_21 ... y_24 = ", a), join([@sprintf("%.4g", v) for v in y[22:25]], "  "))
end
display(plot(bilder..., layout = (2, 2), size = (900, 650)))
