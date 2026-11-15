function geometrik_app
% GEOMETRIK_APP  Geometrische Folge mit Treppendiagramm
%          (Kapitel I, Folien "Visualisierung mit x_0 > 0" und "Aktualisierungsfunktion" nach "Geometrische Folge")
%
%   Rekursionsvorschrift  x_{n+1} = a x_n,  Aktualisierungsfunktion  f(x) = a x
%   Grundlage: Folienbilder geometric1.png (x_0 = 1, a = 1.2, 1.01, 0.5, n = 0 ... 5) und geom_f.png.
%
%   Einheitlicher Aufbau (arithmetik_app, geometrik_app, linear_app; erzeugt aus einer gemeinsamen
%   Vorlage claude/abbildungen/gen_lin_apps.py, 19.10.2026):
%   Rechtes Bild (immer):  Zeitverlauf x_n ueber n; berechnete Glieder x_0 ... x_k kraeftig rot,
%                          kuenftige Glieder hellrot ("noch in der Zukunft").
%   Linkes Bild (Kaestchen "Treppe"): f (blau), Winkelhalbierende y = x (schwarz) und Treppe, die mit
%                          "naechster Schritt" waechst. Beide Achsen haben dieselben Grenzen wie die
%                          x_n-Achse rechts (gleiche Skalierung).
%   Seitenleiste: Formel, Drehknopf/-knoepfe a, Startwert x_0, Anzeige x_k,
%   Kaestchen, "naechster Schritt", "alle Schritte", "reset".
%   Farben wie Folien: Folge rot, f blau, y = x schwarz.  Fuer MATLAB R2025b.

%% Parameter
nN    = 5;                       % Zeithorizont wie Folienbild
P     = struct('name', {'a'}, 'lim', {[0 2]}, 'tick', {0:0.5:2}, 'minor', {0:0.1:2}, ...
               'snap', {0.05}, 'def', {1.2});   % Drehknoepfe
X0    = struct('lim', [0.5 3], 'step', 0.5, 'def', 1);   % Startwert
L0    = [-0.1 2.6];                    % Mindest-Achsengrenzen (wie Folienbild)
fName = 'Times New Roman';
fSize = 24;
colF  = [0 51 140]/255;          % dunkles Koenigsblau (wie aktualisierung_app)
colX  = [0.64 0.08 0.18];        % Folgen-Rot
colZ  = [226 112 124]/255;       % helles Rot: kuenftige Glieder
nP    = numel(P);
hatStat = false;                  % Kaestchen "stationaerer Zustand"

%% Zustand
S.p  = [P.def];                  % Parameterwerte (Reihenfolge wie P)
S.x0 = X0.def;
S.k  = 0;                        % berechnet bis x_k
S.treppe = false;
S.stat   = false;

