# Fig. 1.38: Action potentials under periodic stimulation (book, Section 1.6)
# Mitchell-Schaeffer model (two currents), Euler's method with dt = 0.01 ms, stimulus every PCL = 400 ms;
# measured is the time above the reference value 0.1 (action potential duration APD) and below it (diastolic interval DI)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13    # time constants in ms
PCL, T, dt, vref = 400.0, 2050.0, 0.01, 0.1

t = np.arange(0, T, dt)
v = np.zeros_like(t)
vv, h = 0.0, 1.0
for i in range(1, len(t)):
    J = 0.2 if (t[i] % PCL) < 2.0 else 0.0                       # stimulus: 2 ms long
    dv = h * vv**2 * (1 - vv) / tin - vv / tout + J
    dh = (1 - h) / topen if vv < vgate else -h / tclose
    vv += dt * dv
    h += dt * dh
    v[i] = vv

s = np.sign(v - vref)                                            # crossings of the reference value
kreuz = t[np.where(np.diff(s) != 0)[0]]
auf, ab = kreuz[0::2], kreuz[1::2]
for k in range(len(ab)):
    di = auf[k + 1] - ab[k] if k + 1 < len(auf) else float("nan")
    print(f"AP {k + 1}:  APD = {ab[k] - auf[k]:6.1f} ms,  DI = {di:6.1f} ms")

plt.plot(t, v, color=(0.64, 0.08, 0.18))
plt.axhline(vref, color="0.35", ls=":")
plt.xlabel("t (ms)"); plt.ylabel("v (dimensionless)")
plt.show()
