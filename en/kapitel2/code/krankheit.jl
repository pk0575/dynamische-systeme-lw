# Fig. 2.7: Disease progression as a linear system (book, Section 2.2, Eq. 2.8)
# x_{n+1} = A x_n with x = (healthy, mildly ill, severely ill), x_0 = (100000, 0, 0), one step = one year
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra

A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65]
N = 20
X = zeros(3, N + 1)
X[:, 1] = [100000, 0, 0]
for k in 1:N
    X[:, k + 1] = A * X[:, k]            # matrix times vector
end
@printf("x_20 = (%.0f, %.0f, %.0f)\n", X[:, end]...)
s = vec(sum(A, dims = 1))
@printf("column sums of A: %g %g %g -> the total number is conserved: %.0f\n", s..., sum(X[:, end]))

namen = ["healthy g_n", "mildly ill l_n", "severely ill k_n"]
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
bilder = [begin
    b = plot(0:N, X[i, :], ls = :dash, marker = zeichen[i], color = farben[i], label = namen[i], legend = :right)
    b
end for i in 1:3]
display(plot(bilder..., layout = (3, 1), size = (800, 700), xlabel = "n (years)"))
