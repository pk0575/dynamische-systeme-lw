# Fig. 1.16: Drug level with a daily dose (book, Section 1.2, Eq. 1.23)
# x_{n+1} = a x_n + b_n, b_n = d if n is divisible by 24, otherwise 0;  a = 0.99, d = 0.4, x_0 = 0, n in hours
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, d, x0 = 0.99, 0.4, 0.0
N = 504                                 # 21 days
x = np.zeros(N + 1)
x[0] = x0
for n in range(N):
    b = d if n % 24 == 0 else 0.0       # one dose every 24 hours
    x[n + 1] = a * x[n] + b

xmax = d / (1 - a**24)                  # limit of the peak values
print(f"x_max = {xmax:.4f}")
print(f"peak value after 20 days: x_481 = {x[481]:.4f}")

fig, axs = plt.subplots(2, 1, figsize=(8, 7))
for ax, ende in zip(axs, (73, N + 1)):
    ax.plot(np.arange(ende), x[:ende], "o--", color=(0.64, 0.08, 0.18), ms=3, lw=0.6)
    ax.axhline(xmax, color="k", lw=0.8)
    ax.set_xlabel("n (hours)"); ax.set_ylabel("x_n")
plt.tight_layout()
plt.show()
