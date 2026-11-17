function raeuber_beute_app
% RAEUBER_BEUTE_APP  Diskretes Raeuber-Beute-Modell (Kapitel II, Abschnitt 1)
%
%   dimensionslos (Folie "Variablentransformation", e = 1):
%       u_{n+1} = (1 + r) u_n - r u_n^2 - gamma u_n v_n      (Beute)
%       v_{n+1} = gamma u_n v_n                               (Raeuber)
%   Folien "Simulation des Raeuber-Beute-Modells": r = 3.1, gamma = 2.1 bzw. r = 2.5, gamma = 1.1; u_0 = 0.5, v_0 = 0.2.
%
%   Aufbau wie arithmetik_app / geometrik_app / linear_app (02.11.2026):
%   Rechtes Bild (immer): Zeitverlauf; berechnete Glieder kraeftig, kuenftige hell.
%   Linkes Bild (Kaestchen "Phasenebene"): Zustaende (u_n, v_n), hell = frueh, dunkel = spaet.
%   Kaestchen "Kompartimentschema": Schema mit den aktuellen Termen (ueber die ganze Bildflaeche).
%   Farben (Farbregel Kapitel II): Beute rot, Raeuber dunkelgrau.  Fuer MATLAB R2025b.
%   16.11.2026: Zeitregler n (vor- und zurueck), stationaerer Zustand (u*, v*) = (1/gamma, r(1 - 1/gamma)/gamma)
%   in der Phasenebene (fuer gamma > 1): schwarz gefuellt = stabil, offen = instabil (Eigenwerte der Jacobi-Matrix).

%% Parameter
nN    = 40;
P     = struct('name', {'r', '\gamma'}, 'lim', {[0 4], [0 3]}, 'tick', {0:1:4, 0:0.5:3}, ...
               'minor', {0:0.1:4, 0:0.1:3}, 'snap', {0.1, 0.1}, 'def', {3.1, 2.1});
fName = 'Times New Roman';
fSize = 24;
colB  = [0.64 0.08 0.18];        % Beute (Folgen-Rot)
colR  = [0.25 0.25 0.25];        % Raeuber (dunkelgrau)
hell  = @(c) 1 - 0.45*(1 - c);   % helle Variante fuer kuenftige Glieder

%% Zustand
S.p = [P.def]; S.u0 = 0.5; S.v0 = 0.2; S.k = 0;
S.phase = false; S.schema = false;

%% GUI
fig = uifigure('Name','Räuber-Beute-Modell','Color',[1 1 1],'WindowState','maximized');
gl = uigridlayout(fig,[1 2]); gl.ColumnWidth = {'1x', 340}; gl.BackgroundColor = [1 1 1];
al = uigridlayout(gl,[1 2]); al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {0, '1x'}; al.BackgroundColor = [1 1 1];

