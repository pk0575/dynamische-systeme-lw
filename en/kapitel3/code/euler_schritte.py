# Fig. 3.20: Euler's method follows the slope of the direction field (book, Section 3.4, Eq. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80, step size h = 20:  T_{n+1} = T_n + h · 0.03 (5 - T_n)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k, Tu, T0, h = 0.03, 5, 80, 20
N = 6
t = h * np.arange(N + 1)
T = np.zeros(N + 1); T[0] = T0
for n in range(N):
    T[n + 1] = T[n] + h * k * (Tu - T[n])
tt = np.linspace(0, 120, 300)
plt.plot(tt, Tu + (T0 - Tu) * np.exp(-k * tt), color=(0.43, 0.04, 0.12), lw=2, label="exact solution T(t)")
plt.plot(t, T, color=(0.2, 0.6, 0.25), lw=2, label="Tangent segments")
plt.plot(t, T, "o", color=(0.89, 0.44, 0.49), ms=9, label="Euler T_n, h = 20")
for n in range(N + 1):
    print(f"t = {t[n]:5.0f}: T_n = {T[n]:6.2f},  exact {Tu + (T0 - Tu) * np.exp(-k * t[n]):6.2f}")
plt.xticks(t); plt.xlabel("t (min)"); plt.ylabel("T (°C)"); plt.legend()
plt.show()
