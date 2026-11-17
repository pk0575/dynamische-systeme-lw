# Fig. 4.7: Euler's method for the Lotka-Volterra model (book, Section 4.1, Eq. 4.7)
# x_{n+1} = x_n + h (r x_n - c x_n y_n),  y_{n+1} = y_n + h (d x_n y_n - e y_n)  with h = 0.1; the exact orbit is closed
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r, c, d, e = 1, 0.5, 0.2, 1
f = lambda t, z: [r * z[0] - c * z[0] * z[1], d * z[0] * z[1] - e * z[1]]
h, N = 0.1, 160
x = np.zeros(N + 1); y = np.zeros(N + 1); x[0], y[0] = 3, 2
for n in range(N):
    x[n + 1] = x[n] + h * (r * x[n] - c * x[n] * y[n])
    y[n + 1] = y[n] + h * (d * x[n] * y[n] - e * y[n])
s = solve_ivp(f, [0, 6.5], [3, 2], t_eval=np.linspace(0, 6.5, 651), rtol=1e-9, atol=1e-11)
H = lambda x, y: d * x - e * np.log(x) + c * y - r * np.log(y)
print(f"H exact (constant): {H(3, 2):.4f}")
print("H Euler after 40, 80, 160 steps:", "  ".join(f"{H(x[n], y[n]):.4f}" for n in [40, 80, 160]))
plt.plot(x, y, "-o", color=(0.89, 0.44, 0.49), ms=3, lw=1, label="Euler, h = 0.1")
plt.plot(s.y[0], s.y[1], color=(0.43, 0.04, 0.12), lw=2.5, label="exact")
plt.plot([3, 5], [2, 2], "ko")
plt.xlabel("Prey x"); plt.ylabel("Predators y"); plt.legend()
plt.show()
