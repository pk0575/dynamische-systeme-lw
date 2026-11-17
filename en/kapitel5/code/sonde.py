# Fig. 5.6: An arrhythmia in the model (book, Section 5.4, Eq. 5.6)
# as Fig. 5.5 up to t = 3000 ms; course of v at the point (25, 25) mm, intervals, durations, and diastolic intervals of the action potentials
# The computation takes about three minutes.
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # parameters in ms
D, dx, dt, Lq = 0.1, 0.25, 0.05, 100.0                               # mm^2/ms, mm, ms, side length in mm
N = int(round(Lq / dx)); xs = dx * (np.arange(N) + 0.5)
X, Y = np.meshgrid(xs, xs, indexing="ij")
S1, S2 = X <= 1.0, Y <= Lq / 2
i0 = int(25 / dx)                                                    # grid point at (25, 25) mm
v = np.zeros((N, N)); h = np.ones((N, N)); spur = []
for n in range(int(round(3000 / dt))):
    t = n * dt
    vp = np.pad(v, 1, mode="edge")
    lap = vp[2:, 1:-1] + vp[:-2, 1:-1] + vp[1:-1, 2:] + vp[1:-1, :-2] - 4 * v
    dv = h * v**2 * (1 - v) / tin - v / tout + D * lap / dx**2
    if t < 2.0: dv[S1] += 0.2
    if 380.0 <= t < 382.0: dv[S2] += 0.2
    dh = np.where(v < vgate, (1 - h) / topen, -h / tclose)
    v = v + dt * dv; h = h + dt * dh
    spur.append(v[i0, i0])
spur = np.array(spur); ts = dt * np.arange(1, len(spur) + 1)
akt = ts[1:][(spur[1:] > 0.5) & (spur[:-1] <= 0.5)]                 # v rises above 0.5
auf = ts[1:][(spur[1:] > 0.1) & (spur[:-1] <= 0.1)]; ab = ts[1:][(spur[1:] < 0.1) & (spur[:-1] >= 0.1)]
apd = ab[:len(auf)] - auf[:len(ab)]; di = auf[1:] - ab[:len(auf) - 1]
print("Intervals between the action potentials (ms):", np.round(np.diff(akt), 1))
print(f"from the 4th interval on: mean {np.diff(akt)[3:].mean():.0f} ms,  mean APD {apd[4:].mean():.0f} ms,  mean DI {di[4:].mean():.0f} ms")
plt.figure(figsize=(9, 4))
plt.plot(ts, spur, color=(0.64, 0.08, 0.18), lw=1.5)
plt.xlabel("t (ms)"); plt.ylabel("v at (25, 25) mm")
plt.show()
