# Abb. 5.6: Eine Rhythmusstörung im Modell (Buch, Abschnitt 5.4, Gl. 5.6)
# wie Abb. 5.5 bis t = 3000 ms; Verlauf von v im Punkt (25, 25) mm, Abstände, Dauer und diastolische Intervalle der Aktionspotentiale
# Die Rechnung dauert etwa drei Minuten.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # Parameter in ms
D, dx, dt, Lq = 0.1, 0.25, 0.05, 100.0                               # mm^2/ms, mm, ms, Seitenlänge in mm
N = int(round(Lq / dx)); xs = dx * (np.arange(N) + 0.5)
X, Y = np.meshgrid(xs, xs, indexing="ij")
S1, S2 = X <= 1.0, Y <= Lq / 2
i0 = int(25 / dx)                                                    # Gitterpunkt bei (25, 25) mm
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
akt = ts[1:][(spur[1:] > 0.5) & (spur[:-1] <= 0.5)]                 # v steigt über 0.5
auf = ts[1:][(spur[1:] > 0.1) & (spur[:-1] <= 0.1)]; ab = ts[1:][(spur[1:] < 0.1) & (spur[:-1] >= 0.1)]
apd = ab[:len(auf)] - auf[:len(ab)]; di = auf[1:] - ab[:len(auf) - 1]
print("Abstände der Aktionspotentiale (ms):", np.round(np.diff(akt), 1))
print(f"ab dem 4. Abstand: Mittel {np.diff(akt)[3:].mean():.0f} ms,  APD im Mittel {apd[4:].mean():.0f} ms,  DI im Mittel {di[4:].mean():.0f} ms")
plt.figure(figsize=(9, 4))
plt.plot(ts, spur, color=(0.64, 0.08, 0.18), lw=1.5)
plt.xlabel("t (ms)"); plt.ylabel("v bei (25, 25) mm")
plt.show()
