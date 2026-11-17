# Fig. 5.4: Circulating excitation on a ring (book, Section 5.3, Eq. 5.2)
# Initial state: piece of length L behind the front of a fiber stimulated at its end; L = 100 mm circulates, L = 65 mm dies out
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # parameters in ms
D = 0.1; dx = 0.2; dt = 0.02                                         # mm^2/ms, mm, ms

function euler(v, h, lap)
    dv = h .* v.^2 .* (1 .- v) ./ tin .- v ./ tout .+ D .* lap ./ dx^2
    dh = ifelse.(v .< vgate, (1 .- h) ./ topen, -h ./ tclose)
    return v .+ dt .* dv, h .+ dt .* dh
end

# stimulate a long fiber (250 mm) at the left until the front (v > 0.5) is at 200 mm
function faser()
    N = round(Int, 250 / dx) + 1; x = dx .* (0:N-1); v = zeros(N); h = ones(N); n = 0; lap = zeros(N)
    while !any(v .> 0.5) || maximum(x[v .> 0.5]) < 200
        lap[2:end-1] .= v[3:end] .- 2 .* v[2:end-1] .+ v[1:end-2]; lap[1] = v[2] - v[1]; lap[end] = v[end-1] - v[end]
        v, h = euler(v, h, lap)
        n * dt < 2.0 && (v[x .<= 1.0] .+= dt * 0.2)                  # stimulus J = 0.2 for 2 ms
        n += 1
    end
    return v, h, findlast(v .> 0.5)
end
vF, hF, iF = faser()

function ring(L, T; alle = 10)
    # ring of length L; returns v every 'alle' time steps and the times at which v reaches 0.5 at the middle of the ring
    M = round(Int, L / dx); v = vF[iF-M+1:iF]; h = hF[iF-M+1:iF]
    bild = Vector{Vector{Float64}}(); akt = Float64[]; oben = false; mitte = M ÷ 2 + 1
    for k in 0:round(Int, T / dt)-1
        k % alle == 0 && push!(bild, copy(v))
        v, h = euler(v, h, circshift(v, 1) .- 2 .* v .+ circshift(v, -1))
        if v[mitte] > 0.5 && !oben; push!(akt, (k + 1) * dt); oben = true; end
        v[mitte] < 0.1 && (oben = false)
    end
    return bild, akt, maximum(v)
end

bilder = []
for L in (100, 65)
    B, akt, vmax = ring(L, 1500.0)
    @printf("L = %d mm: round-trip times [%s] ms, the excitation %s\n", L, join([@sprintf("%.1f", d) for d in diff(akt)], " "), vmax > 0.5 ? "circulates" : "dies out")
    push!(bilder, heatmap(range(0, L, length = length(B[1])), range(0, 1500, length = length(B)), reduce(hcat, B)', color = :reds,
                          clims = (0, 1), title = "L = $L mm", xlabel = "position on the ring (mm)", ylabel = "t (ms)"))
end
for L in 66:70                                                       # critical length
    B, akt, vmax = ring(L, 800.0, alle = 10^9)
    @printf("L = %d mm: %s\n", L, vmax > 0.5 ? "circulates" : "dies out")
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
