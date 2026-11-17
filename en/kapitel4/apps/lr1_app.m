function lr1_app
% LR1_APP  Interaktive App zum Luo-Rudy-I-Modell (Luo & Rudy, Circ Res 1991)
%
%   8 ODEs: Membranpotential V, Gating-Variablen m, h, j, d, f, X und
%   intrazellulaeres Calcium [Ca]_i.
%
%   C dV/dt = -(I_Na + I_si + I_K + I_K1 + I_Kp + I_b + I_stim)
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Zeit  : Kurve wird bis t gezeichnet (0-12 s, ohne Neuberechnung)
%     - Knopf G_si  : Leitfaehigkeit des langsamen Ca-Einwaertsstroms (mS/cm^2)
%     - Knopf G_K   : Leitfaehigkeit des zeitabhaengigen K-Stroms   (mS/cm^2)
%     - Knopf BCL   : Stimulationsperiode (ms)
%     - Voreinstellungen: Normal, EAD, Alternans
%     - Kontrollkaestchen: APD-Plot ein/aus
%
%   EADs:      G_K reduzieren (z.B. 0.113 statt 0.282), langsame Stimulation
%   Alternans: im EAD-Bereich schneller stimulieren (BCL ca. 1200-1600 ms):
%              Schlaege mit und ohne EAD wechseln sich ab (APD-Alternans),
%              vgl. Tran et al., Phys Rev Lett 102:258103 (2009).
%
%   Fuer MATLAB R2025b.

%% Feste Parameter
Tend  = 12000;     % Simulationsdauer (ms), feste Zeitachse 0-12 s
Istim = -50;       % Stimulusamplitude (uA/cm^2)
tstim = 1;         % Stimulusdauer (ms)
y0    = [-84.5; 0.0017; 0.98; 0.98; 0.003; 1.0; 0.0057; 2e-4];
options = odeset('RelTol',1e-6,'AbsTol',1e-8,'MaxStep',5);

% Voreinstellungen: [G_si, G_K, BCL]
preset.Normal    = [0.09, 0.282, 1000];
preset.EAD       = [0.09, 0.113, 2000];
preset.Alternans = [0.09, 0.113, 1400];

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colV  = [0.000 0.447 0.741];   % Membranpotential (blau)
colA  = [0.850 0.150 0.150];   % APD (rot)

%% Zustand
S.gsi = preset.Normal(1);
S.gk  = preset.Normal(2);
S.bcl = preset.Normal(3);
S.showAPD = false;
S.t   = Tend/1000;     % Zeitknopf (s), Start: ganze Kurve
S.T = []; S.V = []; S.apd = []; S.tdn = [];

