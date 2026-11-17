# Fig. 3.13: Continuous and discrete-time logistic model (book, Section 3.2, Eq. 3.20)
# line: solution of dx/dt = r (1 - x/K) x;  points: x_{n+1} = x_n + r x_n (1 - x_n/K);  K = 210, x0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
K, x0 = 210, 0.2
fig, axs = plt.subplots(2, 2, figsize=(11, 7), sharex=True)
t = np.linspace(0, 30, 400)
for ax, r in zip(axs.flat, [0.55, 2.1, 2.6, 3.0]):
    ax.plot(t, x0 * K / (x0 + (K - x0) * np.exp(-r * t)), color=(0.43, 0.04, 0.12), lw=2)
    x = [x0]
    for n in range(30):
        x.append(x[n] + r * x[n] * (1 - x[n] / K))
    ax.plot(range(31), x, "--o", color=(0.89, 0.44, 0.49), ms=4, lw=1)
    ax.set_title(f"r = {r:g}"); ax.set_ylim(-10, 300)
    print(f"r = {r:g}: x_27 ... x_30 =", "  ".join(f"{v:.1f}" for v in x[27:]))
for ax in axs[1]: ax.set_xlabel("t or n")
plt.tight_layout()
plt.show()
