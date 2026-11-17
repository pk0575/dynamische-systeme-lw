# Fig. 1.29: Steady states of the logistic model and their stability (book, Section 1.4, Eq. 1.35)
# y*_alpha = 0 and y*_beta = 1 - 1/a (solid stable, dashed unstable) with the bifurcation diagram
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

blau = (0, 0.447, 0.741)
a = np.linspace(3.0, 4.0, 1001)          # bifurcation diagram (light green) for 3 <= a <= 4
y = np.full_like(a, 0.5)
for _ in range(2000):
    y = a * y * (1 - y)
for _ in range(300):
    y = a * y * (1 - y)
    plt.plot(a, y, ",", color=(0.47, 0.71, 0.47))

plt.plot([0, 1], [0, 0], color=blau); plt.plot([1, 4], [0, 0], "--", color=blau)        # y*_alpha = 0
for lo, hi, ls in [(0.8, 1, "--"), (1, 3, "-"), (3, 4, "--")]:                           # y*_beta = 1 - 1/a
    aa = np.linspace(lo, hi, 200)
    plt.plot(aa, 1 - 1 / aa, ls, color=blau)
for aw in (1, 3):
    plt.axvline(aw, color="0.6", ls=":")
print("f'(y) = a (1 - 2y):  f'(0) = a, f'(1 - 1/a) = 2 - a")
print("y*_alpha stable for a < 1, y*_beta stable for 1 < a < 3")
plt.xlim(0, 4); plt.ylim(-0.25, 1.05)
plt.xlabel("a"); plt.ylabel("y")
plt.show()
