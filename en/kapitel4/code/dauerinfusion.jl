# Fig. 4.12: Continuous infusion (book, Section 4.2, Eq. 4.11)
# dm/dt = -ka m,  db/dt = ka m - ke b + u  with u = 1 mg per hour, m(0) = b(0) = 0:  b(t) = (u/ke)(1 - e^(-ke t)), b* = u/ke = 5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

ke = 0.2; u = 1
t = range(0, 30, length = 600)
b = u / ke .* (1 .- exp.(-ke .* t))
for tt in (5, 10, 20, 30)
    @printf("t = %2d h: b = %.3f mg\n", tt, u / ke * (1 - exp(-ke * tt)))
end
p = hline([u / ke], color = :black, ls = :dash, label = "", ylims = (0, 6), legend = :bottomright, xlabel = "t (hours)", ylabel = "Drug (mg)")
plot!(p, t, b, color = R2, lw = 2.5, label = "Blood b(t)")
display(p)
