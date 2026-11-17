# Fig. 1.11: Arithmetic and geometric sequences (book, Section 1.2, Eq. 1.11 and 1.13)
# top: x_{n+1} = x_n + b with x_0 = 20;  bottom: x_{n+1} = a x_n with x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]   # shades of red for several sequences
zeichen = [:circle, :rect, :diamond]

p1 = plot(xlabel = "n", ylabel = "x_n", legend = :topleft)
n = 0:10
for (i, b) in enumerate([2, 1, -1])
    x = 20 .+ b .* n                     # solution formula (1.12)
    plot!(p1, n, x, ls = :dash, marker = zeichen[i], color = rot[i], label = "b = $b")
    @printf("b = %g:  x_10 = %g\n", b, x[end])
end

p2 = plot(xlabel = "n", ylabel = "x_n", legend = :topleft)
n = 0:5
for (i, a) in enumerate([1.2, 1.01, 0.5])
    x = a .^ n                           # solution formula (1.14) with x_0 = 1
    plot!(p2, n, x, ls = :dash, marker = zeichen[i], color = rot[i], label = "a = $a")
    @printf("a = %g:  x_5 = %.4f\n", a, x[end])
end
display(plot(p1, p2, layout = (2, 1), size = (700, 650)))