% --- linkes Bild: Phasenebene
ax1 = uiaxes(al); ax1.Layout.Column = 1; styleAx(ax1); hold(ax1,'on');
xlabel(ax1,'Beute u_n'); ylabel(ax1,'Räuber v_n');
hPh  = scatter(ax1, NaN, NaN, 60, NaN, 'filled');
hPhS = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0]);
hEq  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 14, 'LineWidth', 2.5, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', [0 0 0]);
hEqT = text(ax1, NaN, NaN, '(u^*, v^*)', 'FontName', fName, 'FontSize', fSize-6, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Interpreter', 'tex');
colormap(ax1, [linspace(0.97,0.45,256)' linspace(0.80,0.05,256)' linspace(0.82,0.12,256)']);   % hell = frueh, dunkel = spaet
ax1.Visible = 'off'; set([hPh hPhS hEq hEqT], 'Visible', 'off');

% --- rechtes Bild: Zeitverlauf
ax2 = uiaxes(al); ax2.Layout.Column = 2; styleAx(ax2); hold(ax2,'on');
xlabel(ax2,'n'); xlim(ax2,[-1 nN+1]);
hBz = plot(ax2, NaN, NaN, '--o', 'Color', hell(colB), 'LineWidth', 1.5, 'MarkerSize', 7, 'MarkerFaceColor', hell(colB), 'MarkerEdgeColor', hell(colB));
hRz = plot(ax2, NaN, NaN, '--s', 'Color', hell(colR), 'LineWidth', 1.5, 'MarkerSize', 7, 'MarkerFaceColor', hell(colR), 'MarkerEdgeColor', hell(colR));
hB  = plot(ax2, NaN, NaN, '--o', 'Color', colB, 'LineWidth', 2, 'MarkerSize', 9, 'MarkerFaceColor', colB, 'MarkerEdgeColor', colB);
hR  = plot(ax2, NaN, NaN, '--s', 'Color', colR, 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', colR, 'MarkerEdgeColor', colR);
legend(ax2, [hB hR], {'Beute u_n','Räuber v_n'}, 'Location','northeast','FontSize',fSize-4);

% --- Kompartimentschema (ueber die ganze Bildflaeche, statt der Bilder)
axS = uiaxes(gl); axS.Layout.Row = 1; axS.Layout.Column = 1;
axS.Visible = 'off'; axis(axS,'off'); hold(axS,'on'); disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';
xlim(axS,[0 100]); ylim(axS,[0 60]);

% --- Seitenleiste
pl = uigridlayout(gl,[14 1]); pl.Layout.Row = 1; pl.Layout.Column = 2;
pl.RowHeight = {'1x', 80, 16, 220, 35, 16, 40, 40, 70, 68, 16, 40, 36, '1x'};
pl.RowSpacing = 4; pl.BackgroundColor = [1 1 1];

hFor = uilabel(pl,'Text',['$\displaystyle \bf \begin{array}{l} u_{n+1} = (1+r)\,u_n - r\,u_n^2 - \gamma\,u_n v_n \\ ' ...
    'v_{n+1} = \gamma\,u_n v_n \end{array}$'],'FontSize',18,'HorizontalAlignment','center','Interpreter','latex');
hFor.Layout.Row = 2;

gK = uigridlayout(pl,[2 2]); gK.Layout.Row = [4 5];
gK.RowHeight = {220, 35}; gK.ColumnWidth = {'1x','1x'}; gK.RowSpacing = 4; gK.Padding = [0 0 0 0]; gK.BackgroundColor = [1 1 1];
kP = gobjects(1,2);
for j = 1:2
    kP(j) = uiknob(gK,'continuous','Limits',P(j).lim,'Value',P(j).def,'MajorTicks',P(j).tick,'MinorTicks',P(j).minor, ...
        'FontName',fName,'FontSize',16,'FontWeight','bold');
    kP(j).Layout.Row = 1; kP(j).Layout.Column = j;
    kP(j).ValueChangingFcn = @(~,evt) onP(j, evt.Value);
    kP(j).ValueChangedFcn  = @(src,~) onSnap(j, src);
    tK = uilabel(gK,'Text',['\bf ' P(j).name],'FontName',fName,'FontSize',20,'FontWeight','bold', ...
        'HorizontalAlignment','center','Interpreter','tex');
    tK.Layout.Row = 2; tK.Layout.Column = j;
end

g0 = uigridlayout(pl,[1 6]); g0.Layout.Row = 7;
g0.ColumnWidth = {'1x','fit',70,'fit',70,'1x'}; g0.ColumnSpacing = 6; g0.Padding = [0 0 0 0]; g0.BackgroundColor = [1 1 1];
l1 = uilabel(g0,'Text',['u' char(8320) ' ='],'FontName',fName,'FontSize',20,'FontWeight','bold'); l1.Layout.Column = 2;
sU = uispinner(g0,'Limits',[0.05 1.2],'Step',0.05,'Value',S.u0,'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onStart('u',src.Value)); sU.Layout.Column = 3;
l2 = uilabel(g0,'Text',['v' char(8320) ' ='],'FontName',fName,'FontSize',20,'FontWeight','bold'); l2.Layout.Column = 4;
sV = uispinner(g0,'Limits',[0.05 1.2],'Step',0.05,'Value',S.v0,'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onStart('v',src.Value)); sV.Layout.Column = 5;

hVk = uilabel(pl,'Text','','FontName',fName,'FontSize',20,'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
hVk.Layout.Row = 8;

% Zeitregler n (vor- und zurueckdrehen)
gT = uigridlayout(pl,[1 2]); gT.Layout.Row = 9;
gT.ColumnWidth = {'fit','1x'}; gT.ColumnSpacing = 12; gT.Padding = [10 0 14 0]; gT.BackgroundColor = [1 1 1];
lT = uilabel(gT,'Text','n','FontName',fName,'FontSize',20,'FontWeight','bold'); lT.Layout.Column = 1;
slN = uislider(gT,'Limits',[0 nN],'Value',S.k,'MajorTicks',0:10:nN,'MinorTicks',0:nN, ...
    'FontName',fName,'FontSize',14,'FontWeight','bold'); slN.Layout.Column = 2;
slN.ValueChangingFcn = @(~,evt) onTime(evt.Value, false);
slN.ValueChangedFcn  = @(src,~) onTime(src.Value, true);

gC = uigridlayout(pl,[2 3]); gC.Layout.Row = 10;
gC.ColumnWidth = {'1x','fit','1x'}; gC.RowHeight = {34, 34}; gC.RowSpacing = 0; gC.Padding = [0 0 0 0]; gC.BackgroundColor = [1 1 1];
cbP = uicheckbox(gC,'Text','Phasenebene','Value',S.phase,'FontName',fName,'FontSize',20,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onPhase(src.Value)); cbP.Layout.Row = 1; cbP.Layout.Column = 2;
cbS = uicheckbox(gC,'Text','Kompartimentschema','Value',S.schema,'FontName',fName,'FontSize',20,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onSchema(src.Value)); cbS.Layout.Row = 2; cbS.Layout.Column = 2;

bNext = uibutton(pl,'Text',['n' char(228) 'chster Schritt'],'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ButtonPushedFcn',@(~,~) onNext()); bNext.Layout.Row = 12;
g1 = uigridlayout(pl,[1 4]); g1.Layout.Row = 13;
g1.ColumnWidth = {'1x','fit','fit','1x'}; g1.ColumnSpacing = 10; g1.Padding = [0 0 0 0]; g1.BackgroundColor = [1 1 1];
bAll = uibutton(g1,'Text','alle Schritte','FontName',fName,'FontSize',14,'FontColor',[0.45 0.45 0.45], ...
    'BackgroundColor',[0.97 0.97 0.97],'ButtonPushedFcn',@(~,~) onAll()); bAll.Layout.Column = 2;
bReset = uibutton(g1,'Text','reset','FontName',fName,'FontSize',14,'FontColor',[0.45 0.45 0.45], ...
    'BackgroundColor',[0.97 0.97 0.97],'Tooltip','r = 3.1, \gamma = 2.1, u_0 = 0.5, v_0 = 0.2, Schritt 0 (wie Folie)', ...
    'ButtonPushedFcn',@(~,~) onReset()); bReset.Layout.Column = 3;

redraw();

%% ---------------- Callbacks ----------------
    function onP(j, v), S.p(j) = v; redraw(); end
    function onSnap(j, src)
        src.Value = min(P(j).lim(2), max(P(j).lim(1), round(src.Value/P(j).snap)*P(j).snap));
        onP(j, src.Value);
    end
    function onStart(w, v)
        if w == 'u', S.u0 = v; else, S.v0 = v; end
        redraw();
    end
    function onNext(), if S.k < nN, S.k = S.k + 1; slN.Value = S.k; redraw(); end, end
    function onAll(), S.k = nN; slN.Value = S.k; redraw(); end
    function onTime(v, snap)
        k = round(v);
        if snap, slN.Value = k; end
        if k ~= S.k, S.k = k; redraw(); end
    end
    function onReset()
        S.p = [P.def]; S.u0 = 0.5; S.v0 = 0.2; S.k = 0; slN.Value = 0;
        for jj = 1:2, kP(jj).Value = P(jj).def; end
        sU.Value = S.u0; sV.Value = S.v0; redraw();
    end
    function onPhase(v), S.phase = v; layout(); redraw(); end
    function onSchema(v), S.schema = v; layout(); redraw(); end

    function layout()
        if S.schema
            al.Visible = 'off'; axS.Visible = 'on';
        else
            al.Visible = 'on'; axS.Visible = 'off'; cla(axS);
            if S.phase
                al.ColumnWidth = {'1x','1x'}; ax1.Visible = 'on'; set([hPh hPhS hEq hEqT], 'Visible', 'on');
            else
                al.ColumnWidth = {0, '1x'}; ax1.Visible = 'off'; set([hPh hPhS hEq hEqT], 'Visible', 'off');
            end
        end
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        r = S.p(1); g = S.p(2); k = S.k;
        u = zeros(1, nN+1); v = u; u(1) = S.u0; v(1) = S.v0;
        for m = 1:nN
            u(m+1) = (1 + r)*u(m) - r*u(m)^2 - g*u(m)*v(m);
            v(m+1) = g*u(m)*v(m);
        end
        n = 0:nN;
        ok = all(isfinite([u v])) && all(abs([u v]) < 1e3);
        if ~ok, u(~isfinite(u) | abs(u) > 1e3) = NaN; v(~isfinite(v) | abs(v) > 1e3) = NaN; end
        set(hB,  'XData', n(1:k+1),   'YData', u(1:k+1));
        set(hR,  'XData', n(1:k+1),   'YData', v(1:k+1));
        set(hBz, 'XData', n(k+1:end), 'YData', u(k+1:end));
        set(hRz, 'XData', n(k+1:end), 'YData', v(k+1:end));
        top = max([1.1, u(isfinite(u)), v(isfinite(v))]); lo = min([0, u(isfinite(u)), v(isfinite(v))]);
        ylim(ax2, [lo - 0.03*(top - lo), top*1.08]);
        % Phasenebene: bis Schritt k, hell = frueh, dunkel = spaet
        set(hPh, 'XData', u(1:k+1), 'YData', v(1:k+1), 'CData', (0:k)');
        set(hPhS, 'XData', u(1), 'YData', v(1));
        % stationaerer Zustand mit Raeubern (nur fuer gamma > 1 positiv); Stabilitaet ueber die Jacobi-Matrix
        if g > 1
            us = 1/g; vs = r*(1 - 1/g)/g;
            J = [1 - r/g, -1; r*(1 - 1/g), 1];
            if all(abs(eig(J)) < 1), fc = [0 0 0]; else, fc = [1 1 1]; end
            set(hEq, 'XData', us, 'YData', vs, 'MarkerFaceColor', fc);
            set(hEqT, 'Position', [us + 0.02, vs + 0.02, 0]);
        else
            us = NaN; vs = NaN;
            set(hEq, 'XData', NaN, 'YData', NaN); set(hEqT, 'Position', [NaN NaN 0]);
        end
        uu = [u(isfinite(u)) us(isfinite(us))]; vv = [v(isfinite(v)) vs(isfinite(vs))];
        xlim(ax1, [min([0 uu]) max([1.1 uu])*1.05]); ylim(ax1, [min([0 vv]) max([1 vv])*1.05]);
        clim(ax1, [-nN/3 max(k,1)]);
        hVk.Text = sprintf('\\bf u_{%d} = %s,  v_{%d} = %s', k, fmt(u(k+1)), k, fmt(v(k+1)));
        if k < nN, bNext.Enable = 'on'; else, bNext.Enable = 'off'; end
        if S.schema, drawSchema(r, g); end
        drawnow limitrate
    end

    function drawSchema(r, g)
        cla(axS); fs = 24;
        sbox(30,25,20,12,'Beute','u_n', colB); sbox(70,25,20,12,'Räuber','v_n', colR);
        sink(40,52); arrow([40 49],[40 37]); txt(38,44,sprintf('%s u_n',fmt(r)),fs,'right'); txt(42,44,'Vermehrung',fs-6,'left');
        sink(8,31); arrow([30 31],[11 31]); txt(20,35,sprintf('%s u_n^2',fmt(r)),fs,'center'); txt(20,27,'Konkurrenz',fs-6,'center');
        sink(40,6); arrow([40 25],[40 9]); txt(38,17,sprintf('%s u_n v_n',fmt(g)),fs,'right'); txt(42,17,'Fraß',fs-6,'left');
        sink(80,52); arrow([80 49],[80 37]); txt(82,44,sprintf('%s u_n v_n',fmt(g)),fs,'left'); txt(78,44,'Zuwachs',fs-6,'right');
        sink(80,6); arrow([80 25],[80 9]); txt(82,17,'v_n',fs,'left'); txt(78,17,'Sterben (e = 1)',fs-6,'right');
        plot(axS,[50 70],[31 31],'--','Color',[0.5 0.5 0.5],'LineWidth',1.5); txt(60,33.5,'Nahrung',fs-8,'center');
        txt(50,58,'u_{n+1} - u_n = r u_n - r u_n^2 - \gamma u_n v_n,   v_{n+1} - v_n = \gamma u_n v_n - v_n',fs-4,'center');
        function sbox(x0,y0,w,h,ttl,var,c)
            rectangle(axS,'Position',[x0 y0 w h],'Curvature',[0.2 0.3],'FaceColor',1 - 0.12*(1 - c),'EdgeColor',c,'LineWidth',2.5);   % Kompartimentfarbe
            text(axS,x0+w/2,y0+h*0.68,ttl,'HorizontalAlignment','center','FontName',fName,'FontSize',fs-2,'FontWeight','bold','Color',c);
            text(axS,x0+w/2,y0+h*0.28,var,'HorizontalAlignment','center','FontName',fName,'FontSize',fs,'FontWeight','bold','Color',c);
        end
        function sink(x,y)
            text(axS,x,y,char(8709),'HorizontalAlignment','center','FontName',fName,'FontSize',fs+4,'FontWeight','bold');
        end
        function arrow(p,q)
            d = q - p; L = norm(d); e = d/L; nrm = [-e(2) e(1)];
            plot(axS,[p(1) q(1)-2.2*e(1)],[p(2) q(2)-2.2*e(2)],'k','LineWidth',2);
            tip = [q; q - 2.6*e + 1.1*nrm; q - 2.6*e - 1.1*nrm];
            patch(axS,tip(:,1),tip(:,2),'k','EdgeColor','k');
        end
        function txt(x,y,s,f,ha)
            text(axS,x,y,['\bf ' s],'HorizontalAlignment',ha,'FontName',fName,'FontSize',f,'Interpreter','tex');
        end
    end

%% ---------------- Hilfsfunktionen ----------------
    function t = fmt(v)
        if ~isfinite(v), t = '-'; return, end
        t = sprintf('%.3f', v); t = regexprep(t, '0+$', ''); t = regexprep(t, '\.$', '');
        if strcmp(t, '-0'), t = '0'; end
    end
    function styleAx(ax)
        ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
        ax.Color = [1 1 1]; ax.Box = 'on'; ax.TickDir = 'in';
        disableDefaultInteractivity(ax); ax.Toolbar.Visible = 'off';
    end
end
