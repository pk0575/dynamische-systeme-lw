# Fig. 4.23: Membrane potential in the Noble model (book, Section 4.4, Eq. 4.19)
# Cm dV/dt = -(400 m^3 h + 0.14)(V - 40) - (1.2 e^((-V-90)/50) + 0.015 e^((V+90)/60) + 1.2 n^4)(V + 100) - gL (V - VL) + I(t), Cm = 12
# left pacemaker cell (gL = 0.075, VL = -60), right excitable cell (gL = 0.3, VL = -85) with stimuli every 700 ms; time in ms
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
def noble(gL, VL, reiz):
    def f(t, z):
        V, m, h, n = z
        am = 0.1 * (-V - 48) / (np.exp((-V - 48) / 15) - 1); bm = 0.12 * (V + 8) / (np.exp((V + 8) / 5) - 1)
        ah = 0.17 * np.exp((-V - 90) / 20); bh = 1 / (1 + np.exp((-V - 42) / 10))
        an = 0.0001 * (-V - 50) / (np.exp((-V - 50) / 10) - 1); bn = 0.002 * np.exp((-V - 90) / 80)
        iNa = (400 * m**3 * h + 0.14) * (V - 40)
        iK = (1.2 * np.exp((-V - 90) / 50) + 0.015 * np.exp((V + 90) / 60) + 1.2 * n**4) * (V + 100)
        I = 300.0 if reiz and (t % 700) < 2 else 0.0      # stimulus: 2 ms long every 700 ms
        return [(-(iNa + iK + gL * (V - VL)) + I) / 12, am * (1 - m) - bm * m, ah * (1 - h) - bh * h, an * (1 - n) - bn * n]
    return f
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5), sharey=True)
for ax, name, gL, VL, reiz, T0 in [(axs[0], "pacemaker", 0.075, -60, False, 2000), (axs[1], "stimulated", 0.3, -85, True, 0)]:
    T = T0 + 2100
    t = np.arange(0, T + 0.05, 0.1)
    s = solve_ivp(noble(gL, VL, reiz), [0, T], [-80, 0.02, 0.8, 0.05], t_eval=t, method="LSODA", max_step=0.25, rtol=1e-8, atol=1e-10)
    i = t >= T0; tt = (t[i] - T0) / 1000; V = s.y[0][i]
    hoch = tt[1:][(V[:-1] < 0) & (V[1:] >= 0)]           # times at which V reaches 0 mV from below
    print(f"{name}: V between {V.min():.0f} and {V.max():.0f} mV, {len(hoch)} action potentials in 2.1 s"
          + (f", period {np.mean(np.diff(hoch)):.2f} s" if len(hoch) > 1 else ""))
    ax.plot(tt, V, color=(0.64, 0.08, 0.18), lw=2); ax.set_title(name); ax.set_xlabel("t (s)")
axs[0].set_ylabel("Membrane potential V (mV)")
plt.tight_layout()
plt.show()
