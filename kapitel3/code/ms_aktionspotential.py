# Abb. 3.24: Aktionspotential des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.30)
# Reiz bei t = 0; links v(t) und h(t), rechts stationäre Zustände von v in Abhängigkeit von h und der Weg des Aktionspotentials
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # Parameter in ms
hc = 4 * tin / tout

def simuliere(T, reize, J=0.2, dauer=2.0, dt=0.01, h_fest=None):
    """Euler-Verfahren für das Mitchell-Schaeffer-Modell; Reizstrom J für 'dauer' ms ab jedem Zeitpunkt in 'reize'."""
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
    """Zeitpunkte, zu denen v die Schwelle über- oder unterschreitet (Beginn und Ende eines Aktionspotentials)."""
    i = np.where(np.diff(np.sign(v - schwelle)) != 0)[0]
    return t[i]

t, v, h = simuliere(500, [0.0])
d = durchgaenge(t, v); apd = d[1] - d[0]
tf = tclose * np.log(1 / hc)
print(f"APD = {apd:.1f} ms,  h = h_c nach tclose ln(1/h_c) = {tf:.1f} ms")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
axs[0].plot(t, v, color=(0.43, 0.04, 0.12), lw=2, label="v(t)")
axs[0].plot(t, h, color=(0.89, 0.44, 0.49), lw=2, label="h(t)")
axs[0].axhline(hc, color="0.4", ls=":"); axs[0].axvline(tf, color="0.4", ls="-.")
axs[0].set_xlabel("t (ms)"); axs[0].legend()
gruen = (0, 0.39, 0)
H = np.linspace(hc, 1.05, 400); W = np.sqrt(1 - hc / H)
axs[1].plot(H, (1 + W) / 2, color=gruen, lw=2.5, label="stabil")
axs[1].plot(H, (1 - W) / 2, "--", color=gruen, lw=2.5, label="instabil")
axs[1].plot([0, 1.05], [0, 0], color=gruen, lw=2.5)
axs[1].plot(h, v, color=(0.64, 0.08, 0.18), lw=1.5, label="Aktionspotential")
axs[1].set_xlabel("h"); axs[1].set_ylabel("v*"); axs[1].legend(loc="center right")
plt.tight_layout()
plt.show()
