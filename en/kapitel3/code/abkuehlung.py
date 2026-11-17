# Fig. 3.4: Cooling of a dish in the refrigerator (book, Section 3.1, Eq. 3.3 and 3.12)
# dT/dt = k (T^u - T) with k = 0.03 per minute, T^u = 5 °C, T(0) = 80 °C:  T(t) = 75 e^(-0.03 t) + 5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k, Tu, T0 = 0.03, 5, 80
t = np.linspace(0, 180, 400)
T = Tu + (T0 - Tu) * np.exp(-k * t)
ts = np.log((T0 - Tu) / (10 - Tu)) / k                   # time at which T = 10 °C is reached
print(f"T = 10 °C after t = ln(15)/k = {ts:.1f} min")
plt.plot(t, T, color=(0.64, 0.08, 0.18), lw=2.5, label="T(t)")
plt.axhline(Tu, color="k", ls="--", lw=1)
plt.plot([ts, ts], [0, 10], ":", color="0.5"); plt.plot(ts, 10, "ko")
plt.xlabel("t (min)"); plt.ylabel("T (°C)"); plt.legend()
plt.show()
