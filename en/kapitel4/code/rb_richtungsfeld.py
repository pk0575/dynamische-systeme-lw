# Fig. 4.3: Direction field of the predator-prey model (book, Section 4.1, Eq. 4.2)
# arrows in the direction (dx/dt, dy/dt), all of equal length; plus the solution from Fig. 4.2 and the steady states
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r, K, c, d, e = 1, 10, 0.5, 0.2, 1
f = lambda t, z: [r * (1 - z[0] / K) * z[0] - c * z[0] * z[1], d * z[0] * z[1] - e * z[1]]

X, Y = np.meshgrid(np.linspace(0.4, 10.6, 18), np.linspace(0.15, 2.85, 10))
U, V = f(0, [X, Y])
U, V = U / 11, V / 3                                     # relative to the axis lengths, so that all arrows in the plot have equal length
L = np.hypot(U, V)
plt.quiver(X, Y, U / L * 0.3, V / L * 0.3 * 3 / 11, color=(0.2, 0.6, 0.25), angles="xy", scale_units="xy", scale=1, width=0.003)
s = solve_ivp(f, [0, 40], [8, 0.5], t_eval=np.linspace(0, 40, 2001), rtol=1e-9, atol=1e-11)
plt.plot(s.y[0], s.y[1], color=(0.64, 0.08, 0.18), lw=2)
plt.plot([0, 10], [0, 0], "o", mfc="w", mec="k", ms=9, clip_on=False)      # unstable
plt.plot(5, 1, "ko", ms=9)                                                  # stable
for xs, ys in [(0, 0), (10, 0), (5, 1)]:
    print(f"({xs:2d}, {ys}): dx/dt = {f(0, [xs, ys])[0]:g}, dy/dt = {f(0, [xs, ys])[1]:g}")
plt.xlim(0, 11); plt.ylim(0, 3); plt.xlabel("Prey x"); plt.ylabel("Predators y")
plt.show()
