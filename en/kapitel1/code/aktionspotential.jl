# Fig. 1.38: Action potentials under periodic stimulation (book, Section 1.6)
# Mitchell-Schaeffer model (two currents), Euler's method with dt = 0.01 ms, stimulus every PCL = 400 ms;
# measured is the time above the reference value 0.1 (action potential duration APD) and below it (diastolic interval DI)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13   # time constants in ms
PCL = 400; T = 2050; dt = 0.01; vref = 0.1

t = (0:round(Int, T / dt) - 1) .* dt
v = zeros(length(t))
vv = 0.0; h = 1.0
for i in 2:length(t)
    global vv, h
    J = mod(t[i], PCL) < 2 ? 0.2 : 0.0   # stimulus: 2 ms long
    dv = h * vv^2 * (1 - vv) / tin - vv / tout + J
    dh = vv < vgate ? (1 - h) / topen : -h / tclose
    vv = vv + dt * dv
    h = h + dt * dh
    v[i] = vv
end

s = sign.(v .- vref)                     # crossings of the reference value
kreuz = t[findall(diff(s) .!= 0)]
auf = kreuz[1:2:end]; ab = kreuz[2:2:end]
for k in eachindex(ab)
    if k < length(auf)
        @printf("AP %d:  APD = %6.1f ms,  DI = %6.1f ms\n", k, ab[k] - auf[k], auf[k + 1] - ab[k])
    else
        @printf("AP %d:  APD = %6.1f ms\n", k, ab[k] - auf[k])
    end
end

p = plot(t, v, color = RGB(0.64, 0.08, 0.18), legend = false, xlabel = "t (ms)", ylabel = "v (dimensionless)")
hline!(p, [vref], ls = :dot, color = :gray)
display(p)
