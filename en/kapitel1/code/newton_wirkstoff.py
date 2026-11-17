# Fig. 1.35: When does the drug level fall below 1 mg/l? (book, Section 1.5, Eq. 1.44)
# c(t) = 5 (exp(-0.2 t) - exp(-t)); Newton's method for g(t) = c(t) - 1 with initial value t_0 = 10 h
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

c = lambda t: 5 * (np.exp(-0.2 * t) - np.exp(-t))
dc = lambda t: 5 * (-0.2 * np.exp(-0.2 * t) + np.exp(-t))

t = [10.0]
for n in range(5):
    t.append(t[-1] - (c(t[-1]) - 1) / dc(t[-1]))
for n, v in enumerate(t):
    print(f"t_{n} = {v:.6f} h")

tt = np.linspace(0, 24, 500)
plt.plot(tt, c(tt), color=(0.64, 0.08, 0.18), label="c(t)")
plt.axhline(1, color="k", lw=0.8)
plt.plot(t[-1], 1, "ko")
plt.text(t[-1] + 0.5, 1.15, f"t* ≈ {t[-1]:.2f} h")
plt.xlim(0, 24); plt.ylim(0, 3)
plt.xlabel("Time t (h)"); plt.ylabel("c(t) (mg/l)"); plt.legend()
plt.show()
