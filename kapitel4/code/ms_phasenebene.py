# Abb. 4.24: Phasenebene des Mitchell-Schaeffer-Modells (Buch, Abschnitt 4.5, Gl. 4.20)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J0,  dh/dt = (1 - h)/topen für v < vgate, -h/tclose sonst;  J0 = 0
# Nullklinen, Richtungsfeld, Ruhezustand (1, 0), Schwelle und das Aktionspotential nach einem Reiz bei t = 1 ms
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # Parameter in ms
hc = 4 * tin / tout

def simuliere(T, J0=0.0, reize=(), J=0.2, dauer=2.0, dt=0.01):
    """Euler-Verfahren für das Mitchell-Schaeffer-Modell mit konstantem Strom J0 und Reizen der Stärke J."""
    N = int(round(T / dt)); t = dt * np.arange(N + 1)
    Jt = np.full(N + 1, J0)
    for s in reize:
        Jt[(t >= s - 1e-9) & (t < s + dauer - 1e-9)] += J
    v = np.zeros(N + 1); h = np.ones(N + 1)
    for n in range(N):
        dv = h[n] * v[n]**2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
        dh = (1 - h[n]) / topen if v[n] < vgate else -h[n] / tclose
        v[n + 1] = v[n] + dt * dv; h[n + 1] = h[n] + dt * dh
    return t, v, h

def nullklinen(ax, J0):
    v = np.linspace(0.003, 0.997, 2000)
    H = (v / tout - J0) / (v**2 * (1 - v) / tin)          # dv/dt = 0 nach h aufgelöst
    m = (H >= -0.05) & (H <= 1.1)
    ax.plot(H[m], v[m], color=(0, 0.447, 0.741), lw=2.5, label="dv/dt = 0")
    if J0 == 0: ax.plot([-0.05, 1.1], [0, 0], color=(0, 0.447, 0.741), lw=2.5)
    ax.plot([1, 1], [-0.05, vgate], color=(0.45, 0.70, 0.90), lw=2.5, label="dh/dt = 0")
    ax.plot([0, 0], [vgate, 1.05], color=(0.45, 0.70, 0.90), lw=2.5)

def feld(ax, J0):
    hg, vg = np.meshgrid(np.linspace(0.05, 1.05, 12), np.linspace(0.05, 1.0, 11))
    dv = hg * vg**2 * (1 - vg) / tin - vg / tout + J0
    dh = np.where(vg < vgate, (1 - hg) / topen, -hg / tclose)
    L = np.hypot(dh, dv)
    ax.quiver(hg, vg, dh / L, dv / L, color=(0.2, 0.6, 0.25), angles="xy", scale_units="xy", scale=22, width=0.004)

t, v, h = simuliere(500, reize=[1.0])
vs = (1 - np.sqrt(1 - hc)) / 2
print(f"Ruhezustand (h, v) = (1, 0),  Schwelle (1, {vs:.4f}),  Spitze des Aktionspotentials v = {v.max():.4f}")
print(f"nach 500 ms: (h, v) = ({h[-1]:.4f}, {v[-1]:.4f})")
fig, ax = plt.subplots()
feld(ax, 0); nullklinen(ax, 0)
ax.plot(h, v, color=(0.64, 0.08, 0.18), lw=2, label="Aktionspotential")
ax.plot(1, 0, "ko", ms=9); ax.plot(1, vs, "o", mfc="w", mec="k", ms=9)
ax.set_xlim(-0.05, 1.1); ax.set_ylim(-0.05, 1.05); ax.set_xlabel("h"); ax.set_ylabel("v"); ax.legend(loc="center right")
plt.show()
