# Fig. 3.13: Continuous and discrete-time logistic model (book, Section 3.2, Eq. 3.20)
# line: solution of dx/dt = r (1 - x/K) x;  points: x_{n+1} = x_n + r x_n (1 - x_n/K);  K = 210, x0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

K = 210; x0 = 0.2
t = range(0, 30, length = 400)
bilder = []
for r in (0.55, 2.1, 2.6, 3.0)
    p = plot(t, x0 .* K ./ (x0 .+ (K - x0) .* exp.(-r .* t)), color = RGB(0.43, 0.04, 0.12), lw = 2, legend = false,
             ylims = (-10, 300), title = "r = $r", xlabel = "t or n")
    x = zeros(31); x[1] = x0
    for n in 1:30
        x[n + 1] = x[n] + r * x[n] * (1 - x[n] / K)
    end
    plot!(p, 0:30, x, ls = :dash, marker = :circle, ms = 3, color = RGB(0.89, 0.44, 0.49))
    push!(bilder, p)
    println(@sprintf("r = %g: x_27 ... x_30 = ", r), join([@sprintf("%.1f", v) for v in x[28:31]], "  "))
end
display(plot(bilder..., layout = (2, 2), size = (900, 650)))
