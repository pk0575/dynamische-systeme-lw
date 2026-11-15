# Abb. 3.21: Euler-Verfahren für die Abkühlung mit verschiedenen Schrittweiten (Buch, Abschnitt 3.4, Gl. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80; Euler mit h = 10 und h = 5 im Vergleich zur exakten Lösung
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k, Tu, T0 = 0.03, 5, 80
exakt = lambda t: Tu + (T0 - Tu) * np.exp(-k * t)
tt = np.linspace(0, 120, 300)
plt.plot(tt, exakt(tt), color=(0.43, 0.04, 0.12), lw=2, label="exakt")
farben = [(0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, h in enumerate([10, 5]):
    N = int(120 / h)
    t = h * np.arange(N + 1); T = np.zeros(N + 1); T[0] = T0
    for n in range(N):
        T[n + 1] = T[n] + h * k * (Tu - T[n])
    plt.plot(t, T, "--" + "sd"[i], color=farben[i], ms=6, lw=1, label=f"Euler, h = {h}")
    print(f"h = {h:2d}: T(60) ≈ {T[int(60 / h)]:.3f},  Fehler {abs(T[int(60 / h)] - exakt(60)):.3f}")
plt.xlabel("t (min)"); plt.ylabel("T (°C)"); plt.legend()
plt.show()
