# Fig. 2.9: Leslie model with three age classes (book, Section 2.2, Eq. 2.11)
# x_{n+1} = L x_n with birth rate 9 of class 3 and survival rates 0.1 and 0.6, x_0 = (0, 0, 1000)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra

L = [0   0   9;
     0.1 0   0;
     0   0.6 0]
N = 20
X = zeros(3, N + 1)
X[:, 1] = [0, 0, 1000]
for k in 1:N
    X[:, k + 1] = L * X[:, k]
end
println("class 3 every three steps: ", join([@sprintf("%.1f", x) for x in X[3, 1:3:end]], "  "))
@printf("factor per period: 9 * 0.1 * 0.6 = %g < 1, the population dies out\n", 9 * 0.1 * 0.6)

namen = ["Class 1", "Class 2", "Class 3"]
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
bilder = [begin
    b = plot(0:N, X[i, :], ls = :dash, marker = zeichen[i], color = farben[i], label = namen[i], legend = :right)
    b
end for i in 1:3]
display(plot(bilder..., layout = (3, 1), size = (800, 700), xlabel = "n"))
