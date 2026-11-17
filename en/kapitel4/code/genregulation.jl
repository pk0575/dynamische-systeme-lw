# Fig. 4.22: Gene regulation with activator and repressor (book, Section 4.4, Eq. 4.18)
# dA/dt = k A^2/(A^2 + 10 (1 + 5R)) - A + 0.4,  dR/dt = 0.3 A^2/(A^2 + 10 (1 + 5R)) - 0.2 R  with A(0) = 3, R(0) = 0.2
# left k = 9.5: damped oscillation; right k = 10.5: limit cycle
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))

t = range(0, 400, length = 4001)
bilder = []
for k in (9.5, 10.5)
    f(t, z) = [k * z[1]^2 / (z[1]^2 + 10 * (1 + 5z[2])) - z[1] + 0.4,
               0.3 * z[1]^2 / (z[1]^2 + 10 * (1 + 5z[2])) - 0.2 * z[2]]
    A = loese(f, [3, 0.2], t)[1, :]
    push!(bilder, plot(t, A, color = RGB(0.64, 0.08, 0.18), lw = 2, legend = false, title = "k = $k", xlabel = "t (min)",
                       ylabel = k == 9.5 ? "Activator A" : ""))
    spaet = t .> 200                     # maxima after the transient
    i = [j for j in 2:length(A) - 1 if A[j] > A[j - 1] && A[j] > A[j + 1] && spaet[j]]
    schwankung = maximum(A[spaet]) - minimum(A[spaet])
    if schwankung > 0.01
        @printf("k = %g: variation of A for t > 200: %.3f, period %.1f min\n", k, schwankung, sum(diff(t[i])) / (length(i) - 1))
    else
        @printf("k = %g: variation of A for t > 200: %.3f (steady state)\n", k, schwankung)
    end
end
display(plot(bilder..., layout = (1, 2), link = :y, size = (900, 420)))
