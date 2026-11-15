# Abb. 3.25: Restitutionskurve des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.33)
# Formel r_MS(DI), simulierte S1-S2-Messung (drei S1-Reize im Abstand von 400 ms, dann S2 nach der Pause DI) und r(DI) aus Kapitel 1
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
he = h[np.searchsorted(t, d[1])]                          # h am Ende des Aktionspotentials
Delta = apd - tclose * np.log(1 / hc)
r_ms = lambda DI: Delta + tclose * np.log((1 - (1 - he) * np.exp(-DI / topen)) / hc)
r_k1 = lambda DI: 220 - 180 * np.exp(-DI / 60)
t, v, _ = simuliere(1250, [0, 400, 800])
ende = [s for s in durchgaenge(t, v) if s > 805][0]       # Ende des dritten Aktionspotentials
DIs = [10, 20, 40, 60, 80, 100, 150, 200, 250, 300]; sim = []
for DI in DIs:
    s2 = ende + DI
    t, v, _ = simuliere(s2 + 400, [0, 400, 800, s2])
    d = [s for s in durchgaenge(t, v) if s > s2 - 1]
    sim.append(d[1] - d[0])
print(f"h_e = {he:.4f},  Delta = {Delta:.2f} ms")
print("DI:        ", "  ".join(f"{x:5d}" for x in DIs))
print("Simulation:", "  ".join(f"{x:5.1f}" for x in sim))
print("Formel:    ", "  ".join(f"{r_ms(x):5.1f}" for x in DIs))
DI = np.linspace(4.8, 300, 400)
plt.plot(DI, r_ms(DI), color=(0, 0.447, 0.741), lw=2.5, label="r_MS(DI)")
plt.plot(DI, r_k1(DI), color=(0.45, 0.70, 0.90), lw=2, label="r(DI) aus Kapitel 1")
plt.plot(DIs, sim, "ko", label="S1-S2-Simulation")
plt.xlabel("DI (ms)"); plt.ylabel("APD (ms)"); plt.ylim(40, 235); plt.legend(loc="lower right")
plt.show()
