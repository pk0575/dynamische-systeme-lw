# Fig. 5.4: Circulating excitation on a ring (book, Section 5.3, Eq. 5.2)
# Initial state: piece of length L behind the front of a fiber stimulated at its end; L = 100 mm circulates, L = 65 mm dies out
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # parameters in ms
D, dx, dt = 0.1, 0.2, 0.02                                           # mm^2/ms, mm, ms

def euler(v, h, lap):
    dv = h * v**2 * (1 - v) / tin - v / tout + D * lap / dx**2
    dh = np.where(v < vgate, (1 - h) / topen, -h / tclose)
    return v + dt * dv, h + dt * dh

# stimulate a long fiber (250 mm) at the left until the front (v > 0.5) is at 200 mm
N = int(round(250 / dx)) + 1; x = dx * np.arange(N); vF = np.zeros(N); hF = np.ones(N); n = 0
while not (vF > 0.5).any() or x[vF > 0.5].max() < 200:
    lap = np.empty(N); lap[1:-1] = vF[2:] - 2 * vF[1:-1] + vF[:-2]; lap[0] = vF[1] - vF[0]; lap[-1] = vF[-2] - vF[-1]
    vF, hF = euler(vF, hF, lap)
    if n * dt < 2.0: vF[x <= 1.0] += dt * 0.2                        # stimulus J = 0.2 for 2 ms
    n += 1
iF = np.where(vF > 0.5)[0].max()

def ring(L, T, alle=10):
    """Ring of length L; returns v every 'alle' time steps and the times at which v reaches 0.5 at the middle of the ring."""
    M = int(round(L / dx)); v = vF[iF - M + 1:iF + 1].copy(); h = hF[iF - M + 1:iF + 1].copy()
    bild, akt, oben = [], [], False
    for k in range(int(round(T / dt))):
        if k % alle == 0: bild.append(v.copy())
        v, h = euler(v, h, np.roll(v, 1) - 2 * v + np.roll(v, -1))
        if v[M // 2] > 0.5 and not oben: akt.append((k + 1) * dt); oben = True
        if v[M // 2] < 0.1: oben = False
    return np.array(bild), np.array(akt), v.max()

fig, axs = plt.subplots(1, 2, figsize=(11, 4.5), sharey=True)
for ax, L in zip(axs, (100.0, 65.0)):
    B, akt, vmax = ring(L, 1500.0)
    print(f"L = {L:.0f} mm: round-trip times {np.round(np.diff(akt), 1)} ms, " + ("the excitation circulates" if vmax > 0.5 else "the excitation dies out"))
    ax.imshow(B, origin="lower", aspect="auto", extent=(0, L, 0, 1500), cmap="Reds", vmin=0, vmax=1)
    ax.set_title(f"L = {L:.0f} mm"); ax.set_xlabel("position on the ring (mm)")
axs[0].set_ylabel("t (ms)")
for L in range(66, 71):                                              # critical length
    B, akt, vmax = ring(float(L), 800.0, alle=10**9)
    print(f"L = {L} mm: " + ("circulates" if vmax > 0.5 else "dies out"))
plt.tight_layout()
plt.show()
