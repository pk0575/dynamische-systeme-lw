// Browser apps for the website (no extra libraries). Each app is an element with data-app="…".
// Colors as in the book: sequences red, functions blue, reference lines black/gray.
(function () {
  var fmt = function (v, d) { return isFinite(v) ? v.toFixed(d) : '–'; };
  function farbe(name) { return getComputedStyle(document.documentElement).getPropertyValue(name).trim(); }

  // drawing area with axes; returns the conversions X(x), Y(y)
  function achsen(ctx, W, H, xb, yb, xl, yl, xt, yt) {
    var L = 70, R = 20, T = 18, B = 58;
    var X = function (x) { return L + (x - xb[0]) / (xb[1] - xb[0]) * (W - L - R); };
    var Y = function (y) { return H - B - (y - yb[0]) / (yb[1] - yb[0]) * (H - T - B); };
    ctx.clearRect(0, 0, W, H); ctx.fillStyle = farbe('--surface'); ctx.fillRect(0, 0, W, H);
    ctx.strokeStyle = farbe('--rule'); ctx.lineWidth = 1; ctx.font = '22px "IBM Plex Sans", sans-serif'; ctx.fillStyle = farbe('--muted');
    xt.forEach(function (t) { ctx.beginPath(); ctx.moveTo(X(t), Y(yb[0])); ctx.lineTo(X(t), Y(yb[1])); ctx.stroke();
      ctx.textAlign = 'center'; ctx.fillText(String(t), X(t), H - B + 28); });
    yt.forEach(function (t) { ctx.beginPath(); ctx.moveTo(X(xb[0]), Y(t)); ctx.lineTo(X(xb[1]), Y(t)); ctx.stroke();
      ctx.textAlign = 'right'; ctx.fillText(String(t), L - 10, Y(t) + 7); });
    ctx.textAlign = 'center'; ctx.fillText(xl, (L + W - R) / 2, H - 6);
    ctx.save(); ctx.translate(20, (T + H - B) / 2); ctx.rotate(-Math.PI / 2); ctx.fillText(yl, 0, 0); ctx.restore();
    return { X: X, Y: Y, xb: xb, yb: yb };
  }
  function linie(ctx, A, xs, ys, col, lw, gestrichelt) {
    ctx.save(); ctx.beginPath(); ctx.rect(A.X(A.xb[0]), A.Y(A.yb[1]), A.X(A.xb[1]) - A.X(A.xb[0]), A.Y(A.yb[0]) - A.Y(A.yb[1])); ctx.clip();
    ctx.strokeStyle = col; ctx.lineWidth = lw; if (gestrichelt) ctx.setLineDash([8, 6]);
    ctx.beginPath(); var an = false;
    for (var i = 0; i < xs.length; i++) {
      if (!isFinite(ys[i]) || Math.abs(ys[i]) > 1e6) { an = false; continue; }
      if (an) ctx.lineTo(A.X(xs[i]), A.Y(ys[i])); else { ctx.moveTo(A.X(xs[i]), A.Y(ys[i])); an = true; }
    }
    ctx.stroke(); ctx.restore();
  }
  function punkt(ctx, A, x, y, col, r, offen) {
    if (x < A.xb[0] || x > A.xb[1] || y < A.yb[0] || y > A.yb[1]) return;
    ctx.beginPath(); ctx.arc(A.X(x), A.Y(y), r, 0, 2 * Math.PI);
    if (offen) { ctx.fillStyle = farbe('--surface'); ctx.fill(); ctx.strokeStyle = col; ctx.lineWidth = 2; ctx.stroke(); }
    else { ctx.fillStyle = col; ctx.fill(); }
  }
  function regler(el, name) { return el.querySelector('[data-r="' + name + '"]'); }
  function wert(el, name) { var r = regler(el, name); return r ? +r.value : NaN; }
  function zeige(el, name, text) { var o = el.querySelector('[data-o="' + name + '"]'); if (o) o.textContent = text; }

  // ------------------------------------------------------------ staircase diagram (various functions)
  var FAMILIEN = {
    logistisch: { name: 'f(y) = a y (1 − y)', f: function (x, p) { return p * x * (1 - x); }, bereich: [0, 1], p: [0.5, 4, 0.01, 2.5], pname: 'a', x0: 0.1, ticks: [0, 0.25, 0.5, 0.75, 1] },
    heron: { name: 'f(x) = (x + c/x)/2', f: function (x, p) { return 0.5 * (x + p / x); }, bereich: [0, 4], p: [0.5, 9, 0.5, 2], pname: 'c', x0: 0.5, ticks: [0, 1, 2, 3, 4] },
    wurzel: { name: 'f(x) = √x', f: function (x) { return Math.sqrt(Math.max(x, 0)); }, bereich: [0, 1.5], p: null, x0: 0.5, ticks: [0, 0.5, 1, 1.5] },
    exp: { name: 'f(x) = e^(−c x)', f: function (x, p) { return Math.exp(-p * x); }, bereich: [0, 1], p: [0.5, 6, 0.1, 2], pname: 'c', x0: 0.2, ticks: [0, 0.25, 0.5, 0.75, 1] },
    kubisch: { name: 'f(x) = x − 2x(0,5 − x)(1 − x)', f: function (x) { return x - 2 * x * (0.5 - x) * (1 - x); }, bereich: [0, 1], p: null, x0: 0.6, ticks: [0, 0.25, 0.5, 0.75, 1] }
  };
  function fixpunkte(F, p) {
    var a = F.bereich[0] + 1e-9, b = F.bereich[1], n = 4000, pts = [];
    var g = function (x) { return F.f(x, p) - x; };
    var x1 = a, g1 = g(x1);
    if (Math.abs(g1) < 1e-12) pts.push(x1);
    for (var i = 1; i <= n; i++) {
      var x2 = a + (b - a) * i / n, g2 = g(x2);
      if (isFinite(g1) && isFinite(g2) && g1 * g2 < 0) {
        var lo = x1, hi = x2;
        for (var k = 0; k < 60; k++) { var m = (lo + hi) / 2; if (g(lo) * g(m) <= 0) hi = m; else lo = m; }
        pts.push((lo + hi) / 2);
      }
      x1 = x2; g1 = g2;
    }
    if (F.f(0, p) === 0 && pts.every(function (q) { return q > 1e-6; })) pts.unshift(0);
    return pts.map(function (q) { var e = 1e-6, d = (F.f(q + e, p) - F.f(Math.max(q - e, 0), p)) / (q - e < 0 ? e : 2 * e); return { x: q, d: d }; });
  }
  function treppe(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    var wahl = el.querySelector('select'), fest = el.dataset.familie;
    function lies() { return FAMILIEN[wahl ? wahl.value : fest]; }
    function passeAn(neu) {
      var F = lies(), rp = regler(el, 'p'), rx = regler(el, 'x0');
      var zeile = el.querySelector('[data-zeile="p"]');
      if (F.p) { zeile.hidden = false; rp.min = F.p[0]; rp.max = F.p[1]; rp.step = F.p[2]; if (neu) rp.value = F.p[3]; el.querySelector('[data-pname]').textContent = 'Parameter ' + F.pname; }
      else zeile.hidden = true;
      rx.min = F.bereich[0] + (F.bereich[1] - F.bereich[0]) * 0.01; rx.max = F.bereich[1] * 0.99; rx.step = (F.bereich[1] - F.bereich[0]) / 200;
      if (neu) rx.value = F.x0;
    }
    function male() {
      var F = lies(), p = wert(el, 'p'), x0 = wert(el, 'x0'), N = wert(el, 'n');
      zeige(el, 'p', fmt(p, 2)); zeige(el, 'x0', fmt(x0, 3)); zeige(el, 'n', String(N));
      var b = F.bereich, A = achsen(ctx, cv.width, cv.height, b, b, 'xₙ', 'xₙ₊₁', F.ticks, F.ticks);
      var xs = [], ys = [];
      for (var i = 0; i <= 300; i++) { var x = b[0] + (b[1] - b[0]) * i / 300; xs.push(x); ys.push(F.f(x, p)); }
      linie(ctx, A, [b[0], b[1]], [b[0], b[1]], farbe('--ink'), 1.5);
      linie(ctx, A, xs, ys, farbe('--blau'), 3.5);
      var folge = [x0], px = [x0], py = [b[0]], x = x0;
      for (var k = 0; k < N; k++) { var xn = F.f(x, p); px.push(x, xn); py.push(xn, xn); x = xn; folge.push(x); if (!isFinite(x)) break; }
      linie(ctx, A, px, py, farbe('--accent'), N > 60 ? 0.8 : 1.8);
      var fp = fixpunkte(F, p), txt = [];
      fp.forEach(function (q) { var st = Math.abs(q.d) < 1; punkt(ctx, A, q.x, q.x, '#000', 7, !st);
        txt.push('<b>' + fmt(q.x, 4) + '</b> (f′ = ' + fmt(q.d, 2) + ', ' + (st ? 'stable' : 'unstable') + ')'); });
      el.querySelector('.zustand').innerHTML = fp.length ? 'Steady states: ' + txt.join(', ') + '.' : 'No steady state in the range shown.';
      var start = Math.max(0, folge.length - 6);
      el.querySelector('.werte').textContent = folge.slice(start).map(function (v, i) { return 'x_' + (start + i) + ' = ' + fmt(v, 5); }).join('\n');
    }
    if (wahl) wahl.addEventListener('change', function () { passeAn(true); male(); });
    el.querySelectorAll('input[type=range]').forEach(function (r) { r.addEventListener('input', male); });
    passeAn(true); male(); return male;
  }

  // ------------------------------------------------------------ linear difference equation x_{n+1} = a x_n + b
  function linear(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    function male() {
      var a = wert(el, 'a'), b = wert(el, 'b'), x0 = wert(el, 'x0'), N = 20;
      zeige(el, 'a', fmt(a, 2)); zeige(el, 'b', fmt(b, 1)); zeige(el, 'x0', fmt(x0, 1));
      var x = [x0]; for (var k = 0; k < N; k++) x.push(a * x[k] + b);
      var lo = Math.min.apply(null, x.concat([0])), hi = Math.max.apply(null, x.concat([0]));
      lo = Math.max(lo, -200); hi = Math.min(hi, 200); if (hi - lo < 1) { hi += 1; lo -= 1; }
      var pad = (hi - lo) * 0.08, step = Math.pow(10, Math.floor(Math.log10((hi - lo) / 2))); var yt = [];
      for (var t = Math.ceil((lo - pad) / step) * step; t <= hi + pad; t += step) yt.push(+t.toFixed(6));
      if (yt.length > 8) yt = yt.filter(function (_, i) { return i % 2 === 0; });
      var A = achsen(ctx, cv.width, cv.height, [-0.5, N + 0.5], [lo - pad, hi + pad], 'n', 'xₙ', [0, 5, 10, 15, 20], yt);
      var stat = Math.abs(1 - a) > 1e-9 ? b / (1 - a) : NaN;
      if (isFinite(stat)) linie(ctx, A, [-0.5, N + 0.5], [stat, stat], farbe('--ink'), 1.2, true);
      var n = x.map(function (_, i) { return i; });
      linie(ctx, A, n, x, farbe('--accent'), 1.2, true);
      x.forEach(function (v, i) { punkt(ctx, A, i, v, farbe('--accent'), 5); });
      var art;
      if (a === 1) art = b === 0 ? 'The sequence is constant.' : 'Arithmetic sequence: at each step <b>' + fmt(b, 1) + '</b> is added.';
      else if (Math.abs(a) < 1) art = 'Because |a| &lt; 1 the sequence tends to the steady state <b>b/(1 − a) = ' + fmt(stat, 3) + '</b>' + (a < 0 ? ', alternately above and below.' : '.');
      else if (a === -1) art = 'The sequence jumps between two values.';
      else art = 'Because |a| &gt; 1 the sequence moves away from the steady state ' + fmt(stat, 3) + (a < 0 ? ' with growing oscillations.' : '.');
      el.querySelector('.zustand').innerHTML = art;
      el.querySelector('.werte').textContent = x.slice(-5).map(function (v, i) { return 'x_' + (N - 4 + i) + ' = ' + fmt(v, 4); }).join('\n');
    }
    el.querySelectorAll('input[type=range]').forEach(function (r) { r.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ Newton's method
  var NEWTON = {
    expo: { name: 'g(x) = e^(−5x) − x', g: function (x) { return Math.exp(-5 * x) - x; }, d: function (x) { return -5 * Math.exp(-5 * x) - 1; }, xb: [-0.1, 0.5], yb: [-0.5, 1.2], x0: 0.05, xt: [0, 0.1, 0.2, 0.3, 0.4, 0.5], yt: [-0.5, 0, 0.5, 1] },
    kubisch: { name: 'g(x) = x³ − 2x + 2', g: function (x) { return x * x * x - 2 * x + 2; }, d: function (x) { return 3 * x * x - 2; }, xb: [-2.5, 2], yb: [-3, 5], x0: 0, xt: [-2, -1, 0, 1, 2], yt: [-2, 0, 2, 4] },
    wurzel: { name: 'g(x) = x² − 2', g: function (x) { return x * x - 2; }, d: function (x) { return 2 * x; }, xb: [0, 4], yb: [-3, 8], x0: 0.5, xt: [0, 1, 2, 3, 4], yt: [-2, 0, 2, 4, 6, 8] },
    wirkstoff: { name: 'g(t) = 5(e^(−0,2t) − e^(−t)) − 1', g: function (t) { return 5 * (Math.exp(-0.2 * t) - Math.exp(-t)) - 1; }, d: function (t) { return 5 * (-0.2 * Math.exp(-0.2 * t) + Math.exp(-t)); }, xb: [0, 24], yb: [-1.5, 2], x0: 10, xt: [0, 4, 8, 12, 16, 20, 24], yt: [-1, 0, 1, 2] }
  };
  function newton(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d'), wahl = el.querySelector('select');
    function passeAn() { var G = NEWTON[wahl.value], r = regler(el, 'x0'); r.min = G.xb[0]; r.max = G.xb[1]; r.step = (G.xb[1] - G.xb[0]) / 400; r.value = G.x0; }
    function male() {
      var G = NEWTON[wahl.value], x0 = wert(el, 'x0'), N = wert(el, 'n');
      zeige(el, 'x0', fmt(x0, 3)); zeige(el, 'n', String(N));
      var A = achsen(ctx, cv.width, cv.height, G.xb, G.yb, 'x', 'g(x)', G.xt, G.yt);
      linie(ctx, A, G.xb, [0, 0], farbe('--ink'), 1.5);
      var xs = [], ys = []; for (var i = 0; i <= 400; i++) { var x = G.xb[0] + (G.xb[1] - G.xb[0]) * i / 400; xs.push(x); ys.push(G.g(x)); }
      linie(ctx, A, xs, ys, farbe('--blau'), 3.5);
      var it = [x0];
      for (var k = 0; k < N; k++) {
        var a = it[k], ga = G.g(a), da = G.d(a);
        if (Math.abs(da) < 1e-12) break;
        var neu = a - ga / da;
        linie(ctx, A, [a, a], [0, ga], farbe('--muted'), 1.2, true);
        linie(ctx, A, [G.xb[0], G.xb[1]], [ga + da * (G.xb[0] - a), ga + da * (G.xb[1] - a)], farbe('--ink'), 1.1);
        it.push(neu);
      }
      it.forEach(function (v) { punkt(ctx, A, v, 0, farbe('--accent'), 6); });
      var letzt = it[it.length - 1], res = G.g(letzt);
      el.querySelector('.zustand').innerHTML = Math.abs(res) < 1e-8 ? 'Root found: <b>' + fmt(letzt, 6) + '</b> after ' + (it.length - 1) + ' steps.'
        : 'No root yet: g(x<sub>' + (it.length - 1) + '</sub>) = ' + fmt(res, 4) + '.';
      el.querySelector('.werte').textContent = it.slice(0, 8).map(function (v, i) { return 'x_' + i + ' = ' + fmt(v, 8); }).join('\n');
    }
    wahl.addEventListener('change', function () { passeAn(); male(); });
    el.querySelectorAll('input[type=range]').forEach(function (r) { r.addEventListener('input', male); });
    passeAn(); male(); return male;
  }

  // ------------------------------------------------------------ APD model
  function apd(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    var r = function (DI) { return 220 - 180 * Math.exp(-DI / 60); };
    function male() {
      var PCL = wert(el, 'pcl'), A0 = wert(el, 'a0'), N = 120, DImin = 5;
      zeige(el, 'pcl', PCL + ' ms'); zeige(el, 'a0', A0 + ' ms');
      var A = [A0]; for (var k = 0; k < N; k++) { var m = Math.ceil((A[k] + DImin) / PCL); A.push(r(m * PCL - A[k])); }
      var X = achsen(ctx, cv.width, cv.height, [-2, N + 2], [40, 240], 'n (action potentials)', 'APDₙ (ms)', [0, 20, 40, 60, 80, 100, 120], [50, 100, 150, 200]);
      var n = A.map(function (_, i) { return i; });
      linie(ctx, X, n, A, farbe('--accent'), 0.9, true);
      A.forEach(function (v, i) { punkt(ctx, X, i, v, farbe('--accent'), 3); });
      var ende = A.slice(-12).map(function (v) { return Math.round(v * 10) / 10; });
      var versch = ende.filter(function (v, i) { return ende.indexOf(v) === i; });
      el.querySelector('.zustand').innerHTML = versch.length === 1 ? 'Constant duration <b>' + fmt(versch[0], 1) + ' ms</b>.'
        : versch.length === 2 ? '<b>Alternans</b>: alternation between ' + fmt(versch[0], 1) + ' and ' + fmt(versch[1], 1) + ' ms.'
        : versch.length <= 6 ? 'Cycle of ' + versch.length + ' values.' : 'No regularity recognizable (aperiodic).';
      el.querySelector('.werte').textContent = A.slice(-5).map(function (v, i) { return 'APD_' + (N - 4 + i) + ' = ' + fmt(v, 1) + ' ms'; }).join('\n');
    }
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ helpers for Chapter 2
  function teilung(lo, hi, max) {
    var roh = (hi - lo) / (max || 5), p = Math.pow(10, Math.floor(Math.log10(roh))), s = [1, 2, 2.5, 5, 10].map(function (f) { return f * p; }).filter(function (q) { return q >= roh; })[0];
    var t = []; for (var v = Math.ceil(lo / s) * s; v <= hi + 1e-9; v += s) t.push(+v.toFixed(6)); return t;
  }
  function tausend(v) { return Math.round(v).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
  function reihen(el, A, daten, farben) {
    daten.forEach(function (d, j) {
      var n = d.map(function (_, i) { return i; });
      linie(ctx0(el), A, n, d, farben[j], 1.1, true);
      d.forEach(function (v, i) { punkt(ctx0(el), A, i, v, farben[j], d.length > 60 ? 2.5 : 4); });
    });
  }
  function ctx0(el) { return el.querySelector('canvas').getContext('2d'); }
  function legende(el, A, namen, farben) {
    var c = ctx0(el); c.font = '20px "IBM Plex Sans", sans-serif'; c.textAlign = 'left';
    namen.forEach(function (nm, j) { var x = A.X(A.xb[1]) - 190, y = A.Y(A.yb[1]) + 26 + 26 * j;
      c.fillStyle = farben[j]; c.fillRect(x, y - 12, 22, 6); c.fillStyle = farbe('--ink'); c.fillText(nm, x + 30, y - 3); });
  }
  var ROT = ['#6e0a1f', '#e3707d', '#a3142e'];
  function rot(i) { return ROT[i]; }

  // ------------------------------------------------------------ predator-prey model (Eq. 2.3)
  function raeuberBeute(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d'), wahl = el.querySelector('select');
    function male() {
      var r = wert(el, 'r'), g = wert(el, 'g'), u0 = wert(el, 'u0'), v0 = wert(el, 'v0'), N = wert(el, 'n');
      zeige(el, 'r', fmt(r, 2)); zeige(el, 'g', fmt(g, 2)); zeige(el, 'u0', fmt(u0, 2)); zeige(el, 'v0', fmt(v0, 2)); zeige(el, 'n', String(N));
      var u = [u0], v = [v0];
      for (var k = 0; k < N; k++) { u.push((1 + r) * u[k] - r * u[k] * u[k] - g * u[k] * v[k]); v.push(g * u[k] * v[k]); }
      var hi = Math.min(3, Math.max(1.2, Math.max.apply(null, u.concat(v).filter(isFinite)) * 1.08));
      var us = 1 / g, vs = r * (1 - 1 / g) / g;
      // stability via the Jacobian matrix at the steady state: trace 2 - r/g, determinant 1 + r - 2r/g
      var sp = 2 - r / g, de = 1 + r - 2 * r / g, di = sp * sp / 4 - de;
      var rho = di < 0 ? Math.sqrt(de) : Math.max(Math.abs(sp / 2 + Math.sqrt(di)), Math.abs(sp / 2 - Math.sqrt(di)));
      var stabil = rho < 1;
      if (wahl.value === 'zeit') {
        var A = achsen(ctx, cv.width, cv.height, [-0.5, N + 0.5], [Math.min(0, -0.02 * hi), hi], 'n', 'uₙ, vₙ', teilung(0, N), teilung(0, hi));
        reihen(el, A, [u, v], [rot(0), rot(1)]); legende(el, A, ['Prey uₙ', 'Predators vₙ'], [rot(0), rot(1)]);
      } else {
        var B = achsen(ctx, cv.width, cv.height, [0, hi], [0, hi], 'Prey uₙ', 'Predators vₙ', teilung(0, hi), teilung(0, hi));
        linie(ctx, B, u, v, farbe('--rule'), 1);
        u.forEach(function (x, i) { var s = i / N; punkt(ctx, B, x, v[i], 'rgb(' + Math.round(250 - 140 * s) + ',' + Math.round(190 - 180 * s) + ',' + Math.round(195 - 165 * s) + ')', 5); });
        if (vs > 0) { punkt(ctx, B, us, vs, '#000', 7, !stabil); }
      }
      var z = g <= 1 ? 'For γ ≤ 1 there is no steady state with predators: the predators die out.'
        : 'Steady state with predators: <b>(1/γ, r(1 − 1/γ)/γ) = (' + fmt(us, 3) + ', ' + fmt(vs, 3) + ')</b>, '
          + (stabil ? 'stable (filled circle)' : 'unstable (open circle)') + '.';
      if (!u.every(isFinite) || u.some(function (x) { return x < 0; })) z += ' Caution: negative values – the model leaves its meaningful range.';
      el.querySelector('.zustand').innerHTML = z;
      el.querySelector('.werte').textContent = u.slice(-4).map(function (x, i) { var n = N - 3 + i; return 'n = ' + n + ':  u = ' + fmt(x, 4) + ',  v = ' + fmt(v[n], 4); }).join('\n');
    }
    wahl.addEventListener('change', male);
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ Leslie model with three age classes (Eq. 2.11)
  function leslie(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    function male() {
      var b1 = wert(el, 'b1'), b2 = wert(el, 'b2'), b3 = wert(el, 'b3'), s1 = wert(el, 's1'), s2 = wert(el, 's2'), N = wert(el, 'n');
      zeige(el, 'b1', fmt(b1, 1)); zeige(el, 'b2', fmt(b2, 1)); zeige(el, 'b3', fmt(b3, 1)); zeige(el, 's1', fmt(s1, 2)); zeige(el, 's2', fmt(s2, 2)); zeige(el, 'n', String(N));
      var x = [[0, 0, 1000]];
      for (var k = 0; k < N; k++) { var a = x[k]; x.push([b1 * a[0] + b2 * a[1] + b3 * a[2], s1 * a[0], s2 * a[1]]); }
      var kl = [0, 1, 2].map(function (j) { return x.map(function (a) { return a[j]; }); });
      var hi = Math.max.apply(null, kl[0].concat(kl[1], kl[2])) * 1.08 || 1;
      var A = achsen(ctx, cv.width, cv.height, [-0.5, N + 0.5], [0, hi], 'n', 'Number', teilung(0, N), teilung(0, hi));
      reihen(el, A, kl, [rot(0), rot(1), rot(2)]); legende(el, A, ['Class 1', 'Class 2', 'Class 3'], [rot(0), rot(1), rot(2)]);
      // characteristic polynomial p(λ) = λ³ − b1 λ² − b2 s1 λ − b3 s1 s2: unique positive root by bisection
      var p = function (l) { return l * l * l - b1 * l * l - b2 * s1 * l - b3 * s1 * s2; }, lo = 0, hoch = 1;
      while (p(hoch) < 0) hoch *= 2;
      for (var i = 0; i < 80; i++) { var m = (lo + hoch) / 2; if (p(m) < 0) lo = m; else hoch = m; }
      var lam = (lo + hoch) / 2, R = b1 + b2 * s1 + b3 * s1 * s2;
      el.querySelector('.zustand').innerHTML = 'Offspring per newborn <b>R = ' + fmt(R, 3) + '</b>, positive eigenvalue <b>λ₁ = ' + fmt(lam, 4) + '</b>: '
        + (Math.abs(lam - 1) < 5e-4 ? 'the population stays the same size in the long run.' : lam < 1 ? 'the population dies out.' : 'the population grows.');
      el.querySelector('.werte').textContent = x.slice(-3).map(function (a, i) { return 'x_' + (N - 2 + i) + ' = (' + a.map(function (q) { return fmt(q, 1); }).join('; ') + ')'; }).join('\n');
    }
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ SIR model (Eq. 2.21)
  function sir(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    function male() {
      var R0 = wert(el, 'R0'), g = wert(el, 'g'), I0 = Math.round(Math.pow(10, wert(el, 'I0'))), N = wert(el, 'n'), al = 0.1, P = 100000;
      zeige(el, 'R0', fmt(R0, 1)); zeige(el, 'g', fmt(g, 2)); zeige(el, 'I0', tausend(I0)); zeige(el, 'n', String(N));
      var beta = R0 * (g + al) / P, S = [P - I0], I = [I0], R = [0];
      for (var k = 0; k < N; k++) {
        S.push(S[k] - beta * S[k] * I[k] + al * (P - S[k]));
        I.push(I[k] + beta * S[k] * I[k] - (g + al) * I[k]);
        R.push(R[k] + g * I[k] - al * R[k]);
      }
      var A = achsen(ctx, cv.width, cv.height, [-0.5, N + 0.5], [0, 105], 'n', 'Persons (thousands)', teilung(0, N), [0, 20, 40, 60, 80, 100]);
      var k = function (z) { return z.map(function (q) { return q / 1000; }); };
      reihen(el, A, [k(S), k(I), k(R)], [rot(0), rot(1), rot(2)]); legende(el, A, ['S (susceptible)', 'I (infected)', 'R (recovered)'], [rot(0), rot(1), rot(2)]);
      var Is = al * P * (1 - 1 / R0) / (g + al), imax = Math.max.apply(null, I);
      el.querySelector('.zustand').innerHTML = (R0 <= 1 ? 'R₀ ≤ 1: the disease disappears; the disease-free state (N, 0, 0) is stable.'
        : 'R₀ &gt; 1: the disease persists; the endemic state with <b>S* = ' + tausend(P / R0) + '</b> and <b>I* = ' + tausend(Is) + '</b>.')
        + ' At most ' + tausend(imax) + ' infected at the same time.'
        + (R0 * (g + al) > 1 - al ? ' <b>Caution:</b> R₀ (γ + α) &gt; 1 − α violates condition (2.23); negative values can then occur.' : '');
      el.querySelector('.werte').textContent = 'β = ' + beta.toExponential(2) + '\n' + 'n = ' + N + ':  S = ' + tausend(S[N]) + ',  I = ' + tausend(I[N]) + ',  R = ' + tausend(R[N]);
    }
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ helpers for Chapters 3 and 4
  function rk4(f, z0, h, N) {                          // classical Runge-Kutta method, returns N+1 states
    var z = [z0.slice()];
    for (var n = 0; n < N; n++) {
      var y = z[n], k1 = f(y), a = y.map(function (v, i) { return v + h / 2 * k1[i]; }), k2 = f(a),
          b = y.map(function (v, i) { return v + h / 2 * k2[i]; }), k3 = f(b), c = y.map(function (v, i) { return v + h * k3[i]; }), k4 = f(c);
      z.push(y.map(function (v, i) { return v + h / 6 * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]); }));
    }
    return z;
  }
  function pfeilfeld(ctx, A, f, nx, ny) {                // arrows of equal length in the direction of the vector field
    var c = '#33993f';                                  // direction field green as in the programs
    ctx.save(); ctx.strokeStyle = c; ctx.fillStyle = c; ctx.lineWidth = 1.4;
    for (var i = 0; i < nx; i++) for (var j = 0; j < ny; j++) {
      var x = A.xb[0] + (A.xb[1] - A.xb[0]) * (i + 0.5) / nx, y = A.yb[0] + (A.yb[1] - A.yb[0]) * (j + 0.5) / ny;
      var w = f([x, y]), px = A.X(x), py = A.Y(y), dx = A.X(x + w[0]) - px, dy = A.Y(y + w[1]) - py, L = Math.hypot(dx, dy);
      if (!(L > 1e-12)) continue;
      dx *= 11 / L; dy *= 11 / L;
      ctx.beginPath(); ctx.moveTo(px - dx, py - dy); ctx.lineTo(px + dx, py + dy); ctx.stroke();
      var ang = Math.atan2(dy, dx);
      ctx.beginPath(); ctx.moveTo(px + dx, py + dy);
      ctx.lineTo(px + dx - 6 * Math.cos(ang - 0.45), py + dy - 6 * Math.sin(ang - 0.45));
      ctx.lineTo(px + dx - 6 * Math.cos(ang + 0.45), py + dy - 6 * Math.sin(ang + 0.45)); ctx.closePath(); ctx.fill();
    }
    ctx.restore();
  }
  function art2(T, D) {                                  // type of the origin from trace T and determinant D
    if (D < -1e-12) return 'saddle (unstable)';
    if (Math.abs(T) < 1e-12) return D > 0 ? 'center' : 'degenerate';
    var st = T < 0 ? 'stable' : 'unstable';
    if (Math.abs(D) < 1e-12) return 'degenerate';
    return st + (T * T >= 4 * D ? ' node' : ' spiral');
  }

  // ------------------------------------------------------------ Euler's method for cooling (Eq. 3.26)
  function euler(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    function male() {
      var h = wert(el, 'h'), k = 0.03, Tu = 5, T0 = 80, tend = 180;
      zeige(el, 'h', fmt(h, 0) + ' min');
      var N = Math.ceil(tend / h), t = [0], T = [T0];
      for (var n = 0; n < N; n++) { T.push(T[n] + h * k * (Tu - T[n])); t.push((n + 1) * h); }
      var lo = Math.max(-120, Math.min(-5, Math.min.apply(null, T))), hi = Math.min(200, Math.max(85, Math.max.apply(null, T)));
      var A = achsen(ctx, cv.width, cv.height, [0, tend], [lo, hi], 't (min)', 'T (°C)', [0, 30, 60, 90, 120, 150, 180], teilung(lo, hi));
      var ts = [], ex = []; for (var i = 0; i <= 300; i++) { ts.push(tend * i / 300); ex.push(Tu + (T0 - Tu) * Math.exp(-k * ts[i])); }
      linie(ctx, A, [0, tend], [Tu, Tu], farbe('--ink'), 1, true);
      linie(ctx, A, ts, ex, rot(0), 3);
      linie(ctx, A, t, T, rot(1), 1.5, true); T.forEach(function (v, i) { punkt(ctx, A, t[i], v, rot(1), 5); });
      var q = 1 - k * h;
      el.querySelector('.zustand').innerHTML = 'Factor <b>1 − kh = ' + fmt(q, 2) + '</b>: ' + (q >= 0 ? 'the approximation decreases monotonically to 5 °C.'
        : q > -1 ? 'the approximation oscillates around 5 °C, the oscillation dies away.' : q === -1 ? 'the approximation jumps between two values.' : 'the approximation builds up: the method is unstable (h &gt; 2/k ≈ 66.7).');
      var i60 = Math.round(60 / h);
      el.querySelector('.werte').textContent = (Math.abs(i60 * h - 60) < 1e-9 ? 'T(60) ≈ ' + fmt(T[i60], 3) + '  (exact ' + fmt(Tu + 75 * Math.exp(-1.8), 3) + ')\n' : '')
        + 'T_1 = ' + fmt(T[1], 3) + ',  T_2 = ' + fmt(T[2], 3);
    }
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ fish stock with harvesting (Section 3.3)
  function fischerei(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d'), wahl = el.querySelector('select');
    function male() {
      var r = 0.5, K = 100, q = wert(el, 'q'), quote = wahl.value === 'quote';
      var h = q / 100;                                   // slider 0..100 -> harvesting rate 0..1 or quota 0..20
      var E = quote ? 0.2 * q : h;
      zeige(el, 'q', quote ? fmt(E, 1) + ' (1000 t/year)' : fmt(E, 2) + ' per year');
      var fang = function (x) { return quote ? E : E * x; };
      var A = achsen(ctx, cv.width, cv.height, [0, 110], [0, 20], 'Stock x (1000 t)', 'per year', [0, 25, 50, 75, 100], [0, 5, 10, 15, 20]);
      var xs = [], g = [], fg = []; for (var i = 0; i <= 300; i++) { var x = 110 * i / 300; xs.push(x); g.push(r * x * (1 - x / K)); fg.push(fang(x)); }
      linie(ctx, A, xs, g, farbe('--blau'), 3); linie(ctx, A, xs, fg, rot(1), 2.5, true);
      var st = [], txt;
      if (quote) {
        var w = 1 - 4 * E / (r * K);
        if (w >= 0) { w = Math.sqrt(w); st = [{ x: K / 2 * (1 - w), s: false }, { x: K / 2 * (1 + w), s: true }]; }
      } else {
        st = [{ x: 0, s: E > r }]; if (E < r) st.push({ x: K * (1 - E / r), s: true });
      }
      st.forEach(function (p) { punkt(ctx, A, p.x, r * p.x * (1 - p.x / K), '#000', 7, !p.s); });
      if (quote) txt = st.length ? 'Stable stock <b>' + fmt(st[1].x, 1) + '</b>, threshold ' + fmt(st[0].x, 1) + ': if the stock falls below it, it collapses.'
        : '<b>Overfishing</b>: the quota is larger than the largest growth rK/4 = 12.5; the stock collapses.';
      else txt = E < r ? 'Stable stock <b>' + fmt(K * (1 - E / r), 1) + '</b>, yield h x* = <b>' + fmt(E * K * (1 - E / r), 2) + '</b> per year (at most 12.5 at h = 0.25).'
        : 'Harvesting rate h ≥ r: the stock dies out.';
      el.querySelector('.zustand').innerHTML = txt;
      el.querySelector('.werte').textContent = 'Growth r x (1 − x/K): blue\nCatch: red dashed';
    }
    wahl.addEventListener('change', male);
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }

  // ------------------------------------------------------------ predator-prey in the phase plane (Eq. 4.2)
  function phasenebene(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    function male() {
      var r = 1, c = 0.5, d = 0.2, e = 1, K = wert(el, 'K'), x0 = wert(el, 'x0'), y0 = wert(el, 'y0');
      zeige(el, 'K', fmt(K, 1)); zeige(el, 'x0', fmt(x0, 1)); zeige(el, 'y0', fmt(y0, 2));
      var f = function (z) { return [r * (1 - z[0] / K) * z[0] - c * z[0] * z[1], d * z[0] * z[1] - e * z[1]]; };
      var xm = Math.max(11, K * 1.1), A = achsen(ctx, cv.width, cv.height, [0, xm], [0, 4], 'Prey x', 'Predators y', teilung(0, xm), [0, 1, 2, 3, 4]);
      pfeilfeld(ctx, A, f, 16, 10);
      linie(ctx, A, [0, xm], [r / c, r / c * (1 - xm / K)], farbe('--blau'), 3);
      linie(ctx, A, [e / d, e / d], [0, 4], ROTH, 3);
      var z = rk4(f, [x0, y0], 0.02, 3000);
      linie(ctx, A, z.map(function (p) { return p[0]; }), z.map(function (p) { return p[1]; }), rot(1), 2.5);
      punkt(ctx, A, x0, y0, rot(1), 6);
      var xs = e / d, ys = r / c * (1 - e / (d * K)), txt;
      if (ys > 0) {
        var J = [[r * (1 - 2 * xs / K) - c * ys, -c * xs], [d * ys, d * xs - e]], T = J[0][0] + J[1][1], D = J[0][0] * J[1][1] - J[0][1] * J[1][0];
        punkt(ctx, A, xs, ys, '#000', 7, T >= 0);
        txt = 'Coexistence at <b>(' + fmt(xs, 1) + '; ' + fmt(ys, 2) + ')</b>, trace ' + fmt(T, 3) + ', det ' + fmt(D, 3) + ': <b>' + art2(T, D) + '</b>.';
      } else txt = 'For K ≤ e/d = 5 there is no state with predators: the predators die out, the prey tends to K.';
      punkt(ctx, A, 0, 0, '#000', 7, true); punkt(ctx, A, K, 0, '#000', 7, ys > 0);
      el.querySelector('.zustand').innerHTML = txt;
      var L = z[z.length - 1];
      el.querySelector('.werte').textContent = 'Nullclines: dx/dt = 0 blue, dy/dt = 0 light blue\nt = 60:  x = ' + fmt(L[0], 3) + ',  y = ' + fmt(L[1], 3);
    }
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    male(); return male;
  }
  var ROTH = '#73b3e6';

  // ------------------------------------------------------------ linear systems dx/dt = A x (Section 4.2)
  function linear2d(el) {
    var cv = el.querySelector('canvas'), ctx = cv.getContext('2d');
    function male() {
      var a = wert(el, 'a11'), b = wert(el, 'a12'), c = wert(el, 'a21'), d = wert(el, 'a22');
      ['a11', 'a12', 'a21', 'a22'].forEach(function (n) { zeige(el, n, fmt(wert(el, n), 1)); });
      var f = function (z) { return [a * z[0] + b * z[1], c * z[0] + d * z[1]]; };
      var A = achsen(ctx, cv.width, cv.height, [-4, 4], [-4, 4], 'x₁', 'x₂', [-4, -2, 0, 2, 4], [-4, -2, 0, 2, 4]);
      pfeilfeld(ctx, A, f, 15, 15);
      [[1, 3], [-3, 1], [3, -1], [-1, -3], [3.5, 3.5], [-3.5, -3.5]].forEach(function (s, i) {
        var z = rk4(f, s, 0.01, 1000);
        linie(ctx, A, z.map(function (p) { return p[0]; }), z.map(function (p) { return p[1]; }), i === 0 ? rot(0) : rot(1), i === 0 ? 3 : 1.6);
        punkt(ctx, A, s[0], s[1], i === 0 ? rot(0) : rot(1), i === 0 ? 6 : 4);
      });
      punkt(ctx, A, 0, 0, '#000', 7);
      var T = a + d, D = a * d - b * c, disk = T * T - 4 * D, ew;
      if (disk >= 0) ew = 'λ = ' + fmt((T - Math.sqrt(disk)) / 2, 3) + ' and ' + fmt((T + Math.sqrt(disk)) / 2, 3);
      else ew = 'λ = ' + fmt(T / 2, 3) + ' ± ' + fmt(Math.sqrt(-disk) / 2, 3) + ' i';
      el.querySelector('.zustand').innerHTML = 'Trace T = <b>' + fmt(T, 2) + '</b>, det A = <b>' + fmt(D, 2) + '</b>: <b>' + art2(T, D) + '</b>.';
      el.querySelector('.werte').textContent = 'Eigenvalues: ' + ew + '\nthick line: solution with x(0) = (1, 3)';
    }
    el.querySelectorAll('input[type=range]').forEach(function (rr) { rr.addEventListener('input', male); });
    var vor = el.querySelector('select');
    if (vor) vor.addEventListener('change', function () {
      var m = { knoten: [-2, 1, 1, -2], spirale: [-1, 2, -2, -1], zentrum: [0, -2, 2, 0], sattel: [1, 2, 2, 1] }[vor.value];
      ['a11', 'a12', 'a21', 'a22'].forEach(function (n, i) { regler(el, n).value = m[i]; }); male();
    });
    male(); return male;
  }

  var APPS = { treppe: treppe, linear: linear, newton: newton, apd: apd, 'raeuber-beute': raeuberBeute, leslie: leslie, sir: sir,
               euler: euler, fischerei: fischerei, phasenebene: phasenebene, linear2d: linear2d }, neuZeichnen = [];
  document.querySelectorAll('[data-app]').forEach(function (el) { var f = APPS[el.dataset.app]; if (f) neuZeichnen.push(f(el)); });
  function alle() { neuZeichnen.forEach(function (f) { f(); }); }
  if (window.matchMedia) matchMedia('(prefers-color-scheme: dark)').addEventListener('change', alle);
  new MutationObserver(alle).observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
})();
