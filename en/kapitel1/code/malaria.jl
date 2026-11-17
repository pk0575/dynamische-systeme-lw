# Fig. 1.3: Malaria parasites after n days (book, Section 1.1, Eq. 1.2 and 1.3)
# recursion rule x_{n+1} = 8 x_n, x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Plots

N = 4                              # number of days
x = zeros(Int, N + 1)
x[1] = 1                           # initial value x_0 = 1 (Julia counts from 1: x[1] is x_0)
for k in 1:N
    x[k + 1] = 8 * x[k]            # recursion rule
end

n = 0:N
println(x)                         # [1, 8, 64, 512, 4096]
println(8 .^ n .* x[1])            # solution formula x_n = 8^n x_0 gives the same

rot = RGB(0.64, 0.08, 0.18)
p = plot(n, x, ls = :dash, marker = :circle, color = rot, legend = false, xticks = n,
         xlabel = "n (days)", ylabel = "Number of parasites x_n")
annotate!(p, [(n[k], x[k] + 250, text(string(x[k]), 8, rot)) for k in eachindex(n)])
display(p)
