# Fig. 5.5: Formation of a spiral wave (book, Section 5.4, Eq. 5.6)
# square 100 mm x 100 mm, stimulus S1 at the left edge at t = 0, stimulus S2 in the lower half at t = 380 ms
# The computation takes about one minute.
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # parameters in ms
D, dx, dt, Lq = 0.1, 0.25, 0.05, 100.0                               # mm^2/ms, mm, ms, side length in mm
N = int(round(Lq / dx)); xs = dx * (np.arange(N) + 0.5)
X, Y = np.meshgrid(xs, xs, indexing="ij")                            # first index: x, second index: y
S1, S2 = X <= 1.0, Y <= Lq / 2
v = np.zeros((N, N)); h = np.ones((N, N))
zeiten = (100, 300, 390, 450, 550, 650, 800, 1000, 1200); bilder = {}
for n in range(int(round(1200 / dt)) + 1):
    t = n * dt
    if round(t, 6) in zeiten: bilder[round(t)] = v.copy()
    vp = np.pad(v, 1, mode="edge")                                   # no flux across the boundary
    lap = vp[2:, 1:-1] + vp[:-2, 1:-1] + vp[1:-1, 2:] + vp[1:-1, :-2] - 4 * v
    dv = h * v**2 * (1 - v) / tin - v / tout + D * lap / dx**2
    if t < 2.0: dv[S1] += 0.2                                        # stimulus S1
    if 380.0 <= t < 382.0: dv[S2] += 0.2                             # stimulus S2
    dh = np.where(v < vgate, (1 - h) / topen, -h / tclose)
    v = v + dt * dv; h = h + dt * dh
for tz in zeiten:
    print(f"t = {tz:4d} ms: fraction excited (v > 0.5) = {(bilder[tz] > 0.5).mean():.3f}")
fig, axs = plt.subplots(3, 3, figsize=(10, 10), sharex=True, sharey=True)
for ax, tz in zip(axs.flat, zeiten):
    ax.imshow(bilder[tz].T, origin="lower", extent=(0, Lq, 0, Lq), cmap="Reds", vmin=0, vmax=1)
    ax.set_title(f"t = {tz} ms")
plt.tight_layout()
plt.show()
