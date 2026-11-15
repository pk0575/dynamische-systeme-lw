function fieber_app
% FIEBER_APP  Fieber als verstellter Sollwert der Temperaturregelung
%
%   Didaktisches Modell (plausible Groessenordnungen, kein publizierter
%   Parametersatz). Zeit t in Stunden.
%
%   Infektion und Immunantwort:
%     dE/dt = r(T)*E*(1-E) - kI*A*E          Erreger (relativ, 0..1)
%     dA/dt = a*E*(A+eps) - dA*A              Immunzellen
%     dP/dt = kI*A*E - dP*P                   Pyrogene (Botenstoffe)
%     r(T)  = r0*max(0, 1 - beta*(T-37))      Fieber bremst die Erreger
%
%   Sollwert im Hypothalamus:
%     dTs/dt = (37 + gam*H(P)*(1-F(t)) - Ts)/tauS,  H(P) = P^n/(P^n+K^n)
%     F(t)   = Wirkung des Fiebersenkers (0..fmax)
%
%   Waermebilanz des Koerpers (Regelkreis, Regelabweichung e = Ts - T):
%     dT/dt = M0 - h*(T-Tu) + min(gs*max(e,0),Smax) - min(gw*max(-e,0),Wmax)
%             Grundumsatz  Waermeabgabe   Kaeltezittern        Schwitzen
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Staerke der Immunabwehr
%     - Knopf Umgebungstemperatur (°C)
%     - Schalter Fiebersenker (Tablette ab 38.5 °C, dann alle 6 h, 4 Dosen)
%     - Knopf Zeit (h)
%     - Kontrollkaestchen: Erreger & Immunantwort anzeigen
%
%   Fuer MATLAB R2025b.

%% Parameter
P.r0 = 0.35; P.beta = 0.25; P.kI = 0.5; P.eps = 0.01; P.dA = 0.005;
P.dP = 0.7;  P.gam = 3.2;   P.K = 0.04; P.n = 6;      P.tauS = 0.3;
P.M0 = 1.2;  P.h = 0.08;    P.gs = 3.0; P.Smax = 1.2; P.gw = 3.0; P.Wmax = 3.0;
P.fmax = 0.7; P.tauF = 2.0; P.E0 = 1e-3;
P.Tthr = 38.5;              % Tablette ab dieser Temperatur
nDose  = 4; dDose = 6;      % Anzahl Tabletten, Abstand (h)

Tend = 72;                  % Simulationsdauer (h)
dt   = 0.05;
options = odeset('RelTol',1e-7,'AbsTol',1e-10,'MaxStep',0.05);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colT  = [0.850 0.150 0.150];   % Koerpertemperatur (rot)
colS  = [0 0 0];               % Sollwert (schwarz, gestrichelt)
colK  = [0.75 0.90 1.00];      % Kaeltezittern (hellblau)
colW  = [1.00 0.88 0.70];      % Schwitzen (hellorange)
colE  = [0.466 0.674 0.188];   % Erreger (gruen)
colA  = [0.000 0.447 0.741];   % Immunzellen (blau)
yL    = [35.5 41.5];

%% Zustand
S.a     = 0.25;     % Immunabwehr
S.Tu    = 22;       % Umgebungstemperatur
S.med   = false;
S.t     = Tend;
S.show  = false;
S.tt = []; S.Y = []; S.doses = [];

