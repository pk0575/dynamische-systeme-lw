// Webseite zum Buch: Sprachwahl (gilt für alle Seiten, im Browser gemerkt) und Kopierknöpfe
(function () {
  function setze(sprache) {
    document.querySelectorAll('.code').forEach(function (box) {
      box.querySelectorAll('.pane').forEach(function (p) { p.hidden = p.dataset.lang !== sprache; });
      var f = box.querySelector('.file'); if (f) f.textContent = f.dataset[sprache];
      var d = box.querySelector('a.dl'); if (d) { d.href = d.dataset[sprache]; d.setAttribute('download', d.dataset[sprache].split('/').pop()); }
    });
    document.querySelectorAll('input[name="sprache"]').forEach(function (r) { r.checked = r.value === sprache; });
    try { localStorage.setItem('sprache', sprache); } catch (e) {}
  }
  document.querySelectorAll('input[name="sprache"]').forEach(function (r) {
    r.addEventListener('change', function () { if (r.checked) setze(r.value); });
  });
  var start = 'py';
  try { var s = localStorage.getItem('sprache'); if (['jl', 'm', 'py', 'r'].indexOf(s) >= 0) start = s; } catch (e) {}
  setze(start);

  document.querySelectorAll('button.copy').forEach(function (b) {
    b.addEventListener('click', function () {
      var pane = b.closest('.code').querySelector('.pane:not([hidden])');
      var text = pane.textContent;
      function fertig(t) { b.textContent = t; setTimeout(function () { b.textContent = 'Kopieren'; }, 1600); }
      function markieren() { var r = document.createRange(); r.selectNodeContents(pane); var sel = getSelection(); sel.removeAllRanges(); sel.addRange(r); fertig('Markiert – Strg+C'); }
      if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(text).then(function () { fertig('Kopiert'); }, markieren);
      else markieren();
    });
  });
})();
