function sir_app
% SIR_APP  Diskretes SIR-Modell (Kapitel II, Abschnitt "Nichtlineare Systeme: SIR-Modell")
%
%       S_{n+1} = S_n - beta S_n I_n + alpha (N - S_n)
%       I_{n+1} = (1 - gamma - alpha) I_n + beta S_n I_n
%       R_{n+1} = R_n + gamma I_n - alpha R_n,       N = 100000,  beta = R_0 (gamma + alpha) / N
%   Folien: alpha = gamma = 0.1; Szenario A: R_0 = 0.6, S_0 = 70000, I_0 = 30000; Szenario B: R_0 = 3.8, I_0 = 1.
%
%   Aufbau wie raeuber_beute_app (02.11.2026):
%   Rechtes Bild (immer): Zeitverlauf S_n, I_n, R_n (in Tausend); berechnete Glieder kraeftig, kuenftige hell;
%                         stationärer Zustand gestrichelt.
%   Linkes Bild (Kaestchen "Phasenebene"): Zustaende (S_n, I_n), hell = frueh, dunkel = spaet; x_a* (Kreis), x_b* (Kreuz).
%   Kaestchen "Kompartimentschema": Schema mit den aktuellen Termen (ueber die ganze Bildflaeche).
%   Farben (Farbregel Kapitel II): S rot, I dunkelgrau, R ocker.  Fuer MATLAB R2025b.

%% Parameter
nN    = 80;
NN    = 1e5;
P     = struct('name', {'R_0', '\alpha'}, 'lim', {[0 5], [0 0.5]}, 'tick', {0:1:5, 0:0.1:0.5}, ...
               'minor', {0:0.1:5, 0:0.02:0.5}, 'snap', {0.1, 0.01}, 'def', {3.8, 0.1});
fName = 'Times New Roman';
fSize = 24;
colS  = [163 20 46]/255;         % empfaenglich (rot)
colI  = [64 64 64]/255;          % infektioes (dunkelgrau)
colR  = [204 121 20]/255;        % genesen (ocker)
hell  = @(c) 1 - 0.45*(1 - c);   % helle Variante fuer kuenftige Glieder

%% Zustand
S.p = [P.def]; S.g = 0.1; S.I0 = 1; S.k = 0;
S.phase = false; S.schema = false;

%% GUI
fig = uifigure('Name','SIR-Modell','Color',[1 1 1],'WindowState','maximized');
gl = uigridlayout(fig,[1 2]); gl.ColumnWidth = {'1x', 340}; gl.BackgroundColor = [1 1 1];
al = uigridlayout(gl,[1 2]); al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {0, '1x'}; al.BackgroundColor = [1 1 1];

