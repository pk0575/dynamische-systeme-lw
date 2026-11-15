# Abb. 3.23: schnelle Dynamik des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.31)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) mit festem h = 1; links f(v) mit Ruhe, Schwelle und erregtem Zustand,
# rechts Antwort auf einen Reiz der Dauer 2 ms unter (J = 0.02) und über (J = 0.04) der Schwelle
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

f = lambda v: v**2 * (1 - v) / tin - v / tout
w = np.sqrt(1 - hc); vs, ve = (1 - w) / 2, (1 + w) / 2       # Schwelle und erregter Zustand
print(f"h_c = {hc:.2f},  Schwelle v_s* = {vs:.4f},  erregt v_e* = {ve:.4f}")
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