%% GUI
fig = uifigure('Name','Luo-Rudy-I-Modell: Aktionspotential', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

% --- Achsen
al = uigridlayout(gl,[2 1]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x', 0};          % APD-Plot zunaechst aus
al.BackgroundColor = [1 1 1];

ax1 = mkAxes(al,1);
xlabel(ax1,'Zeit t (s)');
ylabel(ax1,'Membranpotential V (mV)');
ylim(ax1,[-95 55]);
xlim(ax1,[-0.3, Tend/1000+0.1]);   % etwas Vorlauf, damit der erste Upstroke sichtbar ist
hP = plot(ax1,NaN,NaN,'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle',':');
hV = plot(ax1,NaN,NaN,'Color',colV,'LineWidth',lw);
hM = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colV,'MarkerEdgeColor',colV);

ax2 = mkAxes(al,2);
xlabel(ax2,'Schlag n');
ylabel(ax2,'APD (ms)');
hA = plot(ax2,NaN,NaN,'--o','Color',colA,'LineWidth',lw, ...
    'MarkerSize',9,'MarkerFaceColor',colA);
ax2.Visible = 'off'; hA.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[17 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 115, 35, 10, 115, 35, 10, 115, 35, 10, 45, 10, 115, 35, 10, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kT = uiknob(pl,'continuous','Limits',[0 Tend/1000],'Value',S.t, ...
    'MajorTicks',0:2:Tend/1000,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 13;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,14,'Zeit t (s)');

kSi = uiknob(pl,'continuous','Limits',[0.05 0.15],'Value',S.gsi, ...
    'MajorTicks',0.05:0.025:0.15,'FontName',fName,'FontSize',16,'FontWeight','bold');
kSi.Layout.Row = 2;
kSi.ValueChangedFcn = @(src,~) onPar('gsi',src.Value);
mkLabel(pl,3,'G_{si} (mS/cm^2)');

kK = uiknob(pl,'continuous','Limits',[0.05 0.30],'Value',S.gk, ...
    'MajorTicks',0.05:0.05:0.30,'FontName',fName,'FontSize',16,'FontWeight','bold');
kK.Layout.Row = 5;
kK.ValueChangedFcn = @(src,~) onPar('gk',src.Value);
mkLabel(pl,6,'G_K (mS/cm^2)');

kB = uiknob(pl,'continuous','Limits',[300 2500],'Value',S.bcl, ...
    'MajorTicks',500:500:2500,'FontName',fName,'FontSize',16,'FontWeight','bold');
kB.Layout.Row = 8;
kB.ValueChangedFcn = @(src,~) onPar('bcl',src.Value);
mkLabel(pl,9,'Stimulationsperiode (ms)');

bl = uigridlayout(pl,[1 3]);
bl.Layout.Row = 11;
bl.Padding = [0 0 0 0];
bl.BackgroundColor = [1 1 1];
names = {'Normal','EAD','Alternans'};
for k = 1:3
    b = uibutton(bl,'Text',names{k},'FontName',fName,'FontSize',16, ...
        'FontWeight','bold','ButtonPushedFcn',@(~,~) onPreset(names{k}));
    b.Layout.Column = k;
end

cg = uigridlayout(pl,[1 3]);          % zentriert
cg.Layout.Row = 16;
cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0];
cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','APD-Plot anzeigen','Value',S.showAPD, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onAPD(src.Value);

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

    function onAPD(v)
        S.showAPD = v;
        if v
            al.RowHeight = {'2x','1x'};
            ax2.Visible = 'on';  hA.Visible = 'on';
        else
            al.RowHeight = {'1x', 0};
            ax2.Visible = 'off'; hA.Visible = 'off';
        end
    end

    function onPreset(name)
        p = preset.(name);
        S.gsi = p(1); S.gk = p(2); S.bcl = p(3);
        kSi.Value = S.gsi; kK.Value = S.gk; kB.Value = S.bcl;
        update();
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        fig.Pointer = 'watch'; drawnow
        [T,V] = simulate(S.gsi,S.gk,S.bcl);
        [T,iu] = unique(T,'stable'); V = V(iu);   % doppelte Zeitpunkte an Segmentgrenzen entfernen
        [S.apd,S.tdn] = computeAPD(T,V,-70);

        % Ruhepotential vor dem ersten Stimulus anhaengen (Vorlauf ab -0.3 s)
        S.T = [-0.3; T/1000];
        S.V = [y0(1); V];

        nmax = ceil((Tend-tstim)/S.bcl);
        xlim(ax2,[0.5, nmax+0.5]);
        ax2.XTick = 1:max(1,ceil(nmax/20)):nmax;    % nur ganzzahlige n
        if ~isempty(S.apd)
            ylim(ax2,[0, max(600, 100*ceil(1.1*max(S.apd)/100))]);
        end
        redraw();
        fig.Pointer = 'arrow';
    end

    function redraw()
        % Kurve nur bis zum Zeitpunkt t zeichnen
        idx = S.T <= S.t + 1e-9;
        set(hV,'XData',S.T(idx),'YData',S.V(idx));
        vt = interp1(S.T,S.V,min(S.t,S.T(end)));
        set(hM,'XData',S.t,'YData',vt);
        set(hP,'XData',[S.t S.t],'YData',[-95 55]);

        % APD nur fuer Schlaege, die bis t abgeschlossen sind
        k = find(S.tdn/1000 <= S.t + 1e-9);
        set(hA,'XData',k,'YData',S.apd(k));
        drawnow limitrate
    end

    function [T,V] = simulate(gsi,gk,bcl)
        y = y0; T = []; V = [];
        nb = ceil((Tend-tstim)/bcl);                % Anzahl Stimuli bis Tend
        for n = 0:nb-1
            t0 = n*bcl;
            [t1,y1] = ode15s(@(t,y) lr1rhs(t,y,gsi,gk,Istim),[t0 t0+tstim],y,options);
            y = y1(end,:)';
            [t2,y2] = ode15s(@(t,y) lr1rhs(t,y,gsi,gk,0),[t0+tstim min(t0+bcl,Tend)],y,options);
            y = y2(end,:)';
            T = [T; t1; t2(2:end)];          %#ok<AGROW>
            V = [V; y1(:,1); y2(2:end,1)];   %#ok<AGROW>
        end
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
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',22, ...
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end

%% ---------------- APD-Bestimmung ----------------
function [apd,tdn] = computeAPD(T,V,thr)
% Dauer zwischen Aufwaerts- und Abwaertsdurchgang durch thr (mV);
% tdn = Zeitpunkt der Repolarisation (ms)
up = find(V(1:end-1) <  thr & V(2:end) >= thr);
dn = find(V(1:end-1) >= thr & V(2:end) <  thr);
apd = []; tdn = [];
for i = 1:numel(up)
    d = dn(dn > up(i));
    if isempty(d), break, end
    tu = cross(T,V,up(i),thr);
    td = cross(T,V,d(1),thr);
    apd(end+1) = td - tu; %#ok<AGROW>
    tdn(end+1) = td;      %#ok<AGROW>
end
end

function tc = cross(T,V,i,thr)
tc = T(i) + (thr - V(i))*(T(i+1)-T(i))/(V(i+1)-V(i));
end

%% ---------------- Modell (Luo & Rudy 1991) ----------------
function dy = lr1rhs(~,y,Gsi,GK,Ist)
V = y(1); m = y(2); h = y(3); j = y(4);
d = y(5); f = y(6); X = y(7); Ca = y(8);

% Konzentrationen (mM) und Umkehrpotentiale (mV)
Ko = 5.4; Ki = 145; Nao = 140; Nai = 18;
RTF = 8314*310/96485;
ENa = RTF*log(Nao/Nai);
EK  = RTF*log((Ko + 0.01833*Nao)/(Ki + 0.01833*Nai));
EK1 = RTF*log(Ko/Ki);

% schneller Na-Strom
if abs(V+47.13) < 1e-6
    am = 3.2;
else
    am = 0.32*(V+47.13)/(1 - exp(-0.1*(V+47.13)));
end
bm = 0.08*exp(-V/11);
if V >= -40
    ah = 0;
    bh = 1/(0.13*(1 + exp((V+10.66)/(-11.1))));
    aj = 0;
    bj = 0.3*exp(-2.535e-7*V)/(1 + exp(-0.1*(V+32)));
else
    ah = 0.135*exp((80+V)/(-6.8));
    bh = 3.56*exp(0.079*V) + 3.1e5*exp(0.35*V);
    aj = (-1.2714e5*exp(0.2444*V) - 3.474e-5*exp(-0.04391*V)) ...
         *(V+37.78)/(1 + exp(0.311*(V+79.23)));
    bj = 0.1212*exp(-0.01052*V)/(1 + exp(-0.1378*(V+40.14)));
end
INa = 23*m^3*h*j*(V - ENa);

% langsamer Einwaertsstrom (Ca)
ad = 0.095*exp(-0.01*(V-5))/(1 + exp(-0.072*(V-5)));
bd = 0.07*exp(-0.017*(V+44))/(1 + exp(0.05*(V+44)));
af = 0.012*exp(-0.008*(V+28))/(1 + exp(0.15*(V+28)));
bf = 0.0065*exp(-0.02*(V+30))/(1 + exp(-0.2*(V+30)));
Esi = 7.7 - 13.0287*log(Ca);
Isi = Gsi*d*f*(V - Esi);

% zeitabhaengiger K-Strom
aX = 0.0005*exp(0.083*(V+50))/(1 + exp(0.057*(V+50)));
bX = 0.0013*exp(-0.06*(V+20))/(1 + exp(-0.04*(V+20)));
if V <= -100
    Xi = 1;
elseif abs(V+77) < 1e-6
    Xi = 2.837*0.04/exp(0.04*(V+35));
else
    Xi = 2.837*(exp(0.04*(V+77)) - 1)/((V+77)*exp(0.04*(V+35)));
end
IK = GK*sqrt(Ko/5.4)*X*Xi*(V - EK);

% zeitunabhaengiger K-Strom
aK1 = 1.02/(1 + exp(0.2385*(V - EK1 - 59.215)));
bK1 = (0.49124*exp(0.08032*(V - EK1 + 5.476)) + exp(0.06175*(V - EK1 - 594.31))) ...
      /(1 + exp(-0.5143*(V - EK1 + 4.753)));
IK1 = 0.6047*sqrt(Ko/5.4)*aK1/(aK1 + bK1)*(V - EK1);

% Plateau-K-Strom und Hintergrundstrom
IKp = 0.0183/(1 + exp((7.488 - V)/5.98))*(V - EK1);
Ib  = 0.03921*(V + 59.87);

dy = [ -(INa + Isi + IK + IK1 + IKp + Ib + Ist);
       am*(1-m) - bm*m;
       ah*(1-h) - bh*h;
       aj*(1-j) - bj*j;
       ad*(1-d) - bd*d;
       af*(1-f) - bf*f;
       aX*(1-X) - bX*X;
       -1e-4*Isi + 0.07*(1e-4 - Ca) ];
end