%% GUI
fig = uifigure('Name','Fieber – Temperaturregelung bei Infektion', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[2 1]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x', 0};
al.BackgroundColor = [1 1 1];

ax1 = mkAxes(al,1);
xlabel(ax1,'Zeit t (h)');
ylabel(ax1,'Temperatur (°C)');
xlim(ax1,[0 Tend]); ylim(ax1,yL);
ax1.XTick = 0:12:Tend;
ax1.Layer = 'top';

hBand = gobjects(0);
hKleg = patch(ax1,NaN,NaN,colK,'EdgeColor','none','DisplayName','Kältezittern');
hWleg = patch(ax1,NaN,NaN,colW,'EdgeColor','none','DisplayName','Schwitzen');
hS = plot(ax1,NaN,NaN,'--','Color',colS,'LineWidth',lw,'DisplayName','Sollwert');
hT = plot(ax1,NaN,NaN,'-','Color',colT,'LineWidth',lw+1,'DisplayName','Körpertemperatur');
hD = plot(ax1,NaN,NaN,'v','MarkerSize',12,'MarkerFaceColor',[0.3 0.3 0.3], ...
    'MarkerEdgeColor',[0.3 0.3 0.3],'DisplayName','Tablette');
hP = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hM = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colT, ...
    'MarkerEdgeColor',colT,'HandleVisibility','off');
lg1 = legend(ax1,[hT hS hKleg hWleg hD]);
set(lg1,'Location','northeast','FontSize',fSize-6,'FontName',fName);

ax2 = mkAxes(al,2);
xlabel(ax2,'Zeit t (h)');
ylabel(ax2,'relative Menge');
xlim(ax2,[0 Tend]); ylim(ax2,[0 1.05]);
ax2.XTick = 0:12:Tend;
hE = plot(ax2,NaN,NaN,'-','Color',colE,'LineWidth',lw,'DisplayName','Erreger');
hA = plot(ax2,NaN,NaN,'-','Color',colA,'LineWidth',lw,'DisplayName','Immunzellen');
lg2 = legend(ax2,[hE hA]);
set(lg2,'Location','northeast','FontSize',fSize-6,'FontName',fName);
ax2.Visible = 'off'; hE.Visible = 'off'; hA.Visible = 'off'; lg2.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[14 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 115, 35, 10, 115, 35, 10, 55, 35, 10, 115, 35, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kA = uiknob(pl,'continuous','Limits',[0.1 0.5],'Value',S.a, ...
    'MajorTicks',[0.1 0.3 0.5],'MajorTickLabels',{'schwach','mittel','stark'}, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kA.Layout.Row = 2;
kA.ValueChangedFcn = @(src,~) onPar('a',src.Value);
mkLabel(pl,3,'Immunabwehr');

kU = uiknob(pl,'continuous','Limits',[15 35],'Value',S.Tu, ...
    'MajorTicks',15:5:35,'FontName',fName,'FontSize',16,'FontWeight','bold');
kU.Layout.Row = 5;
kU.ValueChangedFcn = @(src,~) onPar('Tu',src.Value);
mkLabel(pl,6,'Umgebungstemperatur (°C)');

sw = uiswitch(pl,'slider','Items',{'aus','ein'},'ItemsData',{false,true}, ...
    'Value',S.med,'FontName',fName,'FontSize',18,'FontWeight','bold');
sw.Layout.Row = 8;
sw.ValueChangedFcn = @(src,~) onPar('med',src.Value);
mkLabel(pl,9,'Fiebersenker');

kT = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:12:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 11;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,12,'Zeit t (h)');

cg = uigridlayout(pl,[1 3]);          % zentriert
cg.Layout.Row = 13;
cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0];
cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','Erreger & Immunantwort','Value',S.show, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onShow(src.Value);

% Startlösung
update();

