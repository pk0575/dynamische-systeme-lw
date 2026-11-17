# Fig. 3.16: Fish stock with harvesting, steady states as a function of the harvesting rate (book, Section 3.3)
# dx/dt = r (1 - x/K) x - h x with r = 0.5 per year, K = 100 (1000 t):  x_a* = 0 and x_b* = K (1 - h/r)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

r = 0.5; K = 100
gruen = RGB(0, 0.39, 0)
h = range(0, 1, length = 301)
li = h .<= r; re = h .>= r; nah = (h .>= r) .& (h .<= 0.62)
p = plot(h[li], 0 .* h[li], ls = :dash, color = gruen, lw = 2, legend = false, ylims = (-30, 105),
         xlabel = "Harvesting rate h (per year)", ylabel = "x* (1000 t)")    # x_a* unstable for h < r
plot!(p, h[re], 0 .* h[re], color = gruen, lw = 3)                    # stable for h > r
plot!(p, h[li], K .* (1 .- h[li] ./ r), color = gruen, lw = 3)        # x_b* stable for h < r
plot!(p, h[nah], K .* (1 .- h[nah] ./ r), ls = :dash, color = gruen, lw = 2)
vline!(p, [r], ls = :dot, color = :black)
for hh in (0.1, 0.25, 0.4)
    @printf("h = %g: x_b* = %.0f,  yield h x_b* = %.2f\n", hh, K * (1 - hh / r), hh * K * (1 - hh / r))
end
display(p)
