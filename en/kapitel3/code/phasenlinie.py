# Fig. 3.14: Phase line of the logistic model (book, Section 3.3, Eq. 3.22)
# f(x) = r (1 - x/K) x with r = 0.55, K = 210; where f > 0, x grows (arrow to the right), where f < 0, x decreases
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.55, 210
f = lambda x: r * (1 - x / K) * x
df = lambda x: r * (1 - 2 * x / K)                      # derivative f'(x)
x = np.linspace(-30, 280, 400)
plt.plot(x, f(x), color=(0, 0.447, 0.741), lw=2.5, label="f(x) = r (1 - x/K) x")
plt.axhline(0, color="k", lw=1)
for a, b in [(20, 185), (275, 225), (-8, -28)]:         # phase line: direction of motion of x
    plt.annotate("", xy=(b, 0), xytext=(a, 0), arrowprops=dict(arrowstyle="-|>", color=(0.64, 0.08, 0.18), lw=2.5))
plt.plot(0, 0, "o", ms=11, mfc="w", mec="k", mew=2); plt.plot(K, 0, "ko", ms=11)
for xs in [0, K]:
    print(f"x* = {xs:3d}: f'(x*) = {df(xs):5.2f} ->", "stable" if df(xs) < 0 else "unstable")
plt.xlabel("x"); plt.legend()
plt.show()
