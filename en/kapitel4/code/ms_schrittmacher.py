# Fig. 4.25: Mitchell-Schaeffer model with pacemaker current (book, Section 4.5, Eq. 4.20)
# constant inward current J0 > J_c: left periodic action potentials for J0 = 0.0022 and 0.003,
# right the limit cycle for J0 = 0.0022 with the nullclines (there is no steady state anymore)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # parameters in ms
hc = 4 * tin / tout

def simuliere(T, J0=0.0, reize=(), J=0.2, dauer=2.0, dt=0.01):
    """Euler method for the Mitchell-Schaeffer model with constant current J0 and stimuli of strength J."""
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
    H = (v / tout - J0) / (v**2 * (1 - v) / tin)          # dv/dt = 0 solved for h
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

f = lambda v: v**2 * (1 - v) / tin - v / tout
vv = np.linspace(0, 0.2, 200001); Jc = -f(vv).min()
print(f"J_c = {Jc:.5f}")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for J0, farbe in [(0.0022, (0.43, 0.04, 0.12)), (0.003, (0.89, 0.44, 0.49))]:
    t, v, h = simuliere(3000, J0=J0)
    hoch = t[1:][(v[:-1] < 0.5) & (v[1:] >= 0.5)]          # start of each action potential
    print(f"J0 = {J0}: period {hoch[-1] - hoch[-2]:.0f} ms")
    m = t >= 400
    axs[0].plot(t[m] - 400, v[m], color=farbe, lw=2, label=f"J0 = {J0}")
    if J0 == 0.0022:
        m = t >= 1500
        feld(axs[1], J0); nullklinen(axs[1], J0)
        axs[1].plot(h[m], v[m], color=(0.64, 0.08, 0.18), lw=2, label="Limit cycle")
axs[0].set_xlim(0, 2000); axs[0].set_xlabel("t (ms)"); axs[0].set_ylabel("v(t)"); axs[0].legend(loc="upper right")
axs[1].set_xlim(-0.05, 1.1); axs[1].set_ylim(-0.05, 1.05); axs[1].set_xlabel("h"); axs[1].set_ylabel("v"); axs[1].legend(loc="center right")
plt.tight_layout()
plt.show()
