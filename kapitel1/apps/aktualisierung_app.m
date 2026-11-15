function aktualisierung_app
% AKTUALISIERUNG_APP  Aktualisierungsfunktion f und ein Iterationsschritt x_0 -> x_1 = f(x_0)
%                     (Kapitel I, Folie 20 "Aktualisierungsfunktion des Beispiels von Folie 11")
%
%   Rekursionsvorschrift  x_{n+1} = f(x_n)  mit  f(x) = (x + 2/x)/2   (Beispiel von Folie 11)
%
%   Linkes Bild (immer):   Graph von f ueber der Zustandsachse x.
%                          x_0 sitzt auf der x-Achse, der Pfeil geht hoch zur Kurve und nach links
%                          zur y-Achse: dort liest man x_1 = f(x_0) ab (wie heron_f_x0.png auf Folie 20).
%   Rechtes Bild (Kaestchen "Zeitverlauf von x_n"; x_2 ... x_4 hellrot = "noch in der Zukunft"): dieselben Werte ueber der Zeitachse n
%                          (y-Achse mit denselben Grenzen wie die x-Achse links):
%                          x_0 bei n = 0, x_1 einen Schritt weiter bei n = 1.
%   Drehknopf x_0: x_0 und x_1 bewegen sich in beiden Bildern gleichzeitig.
%   Knopf "naechster Schritt": x_1 wird per Bogen (Abtragen mit dem Zirkel) auf die x-Achse uebertragen und
%   ist der neue Ausgangswert (x_1 -> x_2 = f(x_1) usw. bis x_4); rechts werden die berechneten Glieder kraeftig rot.
%   Drehen am Knopf oder reset beginnt wieder bei Schritt 0.
%   Kaestchen (in didaktischer Reihenfolge): "Punkt auf dem Graphen" = (x_0, f(x_0)) (Pfeil hoch zur Kurve, blauer Punkt),
%   "Funktionswert f(x_0)" = x_1 (Pfeil zur y-Achse, Punkt wird zu (x_0, x_1)), "Zeitverlauf".
%   Kaestchen "Treppe" (19.10.2026, wie Folie 22): Winkelhalbierende y = x statt Zirkelbogen; die Treppe waechst mit
%   "naechster Schritt" bis (x_4, x_4). Kaestchen "Zoom" (nur mit Treppe): Ausschnitt 1.36 <= x, y <= 1.6 um sqrt(2)
%   (wie heron_treppe_zoom.png), gleiche Grenzen fuer die y-Achse des Zeitverlaufs.
%
%   Farben wie Folien: f dunkles Koenigsblau, Folgenglieder x_0, x_1 rot.
%   Stil wie fisch_app / malaria_app.  Fuer MATLAB R2025b.

%% Parameter
f     = @(x) 0.5*(x + 2./x);
xMin  = 0.25; xMax = 4;          % Bereich des Drehknopfs (x_1 = f(x_0) <= 4.3 bleibt im Bild)
XL    = [-0.15 4.3];             % Achsen wie Folienbild heron_f.png
YL    = XL;                      % gleiche Skalierung beider Achsen (Bogen = Viertelkreis, y = x unter 45 Grad)

fName = 'Times New Roman';
fSize = 24;
colF  = [0 51 140]/255;          % dunkles Koenigsblau (Folie 20)
colX  = [0.64 0.08 0.18];        % Folgen-Rot
colZ  = [226 112 124]/255;       % helles Rot: kuenftige Glieder x_2, x_3, x_4 (wie ROTTOENE hell)
nZ    = 4;                       % Zeitverlauf bis x_4

%% Zustand
S.x0   = 0.5;                    % wie Folie 11/20
S.zeit = false;
S.punkt = false;                 % Punkt (x_0, f(x_0)) auf dem Graphen zeigen
S.wert  = false;                 % Wert x_1 = f(x_0) auf der y-Achse zeigen
S.k     = 0;                     % aktueller Schritt: x_k -> x_{k+1} = f(x_k) (Knopf "naechster Schritt")
S.treppe = false;                % Treppendiagramm mit Winkelhalbierender y = x (statt Zirkelbogen)
S.zoom   = false;                % Ausschnitt um sqrt(2) (wie Folie 22), nur mit Treppe
ZL    = [1.36 1.6];              % Zoom-Ausschnitt (gleich auf beiden Achsen)

