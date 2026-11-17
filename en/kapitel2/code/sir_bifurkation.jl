# Fig. 2.17: Steady-state values I* of the SIR model as a function of R_0 (book, Section 2.4, Eq. 2.30)
# x_a*: I* = 0, stable for R_0 < 1;  x_b*: I* = alpha N (1 - 1/R_0)/(gamma + alpha), stable for R_0 > 1 (alpha = gamma = 0.1)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra
N = 100000; alpha = 0.1; gamma = 0.1
R0 = range(0.01, 5, length = 500)
Ib = alpha * N .* (1 .- 1 ./ R0) ./ (gamma + alpha)
gruen = RGB(0, 0.39, 0)
li = R0 .<= 1; re = R0 .>= 1; nah = (R0 .> 0.85) .& (R0 .<= 1)
p = plot(R0[li], 0 .* R0[li], color = gruen, lw = 3, legend = false, ylims = (-6000, 52000), xlabel = "R_0", ylabel = "I*")   # stable
plot!(p, R0[re], 0 .* R0[re], ls = :dash, color = gruen, lw = 2)                                                         # unstable
plot!(p, R0[re], Ib[re], color = gruen, lw = 3)
plot!(p, R0[nah], Ib[nah], ls = :dash, color = gruen, lw = 2)
for (r, name) in [(0.6, "A"), (3.8, "B")]
    i = r < 1 ? 0.0 : alpha * N * (1 - 1 / r) / (gamma + alpha)
    scatter!(p, [r], [i], color = :black); annotate!(p, r, i + 2500, text(name, 10))
    @printf("Scenario %s: R_0 = %g,  I* = %.0f\n", name, r, i)
end
vline!(p, [1], ls = :dot, color = :black)
display(p)
