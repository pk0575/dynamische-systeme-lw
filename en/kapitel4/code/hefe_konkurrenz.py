# Fig. 4.5: Competition between two yeast species (book, Section 4.1, Eq. 4.4)
# dx/dt = r1 (1 - x/K1 - g1 y) x,  dy/dt = r2 (1 - y/K2 - g2 x) y  with the parameters after Gause, x(0) = y(0) = 0.5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r1, K1, g1 = 0.0607, 5.8, 0.0757      # S. kephir
r2, K2, g2 = 0.2183, 13, 0.2423       # S. cerevisiae
f = lambda t, z: [r1 * (1 - z[0] / K1 - g1 * z[1]) * z[0], r2 * (1 - z[1] / K2 - g2 * z[0]) * z[1]]

t = np.linspace(0, 300, 3001)
s = solve_ivp(f, [0, 300], [0.5, 0.5], t_eval=t, rtol=1e-9, atol=1e-11)
x, y = s.y
for tt in [50, 100, 300]:
    i = np.searchsorted(t, tt)
    print(f"t = {tt:3d} h: x = {x[i]:.3f},  y = {y[i]:.3f}")
print(f"y reaches its maximum {y.max():.3f} at t = {t[y.argmax()]:.1f} h")
plt.plot(t, x, color=(0.43, 0.04, 0.12), lw=2, label="S. kephir x(t)")
plt.plot(t, y, color=(0.89, 0.44, 0.49), lw=2, label="S. cerevisiae y(t)")
plt.xlabel("t (hours)"); plt.ylabel("Yeast volume"); plt.legend()
plt.show()
