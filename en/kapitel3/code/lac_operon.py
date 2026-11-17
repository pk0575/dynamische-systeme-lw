# Fig. 3.18: Gene switch of the lac operon (book, Section 3.3, Eq. 3.23)
# dX/dt = (a + X^2)/(1 + X^2) - r X with a = 0.02; left import and degradation for r = 0.4, right X* as a function of r (hysteresis)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
a = 0.02
imp = lambda X: (a + X**2) / (1 + X**2)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
X = np.linspace(0, 3, 400)
r = 0.4
axs[0].plot(X, imp(X), color=(0, 0.447, 0.741), lw=2.5, label="Import (a + X²)/(1 + X²)")
axs[0].plot(X, r * X, "--", color=(0.64, 0.08, 0.18), lw=2, label="Degradation r X, r = 0.4")
# steady state: (a + X^2) = r X (1 + X^2), i.e. -r X^3 + X^2 - r X + a = 0
xs = np.sort(np.roots([-r, 1, -r, a]).real)
for i, x in enumerate(xs):
    axs[0].plot(x, r * x, "o", color="k", mfc="w" if i == 1 else "k", ms=9)
print("r = 0.4: X* =", "  ".join(f"{x:.3f}" for x in xs), " (off, threshold, on)")
axs[0].set_xlabel("X"); axs[0].legend(loc="upper left")
# bifurcation diagram: each X* belongs to r = Import(X*)/X*
Xs = np.linspace(0.005, 4, 4000); R = imp(Xs) / Xs
klein, gross = Xs < 0.5, (Xs > 0.5) & (Xs < 2)
i1 = np.argmin(np.where(klein, R, np.inf))              # turning points of the curve: smallest r on the lower branch,
i2 = np.argmax(np.where(gross, R, 0))                   # largest r on the middle branch
gruen = (0, 0.39, 0)
axs[1].plot(R[:i1], Xs[:i1], color=gruen, lw=3)
axs[1].plot(R[i1:i2], Xs[i1:i2], "--", color=gruen, lw=2)
axs[1].plot(R[i2:], Xs[i2:], color=gruen, lw=3)
print(f"bistable for {R[i1]:.2f} < r < {R[i2]:.2f}")
axs[1].set_xlim(0.1, 0.82); axs[1].set_ylim(-0.1, 3.2); axs[1].set_xlabel("Degradation rate r"); axs[1].set_ylabel("X*")
plt.tight_layout()
plt.show()
