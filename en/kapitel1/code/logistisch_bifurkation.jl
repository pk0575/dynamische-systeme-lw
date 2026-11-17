# Fig. 1.23: Bifurcation diagram of the logistic growth model (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n): for each value of a, the long-term behavior after n_* = 10000 steps is plotted
# top: 2.8 <= a <= 4;  bottom: detail 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (the pattern recurs)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

gruen = RGB(0, 0.39, 0)
bilder = []
for (a, behalten, fenster) in [(range(2.8, 4.0, length = 2401), 200, (0, 1)),
                               (range(3.8538, 3.8541, length = 1501), 6000, (0.494, 0.506))]
    y = fill(0.9, length(a))             # all parameter values at once (vector)
    for k in 1:10000                     # transient
        y = a .* y .* (1 .- y)
    end
    A = Float64[]; Y = Float64[]
    for k in 1:behalten                  # collect long-term behavior
        y = a .* y .* (1 .- y)
        m = (y .> fenster[1]) .& (y .< fenster[2])
        append!(A, a[m]); append!(Y, y[m])
    end
    push!(bilder, scatter(A, Y, ms = 0.5, msw = 0, color = gruen, legend = false, xlabel = "a", ylabel = "y_n for n > 10000"))
end
display(plot(bilder..., layout = (2, 1), size = (800, 700)))

a = 3.2; y = 0.9                         # example a = 3.2: two values alternate (2-cycle)
for k in 1:10000
    global y = a * y * (1 - y)
end
@printf("a = 3.2:  2-cycle %.4f <-> %.4f\n", y, a * y * (1 - y))
