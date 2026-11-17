# Fig. 2.10: Quotient of consecutive Fibonacci numbers (book, Section 2.3, Eq. 2.15)
# system j_{n+1} = e_n, e_{n+1} = e_n + j_n; the quotient e_{n+1}/e_n tends to the dominant eigenvalue (golden ratio)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra

A = [0 1;
     1 1]
x = [1, 0]                               # (j_0, e_0): one young pair
e = [x[2]]
for k in 1:16
    global x = A * x
    push!(e, x[2])
end
q = e[3:end] ./ e[2:end-1]
println("eigenvalues of A: ", join([@sprintf("%.6f", l) for l in sort(eigvals(A))], "  "))
println("e_{n+1}/e_n: ", join([@sprintf("%.6f", v) for v in q[end-3:end]], "  "), "   golden ratio: ", @sprintf("%.6f", (1 + sqrt(5)) / 2))

p = plot(1:length(q), q, ls = :dash, marker = :circle, color = RGB(0.64, 0.08, 0.18), label = "e_{n+1}/e_n", xlabel = "n")
hline!(p, [(1 + sqrt(5)) / 2], ls = :dash, color = :black, label = "λ₁ = 1.618")
display(p)