% --- linkes Bild: Phasenebene (S_n, I_n)
ax1 = uiaxes(al); ax1.Layout.Column = 1; styleAx(ax1); hold(ax1,'on');
xlabel(ax1,'S_n (in Tausend)'); ylabel(ax1,'I_n (in Tausend)');
hPhL = plot(ax1, NaN, NaN, '-', 'Color', [0.75 0.75 0.75], 'LineWidth', 1.2);
hPh  = scatter(ax1, NaN, NaN, 60, NaN, 'filled');
hXa  = plot(ax1, NaN, NaN, 'o', 'MarkerSize', 14, 'LineWidth', 2.5, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', [0 0 0]);
hXb  = plot(ax1, NaN, NaN, 'x', 'MarkerSize', 18, 'LineWidth', 3, 'Color', [0 0 0]);
colormap(ax1, [linspace(0.97,0.45,256)' linspace(0.80,0.05,256)' linspace(0.82,0.12,256)']);   % hell = frueh, dunkel = spaet
ax1.Visible = 'off'; set([hPhL hPh hXa hXb], 'Visible', 'off');

% --- rechtes Bild: Zeitverlauf (in Tausend)
ax2 = uiaxes(al); ax2.Layout.Column = 2; styleAx(ax2); hold(ax2,'on');
xlabel(ax2,'n'); ylabel(ax2,'in Tausend'); xlim(ax2,[-1 nN+1]); ylim(ax2,[-3 108]);
hSt = gobjects(1,3); hZ = gobjects(1,3); hA = gobjects(1,3);
cols = {colS, colI, colR}; mk = {'o','s','d'};
for j = 1:3
    hSt(j) = plot(ax2, NaN, NaN, '--', 'Color', [0 0 0], 'LineWidth', 1.2);
    hZ(j)  = plot(ax2, NaN, NaN, ['--' mk{j}], 'Color', hell(cols{j}), 'LineWidth', 1.2, 'MarkerSize', 5, ...
                  'MarkerFaceColor', hell(cols{j}), 'MarkerEdgeColor', hell(cols{j}));
    hA(j)  = plot(ax2, NaN, NaN, ['--' mk{j}], 'Color', cols{j}, 'LineWidth', 1.8, 'MarkerSize', 6, ...
                  'MarkerFaceColor', cols{j}, 'MarkerEdgeColor', cols{j});
end
legend(ax2, hA, {'empfänglich S_n','infektiös I_n','genesen R_n'}, 'Location','east','FontSize',fSize-4);

% --- Kompartimentschema (ueber die ganze Bildflaeche, statt der Bilder)
axS = uiaxes(gl); axS.Layout.Row = 1; axS.Layout.Column = 1;
axS.Visible = 'off'; axis(axS,'off'); hold(axS,'on'); disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';
xlim(axS,[0 100]); ylim(axS,[0 60]);

% --- Seitenleiste
pl = uigridlayout(gl,[15 1]); pl.Layout.Row = 1; pl.Layout.Column = 2;
pl.RowHeight = {'1x', 110, 16, 220, 35, 12, 40, 40, 34, 24, 68, 16, 40, 36, '1x'};
pl.RowSpacing = 4; pl.BackgroundColor = [1 1 1];

hFor = uilabel(pl,'Text',['$\displaystyle \bf \begin{array}{l} S_{n+1} = S_n - \beta\,S_n I_n + \alpha\,(N - S_n) \\ ' ...
    'I_{n+1} = (1-\gamma-\alpha)\,I_n + \beta\,S_n I_n \\ R_{n+1} = R_n + \gamma\,I_n - \alpha\,R_n \end{array}$'], ...
    'FontSize',16,'HorizontalAlignment','center','Interpreter','latex');
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
g0.ColumnWidth = {'1x','fit',70,'fit',90,'1x'}; g0.ColumnSpacing = 6; g0.Padding = [0 0 0 0]; g0.BackgroundColor = [1 1 1];
l1 = uilabel(g0,'Text',[char(947) ' ='],'FontName',fName,'FontSize',20,'FontWeight','bold'); l1.Layout.Column = 2;
sG = uispinner(g0,'Limits',[0.01 0.5],'Step',0.01,'Value',S.g,'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onStart('g',src.Value)); sG.Layout.Column = 3;
l2 = uilabel(g0,'Text',['I' char(8320) ' ='],'FontName',fName,'FontSize',20,'FontWeight','bold'); l2.Layout.Column = 4;
sI = uispinner(g0,'Limits',[1 99999],'Step',1,'Value',S.I0,'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ValueDisplayFormat','%.0f','ValueChangedFcn',@(src,~) onStart('i',src.Value)); sI.Layout.Column = 5;

hInfo = uilabel(pl,'Text','','FontName',fName,'FontSize',18,'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
hInfo.Layout.Row = 8;
hVk = uilabel(pl,'Text','','FontName',fName,'FontSize',18,'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
hVk.Layout.Row = 9;

gC = uigridlayout(pl,[2 3]); gC.Layout.Row = 11;
gC.ColumnWidth = {'1x','fit','1x'}; gC.RowHeight = {34, 34}; gC.RowSpacing = 0; gC.Padding = [0 0 0 0]; gC.BackgroundColor = [1 1 1];
cbP = uicheckbox(gC,'Text','Phasenebene','Value',S.phase,'FontName',fName,'FontSize',20,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onPhase(src.Value)); cbP.Layout.Row = 1; cbP.Layout.Column = 2;
cbS = uicheckbox(gC,'Text','Kompartimentschema','Value',S.schema,'FontName',fName,'FontSize',20,'FontWeight','bold', ...
    'ValueChangedFcn',@(src,~) onSchema(src.Value)); cbS.Layout.Row = 2; cbS.Layout.Column = 2;

bNext = uibutton(pl,'Text',['n' char(228) 'chster Schritt'],'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'ButtonPushedFcn',@(~,~) onNext()); bNext.Layout.Row = 13;
g1 = uigridlayout(pl,[1 4]); g1.Layout.Row = 14;
g1.ColumnWidth = {'1x','fit','fit','1x'}; g1.ColumnSpacing = 10; g1.Padding = [0 0 0 0]; g1.BackgroundColor = [1 1 1];
bAll = uibutton(g1,'Text','alle Schritte','FontName',fName,'FontSize',14,'FontColor',[0.45 0.45 0.45], ...
    'BackgroundColor',[0.97 0.97 0.97],'ButtonPushedFcn',@(~,~) onAll()); bAll.Layout.Column = 2;
bReset = uibutton(g1,'Text','reset','FontName',fName,'FontSize',14,'FontColor',[0.45 0.45 0.45], ...
    'BackgroundColor',[0.97 0.97 0.97],'Tooltip','R_0 = 3.8, \alpha = \gamma = 0.1, I_0 = 1, Schritt 0 (Szenario B)', ...
    'ButtonPushedFcn',@(~,~) onReset()); bReset.Layout.Column = 3;

redraw();

%% ---------------- Callbacks ----------------
    function onP(j, v), S.p(j) = v; redraw(); end
    function onSnap(j, src)
        src.Value = min(P(j).lim(2), max(P(j).lim(1), round(src.Value/P(j).snap)*P(j).snap));
        onP(j, src.Value);
    end
    function onStart(w, v)
        if w == 'g', S.g = v; else, S.I0 = round(v); end
        redraw();
    end
    function onNext(), if S.k < nN, S.k = S.k + 1; redraw(); end, end
    function onAll(), S.k = nN; redraw(); end
    function onReset()
        S.p = [P.def]; S.g = 0.1; S.I0 = 1; S.k = 0;
        for jj = 1:2, kP(jj).Value = P(jj).def; end
        sG.Value = S.g; sI.Value = S.I0; redraw();
    end
    function onPhase(v), S.phase = v; layout(); redraw(); end
    function onSchema(v), S.schema = v; layout(); redraw(); end

    function layout()
        if S.schema
            al.Visible = 'off'; axS.Visible = 'on';
        else
            al.Visible = 'on'; axS.Visible = 'off'; cla(axS);
            if S.phase
                al.ColumnWidth = {'1x','1x'}; ax1.Visible = 'on'; set([hPhL hPh hXa hXb], 'Visible', 'on');
            else
                al.ColumnWidth = {0, '1x'}; ax1.Visible = 'off'; set([hPhL hPh hXa hXb], 'Visible', 'off');
            end
        end
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        R0 = S.p(1); a = S.p(2); g = S.g; k = S.k;
        b = R0*(g + a)/NN;
        X = zeros(3, nN+1); X(:,1) = [NN - S.I0; S.I0; 0];
        for m = 1:nN
            s = X(1,m); i = X(2,m); r = X(3,m);
            X(:,m+1) = [s - b*s*i + a*(NN - s); (1 - g - a)*i + b*s*i; r + g*i - a*r];
        end
        % stationaerer Zustand, der angesteuert wird
        if R0 > 1
            stS = NN/R0; stI = a*(NN - stS)/(g + a); xs = [stS; stI; NN - stS - stI]; zust = 'endemisch';
        else
            xs = [NN; 0; 0]; zust = 'krankheitsfrei';
        end
        n = 0:nN; Y = X/1000;
        for j = 1:3
            set(hA(j),  'XData', n(1:k+1),   'YData', Y(j,1:k+1));
            set(hZ(j),  'XData', n(k+1:end), 'YData', Y(j,k+1:end));
            set(hSt(j), 'XData', [-1 nN+1],  'YData', xs(j)/1000*[1 1]);
        end
        top = max([105, Y(:)']); lo = min([0, Y(:)']); ylim(ax2, [lo - 3, top*1.03]);
        % Phasenebene
        set(hPhL, 'XData', Y(1,1:k+1), 'YData', Y(2,1:k+1));
        set(hPh,  'XData', Y(1,1:k+1), 'YData', Y(2,1:k+1), 'CData', (0:k)');
        set(hXa,  'XData', NN/1000, 'YData', 0);
        if R0 > 1, set(hXb, 'XData', xs(1)/1000, 'YData', xs(2)/1000); else, set(hXb, 'XData', NaN, 'YData', NaN); end
        xlim(ax1, [min([0 Y(1,:)]) 108]); ylim(ax1, [-4 max([10 Y(2,:)])*1.08]);
        clim(ax1, [-nN/3 max(k,1)]);
        hInfo.Text = sprintf('\\bf \\beta = %s\\cdot10^{-6} (%s)', fmt(b*1e6), zust);
        hVk.Text = sprintf('\\bf S_{%d} = %s,  I_{%d} = %s,  R_{%d} = %s', k, fmt0(X(1,k+1)), k, fmt0(X(2,k+1)), k, fmt0(X(3,k+1)));
        if k < nN, bNext.Enable = 'on'; else, bNext.Enable = 'off'; end
        if S.schema, drawSchema(a, b, g); end
        drawnow limitrate
    end

    function drawSchema(a, b, g)
        cla(axS); fs = 22;
        sbox(6,24,20,12,'empfänglich','S_n', colS); sbox(40,24,20,12,'infektiös','I_n', colI); sbox(74,24,20,12,'genesen','R_n', colR);
        sink(16,54); arrow([16 51],[16 36.5]); txt(14,45,sprintf('%s N',fmt(a)),fs,'right'); txt(18,45,'Geburt',fs-6,'left');
        arrow([26 30],[40 30]); txt(33,33,sprintf('%s\\cdot10^{-6} S_n I_n',fmt(b*1e6)),fs-4,'center'); txt(33,27,'Infektion',fs-6,'center');
        arrow([60 30],[74 30]); txt(67,33,sprintf('%s I_n',fmt(g)),fs,'center'); txt(67,27,'Genesung',fs-6,'center');
        dn(16,'S_n'); dn(50,'I_n'); dn(84,'R_n');
        txt(50,58,sprintf('R_0 = \\beta N / (\\gamma + \\alpha) = %s', fmt(b*NN/(g + a))),fs-2,'center');
        function dn(x,v)
            sink(x,6); arrow([x 24],[x 9]); txt(x-2,16,sprintf('%s %s',fmt(a),v),fs,'right'); txt(x+2,16,'Tod',fs-6,'left');
        end
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
    function t = fmt0(v)
        if ~isfinite(v), t = '-'; else, t = sprintf('%.0f', v); end
    end
    function styleAx(ax)
        ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
        ax.Color = [1 1 1]; ax.Box = 'on'; ax.TickDir = 'in';
        disableDefaultInteractivity(ax); ax.Toolbar.Visible = 'off';
    end
end
