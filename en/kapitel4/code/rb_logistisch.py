# Fig. 4.2: Continuous predator-prey model (book, Section 4.1, Eq. 4.2)
# dx/dt = r (1 - x/K) x - c x y,  dy/dt = d x y - e y  with r = 1, K = 10, c = 0.5, d = 0.2, e = 1, x(0) = 8, y(0) = 0.5
# left time courses, right the same solution in the phase plane
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r, K, c, d, e = 1, 10, 0.5, 0.2, 1
f = lambda t, z: [r * (1 - z[0] / K) * z[0] - c * z[0] * z[1], d * z[0] * z[1] - e * z[1]]

t = np.linspace(0, 40, 2001)
s = solve_ivp(f, [0, 40], [8, 0.5], t_eval=t, rtol=1e-9, atol=1e-11)
x, y = s.y
for tt in [10, 20, 40]:
    i = np.searchsorted(t, tt)
    print(f"t = {tt:2d}: x = {x[i]:.3f},  y = {y[i]:.3f}")
print(f"steady state (e/d, r/c (1 - e/(d K))) = ({e / d:g}, {r / c * (1 - e / (d * K)):g})")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
axs[0].plot(t, x, color=(0.43, 0.04, 0.12), lw=2, label="Prey x(t)")
axs[0].plot(t, y, color=(0.89, 0.44, 0.49), lw=2, label="Predators y(t)")
axs[0].set_xlabel("t"); axs[0].legend()
axs[1].plot(x, y, color=(0.64, 0.08, 0.18), lw=2); axs[1].plot(x[0], y[0], "ko"); axs[1].plot(5, 1, "ko")
axs[1].set_xlabel("Prey x"); axs[1].set_ylabel("Predators y")
plt.tight_layout()
plt.show()