%% ---------------- Callbacks ----------------
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
            al.RowHeight = {'2x','1x'};
            st = 'on';
        else
            al.RowHeight = {'1x', 0};
            st = 'off';
        end
        ax2.Visible = st; hE.Visible = st; hA.Visible = st; lg2.Visible = st;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        fig.Pointer = 'watch'; drawnow
        Q = P; Q.a = S.a;

        % Ruhezustand ohne Infektion bei dieser Umgebungstemperatur
        [~,y] = ode45(@(t,y) rhs(t,y,Q,S.Tu,[]),[0 48],[0;0;0;37;37],options);
        y0 = [Q.E0; 0; 0; y(end,4); y(end,5)];

        tt = (0:dt:Tend)';
        [~,Y] = ode45(@(t,y) rhs(t,y,Q,S.Tu,[]),tt,y0,options);
        doses = [];
        if S.med
            i = find(Y(:,5) > Q.Tthr, 1);       % Tablette, sobald T > 38.5 °C
            if ~isempty(i)
                doses = tt(i) + (0:nDose-1)*dDose;
                [~,Y] = ode45(@(t,y) rhs(t,y,Q,S.Tu,doses),tt,y0,options);
            end
        end
        S.tt = tt; S.Y = Y; S.doses = doses;

        drawBands();
        redraw();
        fig.Pointer = 'arrow';
    end

    function drawBands()
        % Phasen mit Kaeltezittern (e > 0.25) bzw. Schwitzen (e < -0.25)
        delete(hBand); hBand = gobjects(0);
        e = S.Y(:,4) - S.Y(:,5);
        addBands(e >  0.25, colK);
        addBands(e < -0.25, colW);
        if ~isempty(hBand), uistack(hBand,'bottom'); end
    end

    function addBands(mask,col)
        d = diff([0; mask(:); 0]);
        s = find(d == 1); f = find(d == -1) - 1;
        for i = 1:numel(s)
            a = S.tt(s(i)); b = S.tt(f(i));
            hBand(end+1) = patch(ax1,[a b b a],yL([1 1 2 2]),col, ...
                'EdgeColor','none','HandleVisibility','off','UserData',[a b]); %#ok<AGROW>
        end
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        tt = S.tt(idx);
        set(hT,'XData',tt,'YData',S.Y(idx,5));
        set(hS,'XData',tt,'YData',S.Y(idx,4));
        set(hE,'XData',tt,'YData',S.Y(idx,1));
        Amax = max(S.Y(:,2));
        set(hA,'XData',tt,'YData',S.Y(idx,2)/max(Amax,eps));
        for i = 1:numel(hBand)               % Phasen nur bis t zeigen
            ab = hBand(i).UserData;
            hBand(i).Visible = ab(1) <= S.t;
            b  = min(ab(2),S.t);
            hBand(i).XData = [ab(1) b b ab(1)];
        end
        dz = S.doses(S.doses <= S.t);
        set(hD,'XData',dz,'YData',(yL(2)-0.35)*ones(size(dz)));
        Tt = interp1(S.tt,S.Y(:,5),S.t);
        set(hM,'XData',S.t,'YData',Tt);
        set(hP,'XData',[S.t S.t],'YData',yL);
        drawnow limitrate
    end

    function ax = mkAxes(parent,row)
        ax = uiaxes(parent);
        ax.Layout.Row = row; ax.Layout.Column = 1;
        ax.FontSize   = fSize;
        ax.FontWeight = 'bold';
        ax.FontName   = fName;
        ax.Color      = [1 1 1];
        ax.Box        = 'on';
        hold(ax,'on')
    end

    function mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end

%% ---------------- Modell ----------------
function dy = rhs(t,y,P,Tu,doses)
E = y(1); A = y(2); Pyr = y(3); Ts = y(4); T = y(5);

% Infektion und Immunantwort
r   = P.r0*max(0, 1 - P.beta*(T - 37));
dE  = r*E*(1-E) - P.kI*A*E;
dA  = P.a*E*(A + P.eps) - P.dA*A;
dPy = P.kI*A*E - P.dP*Pyr;

% Fiebersenker: Wirkung jeder Dosis steigt an und klingt wieder ab
s = 0;
for ti = doses
    if t > ti
        u = (t - ti)/P.tauF;
        s = s + u*exp(1 - u);
    end
end
F = P.fmax*min(s,1);

% Sollwert
H   = Pyr^P.n/(Pyr^P.n + P.K^P.n);
dTs = (37 + P.gam*H*(1 - F) - Ts)/P.tauS;

% Waermebilanz mit Regelung
e  = Ts - T;
dT = P.M0 - P.h*(T - Tu) + min(P.gs*max(e,0),P.Smax) - min(P.gw*max(-e,0),P.Wmax);

dy = [dE; dA; dPy; dTs; dT];
end
