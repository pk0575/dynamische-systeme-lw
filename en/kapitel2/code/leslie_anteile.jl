# Fig. 2.12: Stable age distribution in the Leslie model (book, Section 2.3, Eq. 2.17)
# L with b_2 = 5: the fractions of the classes approach the eigenvector v_1 for the dominant eigenvalue lambda_1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra

L = [0   5   9;
     0.1 0   0;
     0   0.6 0]
w, Vec = eigen(L)
i1 = argmax(abs.(w))
v1 = real.(Vec[:, i1]); v1 = v1 ./ sum(v1)
@printf("dominant eigenvalue lambda_1 = %.4f\n", real(w[i1]))
@printf("stable age distribution v_1 = (%.3f, %.3f, %.3f)\n", v1...)

N = 30
X = zeros(3, N + 1); X[:, 1] = [0, 0, 1000]
for k in 1:N
    X[:, k + 1] = L * X[:, k]
end
P = X ./ sum(X, dims = 1)                # fractions of the classes
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
p = plot(xlabel = "n", ylabel = "Fraction of class")
for i in 1:3
    plot!(p, 0:N, P[i, :], marker = zeichen[i], color = farben[i], label = "Class $i")
    hline!(p, [v1[i]], ls = :dash, color = farben[i], label = "")
end
display(p)
