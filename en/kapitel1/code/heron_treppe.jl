# Fig. 1.8: Staircase diagram of Heron's method (book, Section 1.1, Eq. 1.4)
# x_{n+1} = (x_n + 2/x_n)/2 with x_0 = 0.5; the staircase runs into the intersection with y = x at sqrt(2)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

f(x) = 0.5 * (x + 2 / x)
x0 = 0.5; N = 4

x = zeros(N + 1)
x[1] = x0                                # Julia counts from 1: x[1] is x_0
for k in 1:N
    x[k + 1] = f(x[k])
end
for k in 1:N + 1
    @printf("x_%d = %.6f\n", k - 1, x[k])
end
@printf("sqrt(2) = %.6f\n", sqrt(2))

rot = RGB(0.64, 0.08, 0.18); blau = RGB(0, 0.447, 0.741)
xx = range(0.3, 3, length = 400)
bilder = []
for s in (1, N)
    p = plot(xx, f.(xx), color = blau, lw = 2, legend = false, xlims = (0, 3), ylims = (0, 3),
             xlabel = "x", ylabel = "f(x)", title = "$s step(s)")
    plot!(p, [0, 3], [0, 3], color = :black)
    px = [x[1]]; py = [0.0]              # staircase: vertically to the graph, horizontally to the diagonal
    for k in 1:s
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    push!(px, x[s + 1]); push!(py, 0.0)  # value back to the x-axis
    plot!(p, px, py, color = rot)
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
