function fischerei_app
% FISCHEREI_APP  Ueberfischung: logistisches Wachstum mit Befischung
%
%   dN/dt = r*N*(1 - N/K) - Fang(N)
%
%   Fangstrategie
%     feste Quote:     Fang = H                (H in 1000 t/Jahr)
%     fester Aufwand:  Fang = F*N              (F = Anteil des Bestands pro Jahr)
%
%   Maximaler nachhaltiger Ertrag (MSY): r*K/4 bei N = K/2.
%   Bei fester Quote H > r*K/4 gibt es kein Gleichgewicht mehr: der Bestand
%   bricht zusammen (Kipppunkt, Sattel-Knoten-Bifurkation). Auch bei H < r*K/4
%   kollabiert der Bestand, wenn er unter das instabile Gleichgewicht faellt.
%
%   Bedienelemente (Seitenleiste):
%     - Schalter Fangstrategie: Quote / Aufwand
%     - Knopf Fangquote bzw. Fischereiintensitaet
%     - Knopf Startbestand
%     - Knopf Zeit (Jahre)
%     - Kontrollkaestchen: Wachstumskurve (dN/dt ueber N) anzeigen
%
%   Fuer MATLAB R2025b.

%% Parameter
r    = 0.5;        % Wachstumsrate (1/Jahr)
K    = 100;        % Kapazitaet (1000 t)
Tend = 50;         % Jahre
dt   = 0.05;
epsN = 0.2;        % Fang wird bei leerem Bestand weich auf 0 gesetzt
options = odeset('RelTol',1e-6,'AbsTol',1e-8,'MaxStep',0.1);

MSY = r*K/4;       % 12.5 (1000 t/Jahr)

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colN  = [0.000 0.447 0.741];   % Bestand (blau)
colH  = [0.850 0.150 0.150];   % Fang (rot)
colG  = [0.5 0.5 0.5];

%% Zustand
S.mode = 'quote';              % 'quote' oder 'aufwand'
S.H    = 10;                   % Quote (1000 t/Jahr)
S.F    = 0.2;                  % Intensitaet (1/Jahr)
S.N0   = 80;                   % Startbestand (1000 t)
S.t    = Tend;
S.show = false;
S.tt = []; S.N = [];

%% GUI
fig = uifigure('Name','Überfischung – Bestand und Fangquote', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- Zeitverlauf
ax1 = mkAxes(al,1);
xlabel(ax1,'Zeit t (Jahre)');
ylabel(ax1,'Fischbestand N (1000 t)');
xlim(ax1,[0 Tend]); ylim(ax1,[-2 K+10]);
yline(ax1,K,'--','Kapazität K','Color',colG,'LineWidth',1.5, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold','HandleVisibility','off');
yline(ax1,K/2,':','K/2 (MSY-Bestand)','Color',colG,'LineWidth',1.5, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'LabelVerticalAlignment','bottom','HandleVisibility','off');
hN = plot(ax1,NaN,NaN,'-','Color',colN,'LineWidth',lw+1);
hP = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hM = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colN,'MarkerEdgeColor',colN);

% --- Wachstumskurve dN/dt ueber N
ax2 = mkAxes(al,2);
xlabel(ax2,'Fischbestand N (1000 t)');
ylabel(ax2,'Rate (1000 t/Jahr)');
xlim(ax2,[0 K+5]); ylim(ax2,[0 22]);
Ng = linspace(0,K,400);
hG  = plot(ax2,Ng,r*Ng.*(1-Ng/K),'-','Color',colN,'LineWidth',lw, ...
    'DisplayName','Nachwuchs rN(1-N/K)');
hH  = plot(ax2,NaN,NaN,'-','Color',colH,'LineWidth',lw,'DisplayName','Fang');
hEs = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[0 0 0], ...
    'MarkerEdgeColor',[0 0 0],'DisplayName','stabil');
hEu = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[1 1 1], ...
    'MarkerEdgeColor',[0 0 0],'LineWidth',2,'DisplayName','instabil');
hM2 = plot(ax2,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colN, ...
    'MarkerEdgeColor',colN,'HandleVisibility','off');
lg2 = legend(ax2,[hG hH hEs hEu]);
set(lg2,'Location','north','FontSize',fSize-8,'FontName',fName);
setVis2('off');

