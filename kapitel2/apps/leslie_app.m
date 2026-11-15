function leslie_app
% LESLIE_APP  Leslie-Modell mit drei Altersklassen (Kapitel II, Abschnitte 2 und 3)
%
%   x_{1,n+1} = b_1 x_{1,n} + b_2 x_{2,n} + b_3 x_{3,n},  x_{2,n+1} = s_1 x_{1,n},  x_{3,n+1} = s_2 x_{2,n}
%   Folie "Beispiel": b = (0, 0, 9), s = (0.1, 0.6), x_0 = (0, 0, 1000) -> pulsiert mit Periode 3 und stirbt aus.
%   Anzeige R = b_1 + b_2 s_1 + b_3 s_1 s_2 (Nachwuchs eines Neugeborenen im Lauf seines Lebens):
%   R > 1 Wachstum, R < 1 Aussterben (Folie "Schwellenwert im Leslie-Modell").
%
%   Aufbau wie arithmetik_app / raeuber_beute_app (02.11.2026):
%   Rechtes Bild: Zeitverlauf der drei Klassen (rot, dunkelgrau, ocker), berechnete Glieder kraeftig, kuenftige hell.
%   Kaestchen: "Gesamtpopulation" (schwarz), "Altersverteilung" (Anteile der Klassen, linkes Bild),
%   "Kompartimentschema" (mit den aktuellen Zahlen, ueber die ganze Bildflaeche).
%   Seitenleiste: Eingabefelder b_1, b_2, b_3, s_1, s_2 und Startwerte, "naechster Schritt", "alle Schritte", "reset".
%   Fuer MATLAB R2025b.

%% Parameter
nN    = 30;
fName = 'Times New Roman';
fSize = 24;
colK  = {[163 20 46]/255, [64 64 64]/255, [204 121 20]/255};    % Klassen 1..3: feste Palette Kapitel II (rot, dunkelgrau, ocker)
hell  = @(c) 1 - 0.45*(1 - c);
DEF   = struct('b', [0 0 9], 's', [0.1 0.6], 'x0', [0 0 1000]);

%% Zustand
S = DEF; S.k = 0; S.ges = false; S.vert = false; S.schema = false;

%% GUI
fig = uifigure('Name','Leslie-Modell','Color',[1 1 1],'WindowState','maximized');
gl = uigridlayout(fig,[1 2]); gl.ColumnWidth = {'1x', 340}; gl.BackgroundColor = [1 1 1];
al = uigridlayout(gl,[1 2]); al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {0, '1x'}; al.BackgroundColor = [1 1 1];

% --- linkes Bild: Altersverteilung (Anteile)
ax1 = uiaxes(al); ax1.Layout.Column = 1; styleAx(ax1); hold(ax1,'on');
xlabel(ax1,'n'); ylabel(ax1,'Anteil der Klasse'); xlim(ax1,[-1 nN+1]); ylim(ax1,[0 1]);
hV = gobjects(1,3);
for i = 1:3
    hV(i) = plot(ax1, NaN, NaN, '--o', 'Color', colK{i}, 'LineWidth', 1.8, 'MarkerSize', 7, ...
        'MarkerFaceColor', colK{i}, 'MarkerEdgeColor', colK{i});
end
legend(ax1, hV, {'Klasse 1','Klasse 2','Klasse 3'}, 'Location','northeast','FontSize',fSize-6);
ax1.Visible = 'off'; set(hV, 'Visible', 'off');

% --- rechtes Bild: Zeitverlauf
ax2 = uiaxes(al); ax2.Layout.Column = 2; styleAx(ax2); hold(ax2,'on');
xlabel(ax2,'n'); xlim(ax2,[-1 nN+1]);
hZ = gobjects(1,3); hK = gobjects(1,3);
for i = 1:3
    hZ(i) = plot(ax2, NaN, NaN, '--o', 'Color', hell(colK{i}), 'LineWidth', 1.4, 'MarkerSize', 6, ...
        'MarkerFaceColor', hell(colK{i}), 'MarkerEdgeColor', hell(colK{i}));
    hK(i) = plot(ax2, NaN, NaN, '--o', 'Color', colK{i}, 'LineWidth', 2, 'MarkerSize', 8, ...
        'MarkerFaceColor', colK{i}, 'MarkerEdgeColor', colK{i});
