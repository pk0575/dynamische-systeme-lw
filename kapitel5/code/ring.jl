# Abb. 5.4: Kreisende Erregung auf einem Ring (Buch, Abschnitt 5.3, Gl. 5.2)
# Anfangszustand: Stück der Länge L hinter der Front einer am Ende gereizten Faser; L = 100 mm kreist, L = 65 mm erlischt
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # Parameter in ms
D = 0.1; dx = 0.2; dt = 0.02                                         # mm^2/ms, mm, ms

function euler(v, h, lap)
    dv = h .* v.^2 .* (1 .- v) ./ tin .- v ./ tout .+ D .* lap ./ dx^2
    dh = ifelse.(v .< vgate, (1 .- h) ./ topen, -h ./ tclose)
    return v .+ dt .* dv, h .+ dt .* dh
end

# lange Faser (250 mm) links reizen, bis die Front (v > 0.5) bei 200 mm liegt
function faser()
    N = round(Int, 250 / dx) + 1; x = dx .* (0:N-1); v = zeros(N); h = ones(N); n = 0; lap = zeros(N)
    while !any(v .> 0.5) || maximum(x[v .> 0.5]) < 200
        lap[2:end-1] .= v[3:end] .- 2 .* v[2:end-1] .+ v[1:end-2]; lap[1] = v[2] - v[1]; lap[end] = v[end-1] - v[end]
        v, h = euler(v, h, lap)
        n * dt < 2.0 && (v[x .<= 1.0] .+= dt * 0.2)                  # Reiz J = 0.2 für 2 ms
        n += 1
    end
    return v, h, findlast(v .> 0.5)
end
vF, hF, iF = faser()

function ring(L, T; alle = 10)
    # Ring der Länge L; liefert v alle 'alle' Zeitschritte und die Zeitpunkte, an denen v in der Ringmitte 0.5 erreicht
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
    @printf("L = %d mm: Umlaufzeiten [%s] ms, die Erregung %s\n", L, join([@sprintf("%.1f", d) for d in diff(akt)], " "), vmax > 0.5 ? "kreist" : "erlischt")
    push!(bilder, heatmap(range(0, L, length = length(B[1])), range(0, 1500, length = length(B)), reduce(hcat, B)', color = :reds,
                          clims = (0, 1), title = "L = $L mm", xlabel = "Ort auf dem Ring (mm)", ylabel = "t (ms)"))
end
for L in 66:70                                                       # kritische Länge
    B, akt, vmax = ring(L, 800.0, alle = 10^9)
    @printf("L = %d mm: %s\n", L, vmax > 0.5 ? "kreist" : "erlischt")
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
