# Fig. 1.24: Sensitivity to the initial value (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n) with y_0 = 0.05 and ~y_0 = 0.06 for a = 2, 3.1, 3.55, 4
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

N = 30
n = 0:N
bilder = []
for a in (2, 3.1, 3.55, 4)
    y = zeros(N + 1); yt = zeros(N + 1)
    y[1] = 0.05; yt[1] = 0.06
    for k in 1:N
        y[k + 1] = a * y[k] * (1 - y[k])
        yt[k + 1] = a * yt[k] * (1 - yt[k])
    end
    p = plot(n, y, ls = :dash, marker = :circle, color = RGB(0.43, 0.04, 0.12), label = "y_n, a = $a", legend = :bottomright,
             xlabel = "n", ylims = (0, 1))
    plot!(p, n, yt, ls = :dash, marker = :rect, color = RGB(0.89, 0.44, 0.49), label = "~y_n, a = $a")
    hline!(p, [1 - 1/a], color = :black, label = "")
    push!(bilder, p)
    @printf("a = %g:  |y_30 - ~y_30| = %.4f\n", a, abs(y[N + 1] - yt[N + 1]))
end
display(plot(bilder..., layout = (2, 2), size = (900, 650)))
