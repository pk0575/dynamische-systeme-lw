# Fig. 3.23: Fast dynamics of the Mitchell-Schaeffer model (book, Section 3.5, Eq. 3.29 and 3.31)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) with fixed h = 1; left f(v) with rest, threshold, and excited state,
# right response to a 2 ms stimulus below (J = 0.02) and above (J = 0.04) the threshold
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # parameters in ms
hc = 4 * tin / tout

def simuliere(T, reize, J=0.2, dauer=2.0, dt=0.01, h_fest=None):
    """Euler method for the Mitchell-Schaeffer model; stimulus current J for 'dauer' ms from each time in 'reize'."""
    N = int(round(T / dt)); t = dt * np.arange(N + 1)
    Jt = np.zeros(N + 1)
    for s in reize:
        Jt[(t >= s - 1e-9) & (t < s + dauer - 1e-9)] = J
    v = np.zeros(N + 1); h = np.ones(N + 1)
    for n in range(N):
        dv = h[n] * v[n]**2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
        if h_fest is not None: dh = 0.0
        elif v[n] < vgate: dh = (1 - h[n]) / topen
        else: dh = -h[n] / tclose
        v[n + 1] = v[n] + dt * dv; h[n + 1] = h[n] + dt * dh
    return t, v, h

def durchgaenge(t, v, schwelle=0.1):
    """times at which v crosses the threshold upward or downward (start and end of an action potential)."""
    i = np.where(np.diff(np.sign(v - schwelle)) != 0)[0]
    return t[i]

f = lambda v: v**2 * (1 - v) / tin - v / tout
w = np.sqrt(1 - hc); vs, ve = (1 - w) / 2, (1 + w) / 2       # threshold and excited state
print(f"h_c = {hc:.2f},  threshold v_s* = {vs:.4f},  excited v_e* = {ve:.4f}")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
v = np.linspace(-0.05, 1.05, 500)
axs[0].plot(v, f(v), color=(0, 0.447, 0.741), lw=2.5, label="f(v), h = 1"); axs[0].axhline(0, color="k", lw=1)
axs[0].plot([0, ve], [0, 0], "ko", ms=9); axs[0].plot(vs, 0, "o", mfc="w", mec="k", ms=9)
axs[0].set_xlabel("v"); axs[0].legend(loc="upper left")
for J, farbe in [(0.02, (0.89, 0.44, 0.49)), (0.04, (0.43, 0.04, 0.12))]:
    t, v, _ = simuliere(15, [1.0], J=J, h_fest=1.0)
    axs[1].plot(t, v, color=farbe, lw=2, label=f"J = {J}")
    print(f"J = {J}: v(15) = {v[-1]:.3f}")
axs[1].axhline(vs, color="0.4", ls=":"); axs[1].axvspan(1, 3, color="0.88")
axs[1].set_xlabel("t (ms)"); axs[1].set_ylabel("v(t)"); axs[1].legend(loc="center right")
plt.tight_layout()
plt.show()
