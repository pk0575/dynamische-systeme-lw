# Fig. 4.24: Phase plane of the Mitchell-Schaeffer model (book, Section 4.5, Eq. 4.20)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J0,  dh/dt = (1 - h)/topen for v < vgate, -h/tclose otherwise;  J0 = 0
# nullclines, direction field, resting state (1, 0), threshold, and the action potential after a stimulus at t = 1 ms
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # parameters in ms
hc = 4 * tin / tout

function simuliere(T; J0 = 0.0, reize = (), J = 0.2, dauer = 2.0, dt = 0.01)
    # Euler's method for the Mitchell-Schaeffer model with constant current J0 and stimuli of strength J
    N = round(Int, T / dt); t = dt .* (0:N)
    Jt = fill(J0, N + 1)
    for s in reize
        Jt[(t .>= s - 1e-9) .& (t .< s + dauer - 1e-9)] .+= J
    end
    v = zeros(N + 1); h = ones(N + 1)
    for n in 1:N
        dv = h[n] * v[n]^2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
        dh = v[n] < vgate ? (1 - h[n]) / topen : -h[n] / tclose
        v[n + 1] = v[n] + dt * dv; h[n + 1] = h[n] + dt * dh
    end
    return t, v, h
end

function nullklinen!(p, J0)
    v = range(0.003, 0.997, length = 2000)
    H = (v ./ tout .- J0) ./ (v .^ 2 .* (1 .- v) ./ tin)   # dv/dt = 0 solved for h
    m = (H .>= -0.05) .& (H .<= 1.1)
    plot!(p, H[m], v[m], color = BL, lw = 2.5, label = "dv/dt = 0")
    J0 == 0 && plot!(p, [-0.05, 1.1], [0, 0], color = BL, lw = 2.5, label = "")
    plot!(p, [1, 1], [-0.05, vgate], color = HB, lw = 2.5, label = "dh/dt = 0")
    plot!(p, [0, 0], [vgate, 1.05], color = HB, lw = 2.5, label = "")
end

function feld!(p, J0)
    hg = [h for h in range(0.05, 1.05, length = 12), v in range(0.05, 1.0, length = 11)][:]
    vg = [v for h in range(0.05, 1.05, length = 12), v in range(0.05, 1.0, length = 11)][:]
    dv = hg .* vg .^ 2 .* (1 .- vg) ./ tin .- vg ./ tout .+ J0
    dh = ifelse.(vg .< vgate, (1 .- hg) ./ topen, -hg ./ tclose)
    L = hypot.(dh, dv) ./ 0.052
    quiver!(p, hg, vg, quiver = (dh ./ L, dv ./ L), color = GR, label = "")
end

t, v, h = simuliere(500, reize = [1.0])
vs = (1 - sqrt(1 - hc)) / 2
@printf("resting state (h, v) = (1, 0),  threshold (1, %.4f),  peak of the action potential v = %.4f\n", vs, maximum(v))
@printf("after 500 ms: (h, v) = (%.4f, %.4f)\n", h[end], v[end])
p = plot(xlims = (-0.05, 1.1), ylims = (-0.05, 1.05), xlabel = "h", ylabel = "v", legend = :right)
feld!(p, 0); nullklinen!(p, 0)
plot!(p, h, v, color = R2, lw = 2, label = "Action potential")
scatter!(p, [1], [0], color = :black, ms = 7, label = ""); scatter!(p, [1], [vs], color = :white, msc = :black, ms = 7, label = "")
display(p)
