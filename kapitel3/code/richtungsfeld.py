# Abb. 3.5: Richtungsfeld der Abkühlung mit einigen Lösungen (Buch, Abschnitt 3.1, Gl. 3.3)
# In jedem Punkt (t, T) zeigt ein kurzer Strich die Steigung dT/dt = 0.03 (5 - T); die Lösungen folgen diesen Steigungen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k, Tu = 0.03, 5
f = lambda t, T: k * (Tu - T)
t, T = np.meshgrid(np.linspace(5, 175, 18), np.linspace(2, 88, 12))
S = f(t, T)
dt = 1 / np.sqrt(1 + (S * 180 / 90)**2) * 4             # Striche gleicher Länge im Bild (Achsen 180 min bzw. 90 °C)
plt.quiver(t, T, dt, S * dt, color=(0.2, 0.6, 0.25), angles="xy", scale_units="xy", scale=1, headwidth=0, headlength=0, headaxislength=0, pivot="mid", width=0.003)
tt = np.linspace(0, 180, 300)
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, T0 in enumerate([80, 40, 0]):
    plt.plot(tt, Tu + (T0 - Tu) * np.exp(-k * tt), color=rot[i], lw=2)
    print(f"T(0) = {T0:2d}: T(60) = {Tu + (T0 - Tu) * np.exp(-60 * k):.2f}")
plt.axhline(Tu, color="k", ls="--", lw=1)
plt.xlabel("t (min)"); plt.ylabel("T (°C)"); plt.xlim(0, 184); plt.ylim(-3, 92)
plt.show()