end
hG = plot(ax2, NaN, NaN, '-', 'Color', [0 0 0], 'LineWidth', 2.5, 'Visible', 'off');
legend(ax2, [hK hG], {'Klasse 1','Klasse 2','Klasse 3','gesamt'}, 'Location','northeast','FontSize',fSize-6);

% --- Kompartimentschema (ueber die ganze Bildflaeche)
axS = uiaxes(gl); axS.Layout.Row = 1; axS.Layout.Column = 1;
axS.Visible = 'off'; axis(axS,'off'); hold(axS,'on'); disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';
xlim(axS,[0 100]); ylim(axS,[0 60]);

% --- Seitenleiste
pl = uigridlayout(gl,[13 1]); pl.Layout.Row = 1; pl.Layout.Column = 2;
pl.RowHeight = {'1x', 60, 16, 150, 16, 40, 40, 24, 102, 16, 40, 36, '1x'};
pl.RowSpacing = 4; pl.BackgroundColor = [1 1 1];

hFor = uilabel(pl,'Text','$\displaystyle \bf \mathbf{x}_{n+1} = \mathbf{L}\,\mathbf{x}_n$', ...
    'FontSize',24,'HorizontalAlignment','center','Interpreter','latex');
hFor.Layout.Row = 2;

gP = uigridlayout(pl,[4 4]); gP.Layout.Row = 4;
gP.ColumnWidth = {'fit','1x','fit','1x'}; gP.RowHeight = {34,34,34,34}; gP.ColumnSpacing = 6; gP.RowSpacing = 4;
gP.Padding = [0 0 0 0]; gP.BackgroundColor = [1 1 1];
sB = gobjects(1,3); sS = gobjects(1,2); sX = gobjects(1,3);
for i = 1:3
    mkLab(gP, i, 1, sprintf('b%s', char(8320+i)));
    sB(i) = uispinner(gP,'Limits',[0 20],'Step',0.5,'Value',S.b(i),'FontName',fName,'FontSize',18,'FontWeight','bold', ...
        'ValueChangedFcn',@(src,~) onPar('b',i,src.Value)); sB(i).Layout.Row = i; sB(i).Layout.Column = 2;
    mkLab(gP, i, 3, sprintf('x%s,%s', char(8320+i), char(8320)));
    sX(i) = uispinner(gP,'Limits',[0 10000],'Step',100,'Value',S.x0(i),'FontName',fName,'FontSize',18,'FontWeight','bold', ...
        'ValueChangedFcn',@(src,~) onPar('x',i,src.Value)); sX(i).Layout.Row = i; sX(i).Layout.Column = 4;
end
for i = 1:2
    mkLab(gP, 4, 2*i-1, sprintf('s%s', char(8320+i)));
    sS(i) = uispinner(gP,'Limits',[0 1],'Step',0.05,'Value',S.s(i),'FontName',fName,'FontSize',18,'FontWeight','bold', ...
        'ValueChangedFcn',@(src,~) onPar('s',i,src.Value)); sS(i).Layout.Row = 4; sS(i).Layout.Column = 2*i;
end

