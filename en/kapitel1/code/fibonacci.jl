# Fig. 1.4: Fibonacci sequence (book, Section 1.1, Eq. 1.5 and 1.6)
# x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Plots

N = 10                             # number of months
x = zeros(Int, N + 1)
x[1] = 1; x[2] = 1                 # two initial values x_0 and x_1 (Julia counts from 1)
for k in 2:N
    x[k + 1] = x[k] + x[k - 1]     # recursion rule
end

n = 0:N
phi = (1 + sqrt(5)) / 2; psi = (1 - sqrt(5)) / 2
formel = (phi .^ (n .+ 1) .- psi .^ (n .+ 1)) ./ sqrt(5)   # solution formula (Eq. 1.6)
println(x)                         # [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
println(round.(Int, formel))       # the solution formula gives the same numbers

rot = RGB(0.64, 0.08, 0.18)
p = plot(n, x, ls = :dash, marker = :circle, color = rot, legend = false, xticks = n,
         xlabel = "n (months)", ylabel = "Rabbit pairs x_n")
annotate!(p, [(n[k], x[k] + 4, text(string(x[k]), 8, rot)) for k in eachindex(n)])
display(p)
