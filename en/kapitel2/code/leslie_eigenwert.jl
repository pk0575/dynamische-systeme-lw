# Fig. 2.13: Dominant eigenvalue of the Leslie model as a function of b_2 (book, Section 2.3, Eq. 2.19)
# b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; for R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, i.e. b_2 = 4.6, lambda_1 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra

b2 = range(0, 10, length = 201)
lam = [maximum(abs.(eigvals([0 b 9; 0.1 0 0; 0 0.6 0]))) for b in b2]
@printf("b_2 with R = 1: %.2f\n", (1 - 0.54) / 0.1)
@printf("lambda_1 at b_2 = 4.6: %.6f\n", maximum(abs.(eigvals([0 4.6 9; 0.1 0 0; 0 0.6 0]))))

p = plot(b2, lam, color = RGB(0, 0.447, 0.741), lw = 2, legend = false, xlabel = "b_2", ylabel = "λ₁")
hline!(p, [1], color = :black); plot!(p, [4.6, 4.6], [0.75, 1.2], ls = :dot, color = :black)
display(p)
