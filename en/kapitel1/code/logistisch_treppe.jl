# Fig. 1.21: Update function and staircase diagram (book, Section 1.3, Eq. 1.30)
# f(y) = a y (1 - y) with a = 2.5, initial value y_0 = 0.1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

a = 2.5; y0 = 0.1; N = 12
f(y) = a * y * (1 - y)

y = range(0, 1, length = 200)
p = plot(y, f.(y), color = RGB(0, 0.447, 0.741), lw = 2, label = "f(y) = a y (1 - y)", legend = :topleft,
         xlims = (0, 1), ylims = (0, 1), xlabel = "y_n", ylabel = "y_{n+1}")
plot!(p, [0, 1], [0, 1], color = :black, label = "y_{n+1} = y_n")

# staircase: vertically to the graph, horizontally to the diagonal
yn = y0
px = [yn]; py = [0.0]
for k in 1:N
    global yn
    yneu = f(yn)
    append!(px, [yn, yneu]); append!(py, [yneu, yneu])
    yn = yneu
end
plot!(p, px, py, color = RGB(0.64, 0.08, 0.18), label = "")
@printf("y_%d = %.6f,  steady state 1 - 1/a = %.6f\n", N, yn, 1 - 1/a)
display(p)
