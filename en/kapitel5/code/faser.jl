# Fig. 5.2: A pulse on the fiber (book, Section 5.2, Eq. 5.2)
# cable equation with the Mitchell-Schaeffer model, fiber 150 mm, stimulus at the left end; method of lines with Euler method
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # parameters in ms
D = 0.1; dx = 0.1; dt = 0.01                                         # D in mm^2/ms, grid spacing in mm, time step in ms
L = 150.0; T = 500.0
N = round(Int, L / dx) + 1; x = dx .* (0:N-1)
v = zeros(N); h = ones(N)
reiz = x .<= 1.0                                                     # stimulus J = 0.2 on the first millimeter for 2 ms
zeiten = [100.0, 250.0, 400.0]; schnapp = Dict{Int, Vector{Float64}}()
K = round(Int, T / dt); s25 = zeros(K); s75 = zeros(K); t_akt = fill(NaN, N)
lap = zeros(N)
for n in 0:K-1
    t = n * dt
    for z in zeiten
        abs(t - z) < 1e-6 && (schnapp[round(Int, z)] = copy(v))
    end
    lap[2:end-1] .= v[3:end] .- 2 .* v[2:end-1] .+ v[1:end-2]
    lap[1] = v[2] - v[1]; lap[end] = v[end-1] - v[end]               # no flux across the boundary
    dv = h .* v.^2 .* (1 .- v) ./ tin .- v ./ tout .+ D .* lap ./ dx^2
    t < 2.0 && (dv[reiz] .+= 0.2)
    dh = ifelse.(v .< vgate, (1 .- h) ./ topen, -h ./ tclose)
    global v = v .+ dt .* dv; global h = h .+ dt .* dh
    neu = isnan.(t_akt) .& (v .> 0.5); t_akt[neu] .= t + dt          # time at which v first reaches 0.5
    s25[n + 1] = v[251]; s75[n + 1] = v[751]
end
c = (x[751] - x[251]) / (t_akt[751] - t_akt[251])
ts = dt .* collect(1:K); a = ts[s75 .> 0.1]; apd = a[end] - a[1]
@printf("v = 0.5 at x = 25 mm after %.1f ms, at x = 75 mm after %.1f ms\n", t_akt[251], t_akt[751])
@printf("conduction velocity c = %.4f mm/ms,  APD = %.1f ms,  wavelength c APD = %.1f mm\n", c, apd, c * apd)
farben = [RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18), RGB(0.43, 0.04, 0.12)]
p1 = plot(xlabel = "x (mm)", ylabel = "v(x, t)")
for (j, z) in enumerate((100, 250, 400))
    plot!(p1, x, schnapp[z], color = farben[j], lw = 2, label = "t = $z ms")
end
p2 = plot(ts, s25, color = farben[3], lw = 2, label = "x = 25 mm", xlabel = "t (ms)", ylabel = "v(x, t)")
plot!(p2, ts, s75, color = farben[1], lw = 2, label = "x = 75 mm")
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
