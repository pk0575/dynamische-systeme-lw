# Abb. 3.4: Abkühlung eines Gerichts im Kühlschrank (Buch, Abschnitt 3.1, Gl. 3.3 und 3.12)
# dT/dt = k (T^u - T) mit k = 0.03 pro Minute, T^u = 5 °C, T(0) = 80 °C:  T(t) = 75 e^(-0.03 t) + 5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k, Tu, T0 = 0.03, 5, 80
t = np.linspace(0, 180, 400)
T = Tu + (T0 - Tu) * np.exp(-k * t)
ts = np.log((T0 - Tu) / (10 - Tu)) / k                   # Zeitpunkt, zu dem T = 10 °C erreicht ist
print(f"T = 10 °C nach t = ln(15)/k = {ts:.1f} min")
plt.plot(t, T, color=(0.64, 0.08, 0.18), lw=2.5, label="T(t)")
plt.axhline(Tu, color="k", ls="--", lw=1)
plt.plot([ts, ts], [0, 10], ":", color="0.5"); plt.plot(ts, 10, "ko")
plt.xlabel("t (min)"); plt.ylabel("T (°C)"); plt.legend()
plt.show()
