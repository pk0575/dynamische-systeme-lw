# Fig. 3.1: From discrete-time to continuous growth (book, Section 3.1, Eq. 3.1 and 3.2)
# x(t + dt) = (1 + r dt) x(t) with r = 0.5, x(0) = 1 for dt = 1, 0.5, 0.1; for dt -> 0 one obtains x(t) = e^(r t)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

r = 0.5
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :utriangle]
p = plot(xlabel = "t", ylabel = "x", legend = :topleft)
for (i, dt) in enumerate([1, 0.5, 0.1])
    n = 0:round(Int, 4 / dt)
    x = (1 + r * dt) .^ n                # solution of the difference equation
    scatter!(p, n .* dt, x, marker = zeichen[i], ms = [7, 5, 3][i], color = rot[i], label = "Δt = $dt")
    @printf("dt = %g: x(4) = %.4f\n", dt, x[end])
end
t = range(0, 4, length = 300)
plot!(p, t, exp.(r .* t), color = rot[1], lw = 2, label = "x(t) = e^(rt)")
@printf("e^(0.5*4) = %.4f\n", exp(2))
display(p)