%% GUI
fig = uifigure('Name','Aktualisierungsfunktion', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- linkes Bild: Graph von f (Zustandsachse x)
ax1 = uiaxes(al); ax1.Layout.Column = 1;
styleAx(ax1); hold(ax1,'on');
xlabel(ax1,'x'); ylabel(ax1,'f(x)');
xx = linspace(0.16, XL(2), 400);
plot(ax1, xx, f(xx), '-', 'Color', colF, 'LineWidth', 3);
xlim(ax1, XL); ylim(ax1, YL); ax1.XTick = 0:4; ax1.YTick = 0:4;
ax1.DataAspectRatio = [1 1 1];              % 1 Einheit auf beiden Achsen gleich lang
hV   = plot(ax1, NaN, NaN, '--', 'Color', colX, 'LineWidth', 2.5);   % hoch zur Kurve
hH   = plot(ax1, NaN, NaN, '--', 'Color', colX, 'LineWidth', 2.5);   % nach links zur y-Achse
hVa  = plot(ax1, NaN, NaN, '^', 'MarkerSize', 12, 'MarkerFaceColor', colX, 'MarkerEdgeColor', colX);
hHa  = plot(ax1, NaN, NaN, '<', 'MarkerSize', 12, 'MarkerFaceColor', colX, 'MarkerEdgeColor', colX);
hP0  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 14, 'MarkerFaceColor', colX, 'MarkerEdgeColor', colX, 'Clipping', 'off');
hP1  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 14, 'MarkerFaceColor', colX, 'MarkerEdgeColor', colX, 'Clipping', 'off');
hPf  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 10, 'MarkerFaceColor', colF, 'MarkerEdgeColor', colF);
hT0  = text(ax1, NaN, NaN, '', 'Color', colX, 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold', ...
    'VerticalAlignment', 'bottom', 'BackgroundColor', 'w', 'Margin', 1);
hT1  = text(ax1, NaN, NaN, '', 'Color', colX, 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold', ...
    'VerticalAlignment', 'top', 'BackgroundColor', 'w', 'Margin', 1);          % x_1 an der y-Achse (unter dem Pfeil)
hTP  = text(ax1, NaN, NaN, '', 'Color', colF, 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold', ...
    'VerticalAlignment', 'bottom', 'BackgroundColor', 'w', 'Margin', 1);       % Punkt auf dem Graphen
hArc  = plot(ax1, NaN, NaN, '-', 'Color', [0 0 0], 'LineWidth', 1.8);   % Zirkelbogen, Stil wie Winkelhalbierende      % Bogen: x_k von der y- auf die x-Achse
hArcA = plot(ax1, NaN, NaN, 'v', 'MarkerSize', 10, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0]);
hDiag = plot(ax1, [-1 5], [-1 5], '-', 'Color', [0 0 0], 'LineWidth', 1.8, 'Visible', 'off');   % y = x
hDiagT = text(ax1, NaN, NaN, 'y = x', 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Visible', 'off');
hTr  = plot(ax1, NaN, NaN, '--', 'Color', colX, 'LineWidth', 2.5, 'Visible', 'off');       % Treppe
hTrD = plot(ax1, NaN, NaN, ':', 'Color', colX, 'LineWidth', 1.5, 'Visible', 'off');        % senkrecht zur x-Achse
hTrF = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 10, 'MarkerFaceColor', colF, 'MarkerEdgeColor', colF, 'Visible', 'off');
hTrX = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 14, 'MarkerFaceColor', colX, 'MarkerEdgeColor', colX, ...
    'Clipping', 'off', 'Visible', 'off');                                                  % x_0 ... x_{k+1} auf der x-Achse