hR = uilabel(pl,'Text','','FontName',fName,'FontSize',20,'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
hR.Layout.Row = 6;
hVk = uilabel(pl,'Text','','FontName',fName,'FontSize',18,'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
hVk.Layout.Row = 7;

gC = uigridlayout(pl,[3 3]); gC.Layout.Row = 9;
gC.ColumnWidth = {'1x','fit','1x'}; gC.RowHeight = {34,34,34}; gC.RowSpacing = 0; gC.Padding = [0 0 0 0]; gC.BackgroundColor = [1 1 1];
cbG = mkCheck(gC, 1, 'Gesamtpopulation', @(v) onCheck('ges', v));
cbV = mkCheck(gC, 2, 'Altersverteilung', @(v) onCheck('vert', v));
cbS = mkCheck(gC, 3, 'Kompartimentschema', @(v) onCheck('schema', v)); %#ok<NASGU>

bNext = uibutton(pl,'Text',['n' char(228) 'chster Schritt'],'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ButtonPushedFcn',@(~,~) onNext()); bNext.Layout.Row = 11;
g1 = uigridlayout(pl,[1 4]); g1.Layout.Row = 12;
g1.ColumnWidth = {'1x','fit','fit','1x'}; g1.ColumnSpacing = 10; g1.Padding = [0 0 0 0]; g1.BackgroundColor = [1 1 1];
bAll = uibutton(g1,'Text','alle Schritte','FontName',fName,'FontSize',14,'FontColor',[0.45 0.45 0.45], ...
    'BackgroundColor',[0.97 0.97 0.97],'ButtonPushedFcn',@(~,~) onAll()); bAll.Layout.Column = 2;
bReset = uibutton(g1,'Text','reset','FontName',fName,'FontSize',14,'FontColor',[0.45 0.45 0.45], ...
    'BackgroundColor',[0.97 0.97 0.97],'Tooltip','Werte wie Folie "Beispiel", Schritt 0', ...
    'ButtonPushedFcn',@(~,~) onReset()); bReset.Layout.Column = 3;

redraw();

%% ---------------- Callbacks ----------------
    function onPar(w, i, v)
        switch w
            case 'b', S.b(i) = v;
            case 's', S.s(i) = v;
            case 'x', S.x0(i) = v;
        end
        redraw();
    end
    function onCheck(w, v)
        S.(w) = v;
        if S.schema
            al.Visible = 'off'; axS.Visible = 'on';
        else
            al.Visible = 'on'; axS.Visible = 'off'; cla(axS);
            if S.vert
                al.ColumnWidth = {'1x','1x'}; ax1.Visible = 'on'; set(hV, 'Visible', 'on');
            else
                al.ColumnWidth = {0, '1x'}; ax1.Visible = 'off'; set(hV, 'Visible', 'off');
            end
        end
        redraw();
    end
    function onNext(), if S.k < nN, S.k = S.k + 1; redraw(); end, end
    function onAll(), S.k = nN; redraw(); end
    function onReset()
        S.b = DEF.b; S.s = DEF.s; S.x0 = DEF.x0; S.k = 0;
        for ii = 1:3, sB(ii).Value = S.b(ii); sX(ii).Value = S.x0(ii); end
        for ii = 1:2, sS(ii).Value = S.s(ii); end
        redraw();
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        L = [S.b; S.s(1) 0 0; 0 S.s(2) 0];
        X = zeros(3, nN+1); X(:,1) = S.x0(:);
        for m = 1:nN, X(:,m+1) = L*X(:,m); end
        n = 0:nN; k = S.k; G = sum(X, 1);
        for i = 1:3
            set(hK(i), 'XData', n(1:k+1),   'YData', X(i,1:k+1));
            set(hZ(i), 'XData', n(k+1:end), 'YData', X(i,k+1:end));
            q = X(i,1:k+1) ./ max(G(1:k+1), eps); q(G(1:k+1) == 0) = NaN;
            set(hV(i), 'XData', n(1:k+1), 'YData', q);
        end
        set(hG, 'XData', n(1:k+1), 'YData', G(1:k+1), 'Visible', onoff(S.ges));
        if S.ges, top = max(G); else, top = max(X(:)); end
        ylim(ax2, [0 max(top, 1)*1.08]);
        R = S.b(1) + S.b(2)*S.s(1) + S.b(3)*S.s(1)*S.s(2);
        if R > 1, txt = 'Wachstum'; elseif R < 1, txt = 'Aussterben'; else, txt = 'Grenzfall'; end
        hR.Text = sprintf('\\bf R = b_1 + b_2 s_1 + b_3 s_1 s_2 = %s  (%s)', fmt(R), txt);
        hVk.Text = sprintf('\\bf n = %d:  x = (%s, %s, %s)', k, fmt(X(1,k+1)), fmt(X(2,k+1)), fmt(X(3,k+1)));
        if k < nN, bNext.Enable = 'on'; else, bNext.Enable = 'off'; end
        if S.schema, drawSchema(); end
        drawnow limitrate
    end

    function drawSchema()
        cla(axS); fs = 24; xc = [20 50 80]; yc = 34;
        for i = 1:3
            rectangle(axS,'Position',[xc(i)-9 yc-6 18 12],'Curvature',[0.2 0.3],'FaceColor',1 - 0.12*(1 - colK{i}), ...
                'EdgeColor',colK{i},'LineWidth',2.5);   % Kompartimentfarbe
            text(axS,xc(i),yc+2,sprintf('Klasse %d',i),'HorizontalAlignment','center','FontName',fName,'FontSize',fs-2, ...
                'FontWeight','bold','Color',colK{i});
            text(axS,xc(i),yc-3,sprintf('x_{%d,n}',i),'HorizontalAlignment','center','FontName',fName,'FontSize',fs, ...
                'FontWeight','bold','Color',colK{i});
        end
        for i = 1:2
            arrow([xc(i)+9 yc],[xc(i+1)-9 yc],'-'); txtb((xc(i)+xc(i+1))/2, yc+3, sprintf('s_%d = %s', i, fmt(S.s(i))), fs);
        end
        for i = 1:3                                           % Nachwuchs b_i zurueck in Klasse 1 (gestrichelt)
            if S.b(i) == 0, continue, end
            if i == 1
                t = linspace(0, pi, 40); px = 20 + 5*cos(t); py = yc + 6 + 9*sin(t);
            else
                t = linspace(0, pi, 60); px = (xc(i) + 20)/2 + (xc(i) - 20)/2*cos(t); py = yc - 6 - (6 + 6*(i-1))*sin(t);
            end
            plot(axS, px, py, '--k', 'LineWidth', 2);
            q = [px(end) py(end)]; p = [px(end-3) py(end-3)]; arrowHead(p, q);
            [~, im] = max(abs(py - yc)); txtb(px(im), py(im) + 3*sign(py(im) - yc), sprintf('b_%d = %s', i, fmt(S.b(i))), fs);
        end
        txtb(50, 4, 'gestrichelt: Nachwuchs (Klasse 1),  durchgezogen: Überleben (nächste Klasse)', fs-8);
        function arrow(p, q, ~)
            plot(axS,[p(1) q(1)],[p(2) q(2)],'k','LineWidth',2); arrowHead(p, q);
        end
        function arrowHead(p, q)
            d = q - p; e = d/norm(d); nrm = [-e(2) e(1)];
            tip = [q; q - 2.6*e + 1.1*nrm; q - 2.6*e - 1.1*nrm];
            patch(axS,tip(:,1),tip(:,2),'k','EdgeColor','k');
        end
        function txtb(x, y, s, f)
            text(axS,x,y,['\bf ' s],'HorizontalAlignment','center','FontName',fName,'FontSize',f,'Interpreter','tex');
        end
    end

%% ---------------- Hilfsfunktionen ----------------
    function s = onoff(v), if v, s = 'on'; else, s = 'off'; end, end
    function t = fmt(v)
        if abs(v) >= 100, t = sprintf('%.0f', v); return, end
        t = sprintf('%.2f', v); t = regexprep(t, '0+$', ''); t = regexprep(t, '\.$', '');
    end
    function mkLab(parent, r, c, txt)
        h = uilabel(parent,'Text',[txt ' ='],'FontName',fName,'FontSize',18,'FontWeight','bold','HorizontalAlignment','right');
        h.Layout.Row = r; h.Layout.Column = c;
    end
    function cbx = mkCheck(parent, r, txt, cb)
        cbx = uicheckbox(parent,'Text',txt,'Value',false,'FontName',fName,'FontSize',20,'FontWeight','bold', ...
            'ValueChangedFcn',@(src,~) cb(src.Value));
        cbx.Layout.Row = r; cbx.Layout.Column = 2;
    end
    function styleAx(ax)
        ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
        ax.Color = [1 1 1]; ax.Box = 'on'; ax.TickDir = 'in';
        disableDefaultInteractivity(ax); ax.Toolbar.Visible = 'off';
    end
end