% --- Seitenleiste
pl = uigridlayout(gl,[15 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 55, 35, 10, 115, 35, 10, 115, 35, 10, 115, 35, 10, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

sw = uiswitch(pl,'slider','Items',{'Quote','Aufwand'},'ItemsData',{'quote','aufwand'}, ...
    'Value',S.mode,'FontName',fName,'FontSize',18,'FontWeight','bold');
sw.Layout.Row = 2;
sw.ValueChangedFcn = @(src,~) onMode(src.Value);
mkLabel(pl,3,'Fangstrategie');

kH = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
kH.Layout.Row = 5;
kH.ValueChangingFcn = @(~,evt) onH(evt.Value);   % live beim Drehen
kH.ValueChangedFcn  = @(src,~) onH(src.Value);
lH = mkLabel(pl,6,'');

kN = uiknob(pl,'continuous','Limits',[0 K],'Value',S.N0, ...
    'MajorTicks',0:20:K,'FontName',fName,'FontSize',16,'FontWeight','bold');
kN.Layout.Row = 8;
kN.ValueChangingFcn = @(~,evt) onPar('N0',evt.Value);
kN.ValueChangedFcn  = @(src,~) onPar('N0',src.Value);
mkLabel(pl,9,'Startbestand (1000 t)');

kT = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:10:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 11;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,12,'Zeit t (Jahre)');

cg = uigridlayout(pl,[1 3]);          % zentriert
cg.Layout.Row = 14;
cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0];
cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','Wachstumskurve anzeigen','Value',S.show, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onShow(src.Value);

setKnob();
update();

%% ---------------- Callbacks ----------------
    function onMode(v)
        S.mode = v;
        setKnob();
        update();
    end

    function onH(v)
        if strcmp(S.mode,'quote'), S.H = v; else, S.F = v; end
        update();
    end

    function onPar(name,v)
        S.(name) = v;
        update();
    end

    function onTime(v)
        S.t = v;
        redraw();
    end

    function onShow(v)
        S.show = v;
        if v
            al.ColumnWidth = {'1x','1x'};
            setVis2('on');
        else
            al.ColumnWidth = {'1x', 0};
            setVis2('off');
        end
    end

    function setKnob()
        % Knopf je nach Strategie umbelegen
        if strcmp(S.mode,'quote')
            kH.Limits = [0 20]; kH.MajorTicks = 0:5:20; kH.Value = S.H;
            lH.Text = 'Fangquote (1000 t/Jahr)';
        else
            kH.Limits = [0 0.6]; kH.MajorTicks = 0:0.1:0.6; kH.Value = S.F;
            lH.Text = 'Fischereiintensität (1/Jahr)';
        end
    end

    function setVis2(st)
        ax2.Visible = st; hG.Visible = st; hH.Visible = st;
        hEs.Visible = st; hEu.Visible = st; hM2.Visible = st; lg2.Visible = st;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        tt = (0:dt:Tend)';
        [~,y] = ode45(@(t,N) rhs(N),tt,S.N0,options);
        S.tt = tt; S.N = max(y(:,1),0);

        % Fangkurve und Gleichgewichte in der Wachstumskurve
        if strcmp(S.mode,'quote')
            set(hH,'XData',[0 K],'YData',[S.H S.H]);
            D = 1 - 4*S.H/(r*K);
            if D >= 0
                Nlo = K/2*(1 - sqrt(D)); Nhi = K/2*(1 + sqrt(D));
                set(hEs,'XData',[0 Nhi],'YData',[0 S.H]);      % N=0: Bestand erloschen
                set(hEu,'XData',Nlo,'YData',S.H);
            else
                set(hEs,'XData',0,'YData',0);
                set(hEu,'XData',NaN,'YData',NaN);
            end
        else
            set(hH,'XData',[0 K],'YData',[0 S.F*K]);
            if S.F < r
                Ns = K*(1 - S.F/r);
                set(hEs,'XData',Ns,'YData',S.F*Ns);
                set(hEu,'XData',0,'YData',0);
            else
                set(hEs,'XData',0,'YData',0);
                set(hEu,'XData',NaN,'YData',NaN);
            end
        end
        redraw();
    end

    function dN = rhs(N)
        N = max(N,0);
        if strcmp(S.mode,'quote')
            fang = S.H*N/(N + epsN);         % leerer Bestand: kein Fang mehr
        else
            fang = S.F*N;
        end
        dN = r*N*(1 - N/K) - fang;
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        set(hN,'XData',S.tt(idx),'YData',S.N(idx));
        Nt = interp1(S.tt,S.N,S.t);
        set(hM,'XData',S.t,'YData',Nt);
        set(hP,'XData',[S.t S.t],'YData',[-2 K+10]);
        g = r*Nt*(1 - Nt/K);
        set(hM2,'XData',Nt,'YData',g);
        drawnow limitrate
    end

    function ax = mkAxes(parent,col)
        ax = uiaxes(parent);
        ax.Layout.Row = 1; ax.Layout.Column = col;
        ax.FontSize   = fSize;
        ax.FontWeight = 'bold';
        ax.FontName   = fName;
        ax.Color      = [1 1 1];
        ax.Box        = 'on';
        hold(ax,'on')
    end

    function h = mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end