hTrL = gobjects(1, nZ+1);
for m = 0:nZ
    hTrL(m+1) = text(ax1, NaN, NaN, sprintf('x_%d', m), 'Color', colX, 'FontName', fName, 'FontSize', fSize-2, ...
        'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'Visible', 'off');
end
hTreppe = [hDiag hDiagT hTr hTrD hTrF hTrX hTrL];
hPunkt = [hV hVa hPf hTP];                   % Kaestchen "Punkt (x_0, f(x_0))"
hWert  = [hH hHa hP1 hT1];                   % Kaestchen "Wert x_1"

% --- rechtes Bild: Zeitverlauf (Zeitachse n), zunaechst ausgeblendet
ax2 = uiaxes(al); ax2.Layout.Column = 2;
styleAx(ax2); hold(ax2,'on');
xlabel(ax2,'n'); ylabel(ax2,'x_n');
xlim(ax2, [-0.5 nZ+0.5]); ylim(ax2, XL); ax2.XTick = 0:nZ; ax2.YTick = 0:4;   % y-Achse rechts = x-Achse links (Zustand)
hSZ  = plot(ax2, NaN, NaN, '--o', 'Color', colZ, 'LineWidth', 2, 'MarkerSize', 12, ...
    'MarkerFaceColor', colZ, 'MarkerEdgeColor', colZ);                  % kuenftige Glieder ("noch in der Zukunft")
hS   = plot(ax2, NaN, NaN, '--o', 'Color', colX, 'LineWidth', 2, 'MarkerSize', 14, ...
    'MarkerFaceColor', colX, 'MarkerEdgeColor', colX);                  % bereits berechnete Glieder x_0 ... x_{k+1}
hU   = gobjects(1, nZ+1);                                               % Beschriftungen x_0 ... x_nZ
for m = 0:nZ
    hU(m+1) = text(ax2, NaN, NaN, sprintf('x_%d', m), 'FontName', fName, 'FontWeight', 'bold', ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
end
ax2.Visible = 'off';
hZeit = [hS hSZ hU];                         % Zeitverlauf-Objekte (ohne Kaestchen unsichtbar)
set(hZeit, 'Visible', 'off');

% --- Seitenleiste (vertikal zentriert durch '1x' oben und unten)
pl = uigridlayout(gl,[17 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Rand | Formel f | Abstand | Drehknopf | Titel x_0 | Abstand | x_0 + reset | x_1 | Abstand | 3 Kaestchen | Rand
pl.RowHeight = {'1x', 80, 16, 220, 35, 16, 40, 40, 24, 34, 34, 34, 34, 34, 16, 40, '1x'};   % Zeilen 10-14: Kaestchen, 16: naechster Schritt
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

hFor = uilabel(pl,'Text','$\displaystyle \bf f(x) = \frac{1}{2}\left(x + \frac{2}{x}\right)$', ...
    'FontSize',24,'HorizontalAlignment','center','Interpreter','latex');
hFor.Layout.Row = 2;

kX = uiknob(pl,'continuous','Limits',[xMin xMax],'Value',S.x0, ...
    'MajorTicks',[0.25 0.5 1 2 3 4],'MinorTicks',0.25:0.25:4, ...
    'FontName',fName,'FontSize',20,'FontWeight','bold');
kX.Layout.Row = 4;
kX.ValueChangingFcn = @(~,evt) onX(evt.Value);
kX.ValueChangedFcn  = @(src,~) onSnap(src);
mkLabel(5,'x_0');

g0 = uigridlayout(pl,[1 4]);                 % Anzeige x_0 mit dezentem reset daneben
g0.Layout.Row = 7;
g0.ColumnWidth = {'1x','fit','fit','1x'};
g0.ColumnSpacing = 10; g0.Padding = [0 0 0 0];
g0.BackgroundColor = [1 1 1];
hV0 = uilabel(g0,'Text','','FontName',fName,'FontSize',22,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hV0.Layout.Column = 2;
bReset = uibutton(g0,'Text','reset','FontName',fName,'FontSize',14, ...
    'FontColor',[0.45 0.45 0.45],'BackgroundColor',[0.97 0.97 0.97], ...
    'Tooltip','x_0 = 1/2 (wie Folie 11/20)','ButtonPushedFcn',@(~,~) onStart());
bReset.Layout.Column = 3;

hV1 = uilabel(pl,'Text','','FontName',fName,'FontSize',22,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hV1.Layout.Row = 8;

cbP = mkCheck(10,['Punkt (x' char(8320) ', f(x' char(8320) '))'],S.punkt);
cbP.ValueChangedFcn = @(src,~) onPunkt(src.Value);
cbW = mkCheck(11,['x' char(8321) ' = f(x' char(8320) ')'],S.wert);
cbW.ValueChangedFcn = @(src,~) onWert(src.Value);
cbT = mkCheck(12,'Treppe',S.treppe);
cbT.ValueChangedFcn = @(src,~) onTreppe(src.Value);
cbM = mkCheck(13,'Zoom',S.zoom);
cbM.ValueChangedFcn = @(src,~) onZoom(src.Value);
cbM.Enable = 'off';                                % Zoom nur zusammen mit der Treppe
cbZ = mkCheck(14,['Zeitverlauf von x' char(8345)],S.zeit);
cbZ.ValueChangedFcn = @(src,~) onZeit(src.Value);
bNext = uibutton(pl,'Text',['n' char(228) 'chster Schritt'],'FontName',fName,'FontSize',18, ...
    'FontWeight','bold','ButtonPushedFcn',@(~,~) onNext());          % x_{k+1} wird neuer Ausgangswert
bNext.Layout.Row = 16;

redraw();

%% ---------------- Callbacks ----------------
    function onX(v)
        S.x0 = v;
        S.k = 0;                                % neuer Startwert: wieder beim ersten Schritt beginnen
        redraw();
    end

    function onNext()
        % x_{k+1} wandert (Bogen) auf die x-Achse und wird neuer Ausgangswert
        if S.k < nZ-1
            S.k = S.k + 1;
            S.punkt = true; S.wert = true; cbP.Value = true; cbW.Value = true;
            redraw();
        end
    end

    function onStart()
        kX.Value = 0.5;
        onX(0.5);
    end

    function onSnap(src)
        src.Value = min(xMax, max(xMin, round(src.Value*20)/20));   % auf 0.05 einrasten
        onX(src.Value);
    end

    function onPunkt(v)
        S.punkt = v;
        if ~v, S.wert = false; cbW.Value = false; end    % x_1 ablesen setzt den Punkt voraus
        redraw();
    end

    function onWert(v)
        S.wert = v;
        if v, S.punkt = true; cbP.Value = true; end
        redraw();
    end

    function onTreppe(v)
        S.treppe = v;
        if v
            cbM.Enable = 'on'; cbP.Enable = 'off'; cbW.Enable = 'off';
        else
            S.zoom = false; cbM.Value = false; cbM.Enable = 'off'; cbP.Enable = 'on'; cbW.Enable = 'on';
        end
        redraw();
    end

    function onZoom(v)
        S.zoom = v;
        redraw();
    end

    function onZeit(v)
        S.zeit = v;
        if v
            al.ColumnWidth = {'1x','1x'}; ax2.Visible = 'on';  set(hZeit, 'Visible', 'on');
        else
            al.ColumnWidth = {'1x', 0};   ax2.Visible = 'off'; set(hZeit, 'Visible', 'off');
        end
        redraw();
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        k  = S.k;
        xz = zeros(1, nZ+1); xz(1) = S.x0;                           % Folge x_0 ... x_nZ
        for m = 1:nZ, xz(m+1) = f(xz(m)); end
        xa = xz(k+1); xb = xz(k+2);                                   % aktueller Schritt x_k -> x_{k+1}
        sa = sprintf('x_%d', k); sb = sprintf('x_%d', k+1);
        if S.zoom, L = ZL; else, L = XL; end                          % aktuelle Achsengrenzen (beide Achsen gleich)
        sc = diff(L)/diff(XL);                                        % Abstaende der Beschriftungen mitskalieren
        xlim(ax1, L); ylim(ax1, L); ylim(ax2, L);
        if S.zoom, tk = 1.4:0.1:1.6; else, tk = 0:4; end
        ax1.XTick = tk; ax1.YTick = tk; ax2.YTick = tk;
        y0 = L(1); xl = L(1);
        dy = 0.012*diff(L); dx = 0.012*diff(L);                       % Pfeilspitzen knapp vor den Punkten
        % linkes Bild: hoch zur Kurve, dann nach links zur y-Achse
        set(hV,  'XData', [xa xa], 'YData', [y0 xb-3*dy]);
        set(hVa, 'XData', xa,      'YData', xb-3*dy);
        set(hH,  'XData', [xa xl+3*dx], 'YData', [xb xb]);
        set(hHa, 'XData', xl+3*dx, 'YData', xb);
        set(hP0, 'XData', xa, 'YData', y0);
        set(hP1, 'XData', xl, 'YData', xb);
        set(hPf, 'XData', xa, 'YData', xb);
        set(hT0, 'Position', [xa+0.08, y0+0.08, 0], 'String', [sa ' = ' fmt(xa)]);   % knapp ueber der x-Achse
        set(hT1, 'Position', [xl+0.08, xb-0.12, 0], 'String', [sb ' = f(' sa ') = ' fmt(xb)]);
        if S.wert, tp = ['(' sa ', f(' sa ')) = (' sa ', ' sb ')']; else, tp = ['(' sa ', f(' sa '))']; end
        if xa < 2.2
            set(hTP, 'Position', [xa+0.12, xb+0.12, 0], 'HorizontalAlignment', 'left');
        else
            set(hTP, 'Position', [xa-0.12, xb+0.25, 0], 'HorizontalAlignment', 'right');
        end
        set(hTP, 'String', tp);
        % Bogen (ab Schritt 1): x_k von der y-Achse auf die x-Achse "mit dem Zirkel" abtragen
        if k >= 1
            t = linspace(pi/2, 0, 60);
            set(hArc,  'XData', xa*cos(t), 'YData', xa*sin(t));
            set(hArcA, 'XData', xa, 'YData', y0 + 3*dy);
        else
            set([hArc hArcA], 'XData', NaN, 'YData', NaN);
        end
        onoff = {'off','on'};
        set(hPunkt, 'Visible', onoff{1+(S.punkt && ~S.treppe)});
        set(hWert,  'Visible', onoff{1+(S.wert && ~S.treppe)});
        set([hArc hArcA], 'Visible', onoff{1+~S.treppe});
        set(hTreppe, 'Visible', onoff{1+S.treppe});
        set([hP0 hT0], 'Visible', onoff{1+~S.treppe});             % bei der Treppe: Beschriftung x_0 ... x_{k+1} an der x-Achse
        if S.treppe
            % Treppe: hoch zur Kurve, waagrecht zu y = x, hoch/runter zur Kurve, ... bis (x_{k+1}, x_{k+1})
            px = xz(1); py = y0;
            for m = 0:k
                px = [px xz(m+1) xz(m+2)]; py = [py xz(m+2) xz(m+2)]; %#ok<AGROW>
            end
            set(hTr,  'XData', px, 'YData', py);
            set(hTrD, 'XData', [xb xb], 'YData', [y0 xb]);
            set(hTrF, 'XData', xz(1:k+1), 'YData', xz(2:k+2));
            in = xz(1:k+2) >= L(1) & xz(1:k+2) <= L(2);              % nur Punkte im Ausschnitt
            set(hTrX, 'XData', xz(in), 'YData', y0*ones(1,nnz(in)));
            for m = 0:nZ
                if m <= k+1 && xz(m+1) >= L(1) && xz(m+1) <= L(2)
                    set(hTrL(m+1), 'Position', [xz(m+1)+0.06*sc, y0+0.06*sc, 0], 'Visible', 'on');
                else
                    set(hTrL(m+1), 'Visible', 'off');
                end
            end
            set(hDiagT, 'Position', [L(1)+0.4*diff(L), L(1)+0.5*diff(L), 0]);   % links oberhalb von y = x
        end
        % rechtes Bild: berechnete Glieder x_0 ... x_{k+1} kraeftig, kuenftige hell
        set(hS,  'XData', 0:k+1,  'YData', xz(1:k+2));
        set(hSZ, 'XData', k+1:nZ, 'YData', xz(k+2:end));
        for m = 0:nZ
            if m <= k+1, c = colX; fs = fSize-2; else, c = colZ; fs = fSize-4; end
            set(hU(m+1), 'Position', [m, xz(m+1)+0.2*sc, 0], 'Color', c, 'FontSize', fs);
        end
        % Seitenleiste
        hV0.Text = ['\bf ' sa ' = ' fmt(xa)];
        if S.wert, hV1.Text = ['\bf ' sb ' = f(' sa ') = ' fmt(xb)]; else, hV1.Text = ''; end
        if k < nZ-1, bNext.Enable = 'on'; else, bNext.Enable = 'off'; end
        % Kaestchen-Beschriftungen zum aktuellen Schritt (tiefgestellte Ziffern als Unicode)
        ua = char(8320+k); ub = char(8320+k+1);
        cbP.Text = ['Punkt (x' ua ', f(x' ua '))'];
        cbW.Text = ['x' ub ' = f(x' ua ')'];
        drawnow limitrate
    end

%% ---------------- Hilfsfunktionen ----------------
    function t = fmt(v)
        % hoechstens 2 Nachkommastellen, ohne ueberfluessige Nullen
        t = sprintf('%.2f', v);
        t = regexprep(t, '0+$', ''); t = regexprep(t, '\.$', '');
    end

    function styleAx(ax)
        ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
        ax.Color = [1 1 1]; ax.Box = 'on'; ax.TickDir = 'in';
        disableDefaultInteractivity(ax); ax.Toolbar.Visible = 'off';
    end

    function h = mkLabel(row,txt)
        h = uilabel(pl,'Text',['\bf ' txt],'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end

    function cbx = mkCheck(row,txt,val)
        g = uigridlayout(pl,[1 3]);          % zentriert
        g.Layout.Row = row;
        g.ColumnWidth = {'1x','fit','1x'};
        g.Padding = [0 0 0 0];
        g.BackgroundColor = [1 1 1];
        cbx = uicheckbox(g,'Text',txt,'Value',val, ...
            'FontName',fName,'FontSize',20,'FontWeight','bold');
        cbx.Layout.Column = 2;
    end
end