%% GUI
fig = uifigure('Name','Geometrische Folge', 'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {0, '1x'};                  % Treppe zunaechst ausgeblendet
al.BackgroundColor = [1 1 1];

% --- linkes Bild: Treppendiagramm (Zustandsachse x)
ax1 = uiaxes(al); ax1.Layout.Column = 1;
styleAx(ax1); hold(ax1,'on');
xlabel(ax1,'x'); ylabel(ax1,'f(x)');
ax1.DataAspectRatio = [1 1 1];
hDiag = plot(ax1, [-1e3 1e3], [-1e3 1e3], '-', 'Color', [0 0 0], 'LineWidth', 1.8);   % y = x
hF    = plot(ax1, NaN, NaN, '-', 'Color', colF, 'LineWidth', 3);                       % f
hTr   = plot(ax1, NaN, NaN, '--', 'Color', colX, 'LineWidth', 2.5);                    % Treppe
hTrD  = plot(ax1, NaN, NaN, ':', 'Color', colX, 'LineWidth', 1.5);                     % senkrecht zur x-Achse
hTrF  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 9, 'MarkerFaceColor', colF, 'MarkerEdgeColor', colF);
hTrX  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 12, 'MarkerFaceColor', colX, 'MarkerEdgeColor', colX, 'Clipping', 'off');
hFix  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 10, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0]);   % (x*, x*)
hDT   = text(ax1, NaN, NaN, 'y = x', 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold');
hFT   = text(ax1, NaN, NaN, '', 'Color', colF, 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold');
hTreppe = [hDiag hF hTr hTrD hTrF hTrX hDT hFT];
ax1.Visible = 'off'; set([hTreppe hFix], 'Visible', 'off');

% --- rechtes Bild: Zeitverlauf
ax2 = uiaxes(al); ax2.Layout.Column = 2;
styleAx(ax2); hold(ax2,'on');
xlabel(ax2,'n'); ylabel(ax2,'x_n');
xlim(ax2, [-0.5 nN+0.5]); ax2.XTick = 0:nN;
hStat = plot(ax2, [-1 nN+1], [NaN NaN], '--', 'Color', [0 0 0], 'LineWidth', 1.5, 'Visible', 'off');   % x*
hStatT = text(ax2, nN+0.4, NaN, 'x*', 'FontName', fName, 'FontSize', fSize-2, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Visible', 'off');
hSZ = plot(ax2, NaN, NaN, '--o', 'Color', colZ, 'LineWidth', 2, 'MarkerSize', 11, ...
    'MarkerFaceColor', colZ, 'MarkerEdgeColor', colZ);                  % kuenftige Glieder
hS  = plot(ax2, NaN, NaN, '--o', 'Color', colX, 'LineWidth', 2, 'MarkerSize', 13, ...
    'MarkerFaceColor', colX, 'MarkerEdgeColor', colX);                  % berechnete Glieder x_0 ... x_k

% --- Seitenleiste (vertikal zentriert durch '1x' oben und unten)
nCb = 1 + hatStat;
pl = uigridlayout(gl,[14 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Rand | Formel | Abstand | Drehknopf/-knoepfe | Titel | Abstand | x_0 | x_k | Abstand | Kaestchen | Abstand | Schritt | alle + reset | Rand
pl.RowHeight = {'1x', 50, 16, 220, 35, 16, 40, 40, 24, 34*nCb, 16, 40, 36, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

hFor = uilabel(pl,'Text','$\displaystyle \bf x_{n+1} = a\,x_n$', ...
    'FontSize',24,'HorizontalAlignment','center','Interpreter','latex');
hFor.Layout.Row = 2;

gK = uigridlayout(pl,[2 nP]);                % Drehknoepfe nebeneinander, Titel darunter
gK.Layout.Row = [4 5];
gK.RowHeight = {220, 35}; gK.ColumnWidth = repmat({'1x'},1,nP);
gK.RowSpacing = 4; gK.Padding = [0 0 0 0]; gK.BackgroundColor = [1 1 1];
kP = gobjects(1,nP);
for j = 1:nP
    kP(j) = uiknob(gK,'continuous','Limits',P(j).lim,'Value',P(j).def, ...
        'MajorTicks',P(j).tick,'MinorTicks',P(j).minor, ...
        'FontName',fName,'FontSize',20,'FontWeight','bold');
    kP(j).Layout.Row = 1; kP(j).Layout.Column = j;
    kP(j).ValueChangingFcn = @(~,evt) onP(j, evt.Value);
    kP(j).ValueChangedFcn  = @(src,~) onSnap(j, src);
    tK = uilabel(gK,'Text',['\bf ' P(j).name],'FontName',fName,'FontSize',20, ...
        'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
    tK.Layout.Row = 2; tK.Layout.Column = j;
end

g0 = uigridlayout(pl,[1 4]);                 % Startwert x_0 als Eingabefeld
g0.Layout.Row = 7;
g0.ColumnWidth = {'1x','fit',90,'1x'};
g0.ColumnSpacing = 8; g0.Padding = [0 0 0 0];
g0.BackgroundColor = [1 1 1];
lx0 = uilabel(g0,'Text',['x' char(8320) ' ='],'FontName',fName,'FontSize',22,'FontWeight','bold');
lx0.Layout.Column = 2;
sX0 = uispinner(g0,'Limits',X0.lim,'Step',X0.step,'Value',S.x0,'FontName',fName,'FontSize',20, ...
    'FontWeight','bold','ValueChangedFcn',@(src,~) onX0(src.Value));
sX0.Layout.Column = 3;

hVk = uilabel(pl,'Text','','FontName',fName,'FontSize',22,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hVk.Layout.Row = 8;

gC = uigridlayout(pl,[nCb 3]);               % Kaestchen, zentriert
gC.Layout.Row = 10;
gC.ColumnWidth = {'1x','fit','1x'}; gC.RowHeight = repmat({34},1,nCb);
gC.RowSpacing = 0; gC.Padding = [0 0 0 0]; gC.BackgroundColor = [1 1 1];
cbT = uicheckbox(gC,'Text','Treppe','Value',S.treppe,'FontName',fName,'FontSize',20,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onTreppe(src.Value));
cbT.Layout.Row = 1; cbT.Layout.Column = 2;
if hatStat
    cbS = uicheckbox(gC,'Text',['station' char(228) 'rer Zustand'],'Value',S.stat,'FontName',fName,'FontSize',20, ...
        'FontWeight','bold','ValueChangedFcn',@(src,~) onStat(src.Value));
    cbS.Layout.Row = 2; cbS.Layout.Column = 2;
end

bNext = uibutton(pl,'Text',['n' char(228) 'chster Schritt'],'FontName',fName,'FontSize',18, ...
    'FontWeight','bold','ButtonPushedFcn',@(~,~) onNext());
bNext.Layout.Row = 12;

g1 = uigridlayout(pl,[1 4]);                 % "alle Schritte" und dezentes reset
g1.Layout.Row = 13;
g1.ColumnWidth = {'1x','fit','fit','1x'};
g1.ColumnSpacing = 10; g1.Padding = [0 0 0 0];
g1.BackgroundColor = [1 1 1];
bAll = uibutton(g1,'Text','alle Schritte','FontName',fName,'FontSize',14, ...
    'FontColor',[0.45 0.45 0.45],'BackgroundColor',[0.97 0.97 0.97],'ButtonPushedFcn',@(~,~) onAll());
bAll.Layout.Column = 2;
bReset = uibutton(g1,'Text','reset','FontName',fName,'FontSize',14, ...
    'FontColor',[0.45 0.45 0.45],'BackgroundColor',[0.97 0.97 0.97], ...
    'Tooltip','x_0 = 1, a = 1.2, Schritt 0 (wie Folie)','ButtonPushedFcn',@(~,~) onReset());
bReset.Layout.Column = 3;

redraw();

%% ---------------- Callbacks ----------------
    function onP(j, v)
        S.p(j) = v;
        redraw();
    end

    function onSnap(j, src)
        src.Value = min(P(j).lim(2), max(P(j).lim(1), round(src.Value/P(j).snap)*P(j).snap));   % einrasten
        onP(j, src.Value);
    end

    function onX0(v)
        S.x0 = v;
        redraw();
    end

    function onNext()
        if S.k < nN, S.k = S.k + 1; redraw(); end
    end

    function onAll()
        S.k = nN; redraw();
    end

    function onReset()
        S.p = [P.def]; S.x0 = X0.def; S.k = 0;
        for jj = 1:nP, kP(jj).Value = P(jj).def; end
        sX0.Value = S.x0;
        redraw();
    end

    function onTreppe(v)
        S.treppe = v;
        if v
            al.ColumnWidth = {'1x','1x'}; ax1.Visible = 'on';  set(hTreppe, 'Visible', 'on');
        else
            al.ColumnWidth = {0, '1x'};   ax1.Visible = 'off'; set(hTreppe, 'Visible', 'off');
        end
        redraw();
    end

    function onStat(v)
        S.stat = v;
        redraw();
    end

%% ---------------- Zeichnen ----------------
    function [a, b] = koeff()
        a = S.p(1); b = 0;
    end

    function redraw()
        k = S.k; [a, b] = koeff();
        n = 0:nN; x = zeros(1, nN+1); x(1) = S.x0;
        for m = 1:nN, x(m+1) = a*x(m) + b; end                      % x_{n+1} = f(x_n) = a x_n + b
        hatFix = abs(1 - a) > 1e-9; if hatFix, xs = b/(1 - a); else, xs = NaN; end
        zeigeFix = hatStat && S.stat && hatFix;
        % gemeinsame Grenzen: x_n-Achse rechts = beide Achsen links (mindestens L0)
        v = x; if zeigeFix, v = [v xs]; end
        d = max(v) - min(v);
        L = [min(L0(1), min(v) - 0.06*d), max(L0(2), max(v) + 0.06*d)];
        ylim(ax2, L);
        % rechtes Bild
        set(hS,  'XData', n(1:k+1),   'YData', x(1:k+1));
        set(hSZ, 'XData', n(k+1:end), 'YData', x(k+1:end));
        onoff = {'off','on'};
        set(hStat, 'YData', [xs xs], 'Visible', onoff{1+zeigeFix});
        set(hStatT, 'Position', [nN+0.4, xs, 0], 'Visible', onoff{1+zeigeFix});
        % linkes Bild: Treppe
        xlim(ax1, L); ylim(ax1, L);
        set(hF, 'XData', L, 'YData', a*L + b);
        y0 = L(1);
        px = x(1); py = y0;
        for m = 1:k
            px = [px x(m) x(m+1)]; py = [py x(m+1) x(m+1)]; %#ok<AGROW>
        end
        set(hTr,  'XData', px, 'YData', py);
        set(hTrD, 'XData', [x(k+1) x(k+1)], 'YData', [y0 x(k+1)]);
        set(hTrF, 'XData', x(1:k), 'YData', x(2:k+1));
        set(hTrX, 'XData', x(1:k+1), 'YData', y0*ones(1,k+1));
        set(hFix, 'XData', xs, 'YData', xs, 'Visible', onoff{1+(zeigeFix && S.treppe)});
        % Beschriftungen: f am rechten Bildrand, y = x auf der anderen Seite der Diagonalen
        w = diff(L); xt = L(1) + 0.9*w; yt = a*xt + b;
        if a > 0 && yt > L(2) - 0.05*w, xt = (L(2) - 0.05*w - b)/a; yt = a*xt + b; end
        if a < 0 && yt < L(1) + 0.10*w, xt = (L(1) + 0.10*w - b)/a; yt = a*xt + b; end
        xl = xt - 0.3*w; yl = a*xl + b;
        hFT.String = ftext(a, b);
        if a >= 0 && yt >= xt                                         % f steigt, oberhalb von y = x: links oberhalb
            set(hFT, 'Position', [xt - 0.02*w, yt + 0.02*w, 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
        elseif a >= 0                                                 % f steigt, unterhalb von y = x: rechts unterhalb
            set(hFT, 'Position', [xl, yl - 0.04*w, 0], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        else                                                          % f faellt: rechts oberhalb
            set(hFT, 'Position', [xl, yl + 0.03*w, 0], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        end
        if yt >= xt                                                   % y = x auf der anderen Seite der Diagonalen
            set(hDT, 'Position', [L(1) + 0.97*w, L(1) + 0.82*w, 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
        else
            set(hDT, 'Position', [L(1) + 0.80*w, L(1) + 0.86*w, 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
        end
        % Seitenleiste
        hVk.Text = sprintf('\\bf x_{%d} = %s', k, fmt(x(k+1)));
        if k < nN, bNext.Enable = 'on'; else, bNext.Enable = 'off'; end
        drawnow limitrate
    end

%% ---------------- Hilfsfunktionen ----------------
    function t = ftext(a, b)
        % f(x) = a x + b lesbar: Faktor 1 und Summand 0 weglassen
        if abs(a - 1) < 1e-9, t = 'x'; elseif abs(a) < 1e-9, t = ''; else, t = [fmt(a) ' x']; end
        if abs(b) > 1e-9 || isempty(t)
            if isempty(t), t = fmt(b); elseif b > 0, t = [t ' + ' fmt(b)]; else, t = [t ' - ' fmt(-b)]; end
        end
        t = ['f(x) = ' t];
    end

    function t = fmt(v)
        % hoechstens 2 Nachkommastellen, ohne ueberfluessige Nullen
        t = sprintf('%.2f', v);
        t = regexprep(t, '0+$', ''); t = regexprep(t, '\.$', '');
        if strcmp(t, '-0'), t = '0'; end
    end

    function styleAx(ax)
        ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
        ax.Color = [1 1 1]; ax.Box = 'on'; ax.TickDir = 'in';
        disableDefaultInteractivity(ax); ax.Toolbar.Visible = 'off';
    end
end
