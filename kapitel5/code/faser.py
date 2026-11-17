# Abb. 5.2: Ein Puls auf der Faser (Buch, Abschnitt 5.2, Gl. 5.2)
# Kabelgleichung mit dem Mitchell-Schaeffer-Modell, Faser 150 mm, Reiz am linken Ende; Linienmethode mit dem Euler-Verfahren
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # Parameter in ms
D, dx, dt = 0.1, 0.1, 0.01                                           # D in mm^2/ms, Gitterabstand in mm, Zeitschritt in ms
L, T = 150.0, 500.0
N = int(round(L / dx)) + 1; x = dx * np.arange(N)
v = np.zeros(N); h = np.ones(N)
reiz = x <= 1.0                                                      # Reiz J = 0.2 auf dem ersten Millimeter für 2 ms
schnapp = {}; s25, s75 = [], []; t_akt = np.full(N, np.nan)
for n in range(int(round(T / dt))):
    t = n * dt
    if round(t, 6) in (100.0, 250.0, 400.0): schnapp[round(t)] = v.copy()
    lap = np.empty(N)
    lap[1:-1] = v[2:] - 2 * v[1:-1] + v[:-2]
    lap[0] = v[1] - v[0]; lap[-1] = v[-2] - v[-1]                    # Rand ohne Fluss
    dv = h * v**2 * (1 - v) / tin - v / tout + D * lap / dx**2
    if t < 2.0: dv[reiz] += 0.2
    dh = np.where(v < vgate, (1 - h) / topen, -h / tclose)
    v = v + dt * dv; h = h + dt * dh
    neu = np.isnan(t_akt) & (v > 0.5); t_akt[neu] = t + dt           # Zeitpunkt, an dem v erstmals 0.5 erreicht
    s25.append(v[250]); s75.append(v[750])
i25, i75 = 250, 750
c = (x[i75] - x[i25]) / (t_akt[i75] - t_akt[i25])
ts = dt * np.arange(1, len(s75) + 1); s75 = np.array(s75); a = ts[s75 > 0.1]
apd = a[-1] - a[0]
print(f"v = 0.5 bei x = 25 mm nach {t_akt[i25]:.1f} ms, bei x = 75 mm nach {t_akt[i75]:.1f} ms")
print(f"Leitungsgeschwindigkeit c = {c:.4f} mm/ms,  APD = {apd:.1f} ms,  Wellenlänge c APD = {c * apd:.1f} mm")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for tz, farbe in zip((100, 250, 400), [(0.89, 0.44, 0.49), (0.64, 0.08, 0.18), (0.43, 0.04, 0.12)]):
    axs[0].plot(x, schnapp[tz], color=farbe, lw=2, label=f"t = {tz} ms")
axs[0].set_xlabel("x (mm)"); axs[0].set_ylabel("v(x, t)"); axs[0].legend()
axs[1].plot(ts, s25, color=(0.43, 0.04, 0.12), lw=2, label="x = 25 mm")
axs[1].plot(ts, s75, color=(0.89, 0.44, 0.49), lw=2, label="x = 75 mm")
axs[1].set_xlabel("t (ms)"); axs[1].set_ylabel("v(x, t)"); axs[1].legend()
plt.tight_layout()
plt.show()
