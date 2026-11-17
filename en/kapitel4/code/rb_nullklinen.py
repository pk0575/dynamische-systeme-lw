# Fig. 4.17: Nullclines of the predator-prey model (book, Section 4.4, Eq. 4.2)
# x-nullclines: x = 0 and y = (r/c)(1 - x/K);  y-nullclines: y = 0 and x = e/d;  plus direction field and solution
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r, K, c, d, e = 1, 10, 0.5, 0.2, 1
f = lambda t, z: [r * (1 - z[0] / K) * z[0] - c * z[0] * z[1], d * z[0] * z[1] - e * z[1]]

X, Y = np.meshgrid(np.linspace(0.4, 10.6, 18), np.linspace(0.15, 2.85, 10))
U, V = f(0, [X, Y]); U, V = U / 11, V / 3; L = np.hypot(U, V)
plt.quiver(X, Y, U / L * 0.3, V / L * 0.3 * 3 / 11, color=(0.2, 0.6, 0.25), angles="xy", scale_units="xy", scale=1, width=0.0025)
xs = np.linspace(0, 10, 50)
plt.plot(xs, r / c * (1 - xs / K), color=(0, 0.447, 0.741), lw=3, label="dx/dt = 0")
plt.plot([0, 0], [0, 3], color=(0, 0.447, 0.741), lw=3)
plt.plot([e / d, e / d], [0, 3], color=(0.45, 0.70, 0.90), lw=3, label="dy/dt = 0")
plt.plot([0, 11], [0, 0], color=(0.45, 0.70, 0.90), lw=3)
s = solve_ivp(f, [0, 40], [8, 0.5], t_eval=np.linspace(0, 40, 2001), rtol=1e-9, atol=1e-11)
plt.plot(s.y[0], s.y[1], color=(0.64, 0.08, 0.18), lw=2)
# Jacobian matrix at the coexistence state (5, 1) and its eigenvalues
xs_, ys_ = e / d, r / c * (1 - e / (d * K))
J = np.array([[r * (1 - 2 * xs_ / K) - c * ys_, -c * xs_], [d * ys_, d * xs_ - e]])
lam = np.linalg.eigvals(J)
print(f"coexistence ({xs_:g}, {ys_:g}): trace {np.trace(J):g}, det {np.linalg.det(J):g}, eigenvalues",
      "  ".join(f"{l.real:.3f}{l.imag:+.3f}i" for l in sorted(lam, key=lambda l: (l.imag, l.real))))
plt.plot([0, 10], [0, 0], "o", mfc="w", mec="k", ms=9, clip_on=False); plt.plot(5, 1, "ko", ms=9)
plt.xlim(0, 11); plt.ylim(0, 3); plt.xlabel("Prey x"); plt.ylabel("Predators y"); plt.legend(loc="upper right")
plt.show()
