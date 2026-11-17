# Fig. 2.19: Action potentials in the Chialvo model (book, Section 2.5, Eq. 2.33)
# y1_{n+1} = y1_n^2 exp(y2_n - y1_n) + k,  y2_{n+1} = a y2_n - b y1_n + c  with a = 0.89, c = 0.28, k = 0.03
# left b = 0.26 (regular), right b = 0.18 (chaotic, early afterdepolarizations); top y1, bottom y2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra

a = 0.89; c = 0.28; k = 0.03; N = 150
bilder = []
for b in (0.26, 0.18)
    y1 = zeros(N + 1); y2 = zeros(N + 1)
    y1[1] = 0.2; y2[1] = c / (1 - a)
    for j in 1:N
        y1[j + 1] = y1[j]^2 * exp(y2[j] - y1[j]) + k
        y2[j + 1] = a * y2[j] - b * y1[j] + c
    end
    ap = sum((y1[2:end] .> 1) .& (y1[1:end-1] .<= 1))     # number of excursions above 1
    @printf("b = %g: %d action potentials in %d steps, max y1 = %.2f\n", b, ap, N, maximum(y1))
    push!(bilder, plot(0:N, y1, ls = :dash, marker = :circle, ms = 2, color = RGB(0.64, 0.08, 0.18), legend = false, title = "b = $b", ylabel = "y_1,n"))
    push!(bilder, plot(0:N, y2, ls = :dash, marker = :circle, ms = 2, color = RGB(0.89, 0.44, 0.49), legend = false, xlabel = "n", ylabel = "y_2,n"))
end
display(plot(bilder[[1, 3, 2, 4]]..., layout = (2, 2), size = (900, 600)))
