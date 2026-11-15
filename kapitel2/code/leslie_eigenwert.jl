# Abb. 2.13: dominanter Eigenwert des Leslie-Modells in Abhängigkeit von b_2 (Buch, Abschnitt 2.3, Gl. 2.19)
# b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; bei R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, also b_2 = 4.6, ist lambda_1 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra

b2 = range(0, 10, length = 201)
lam = [maximum(abs.(eigvals([0 b 9; 0.1 0 0; 0 0.6 0]))) for b in b2]
@printf("b_2 mit R = 1: %.2f\n", (1 - 0.54) / 0.1)
@printf("lambda_1 bei b_2 = 4.6: %.6f\n", maximum(abs.(eigvals([0 4.6 9; 0.1 0 0; 0 0.6 0]))))

p = plot(b2, lam, color = RGB(0, 0.447, 0.741), lw = 2, legend = false, xlabel = "b_2", ylabel = "λ₁")
hline!(p, [1], color = :black); plot!(p, [4.6, 4.6], [0.75, 1.2], ls = :dot, color = :black)
display(p)
