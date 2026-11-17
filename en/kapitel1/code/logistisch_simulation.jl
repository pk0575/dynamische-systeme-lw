# Fig. 1.20: Simulation of the logistic growth model (book, Section 1.3, Eq. 1.26)
# x_{n+1} = x_n + r (1 - x_n/K) x_n with K = 5, x_0 = 0.1, and three growth rates r; 20 (left) and 50 (right) steps
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

K = 5; x0 = 0.1
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :diamond]
bilder = []
for N in (20, 50)
    n = 0:N
    p = plot(xlabel = "n", ylabel = "x_n", legend = :bottomright)
    hline!(p, [K], color = :black, label = "")
    for (i, r) in enumerate([0.5, 0.25, 0.1])
        x = zeros(N + 1)
        x[1] = x0                        # Julia counts from 1: x[1] is x_0
        for k in 1:N
            x[k + 1] = x[k] + r * (1 - x[k] / K) * x[k]
        end
        plot!(p, n, x, ls = :dash, marker = zeichen[i], ms = 3, color = rot[i], label = "r = $r")
        @printf("N = %d, r = %g:  x_N = %.4f\n", N, r, x[N + 1])
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
