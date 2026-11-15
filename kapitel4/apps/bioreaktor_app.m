function bioreaktor_app
% BIOREAKTOR_APP  Chemostat (kontinuierlicher Bioreaktor) mit Monod-,
%   Haldane- und Contois-Kinetik, Bezeichnungen wie auf den Folien
%   (Kapitel IV, Abschnitt 4; Zahlenwerte seit 13.11.2026)
%
%   db/dt = K(n,b)*b - D*b                     Biomasse b (g/l)
%   dn/dt = -nu*K(n,b)*b - D*n + D*n_in        Naehrstoff n (g/l)
%
%   Wachstumsrate K:
%     Monod:   K = kmax*n/(k50 + n)
%     Haldane: K = kmax*n/(k50 + n + n^2/Ki)   (Substrathemmung)
%     Contois: K = kmax*n/(Kc*b + n)           (dichteabhaengig)
%
%   Start mit frischem Medium: n(0) = n_in, Animpfmenge b(0) per Knopf.
%
%   Bedienelemente (Seitenleiste):
%     - Drehschalter Kinetik: Monod / Haldane / Contois
%     - Knopf Verduennungsrate D (1/h)
%     - Knopf Zulaufkonzentration n_in (g/l)
%     - Knopf Animpfmenge b_0 (g/l, logarithmisch)
%     - Knopf Zeit (h)
%     - Kontrollkaestchen: alle Kinetiken vergleichen
%     - Kontrollkaestchen: Bifurkationsdiagramm (stationaere Zustaende ueber D)
%
%   Bifurkationen:
%     Monod/Contois: transkritisch beim Auswaschen (Monod: D_c = K(n_in)).
%     Haldane: zusaetzlich Sattel-Knoten-Bifurkation -> Bistabilitaet:
%       fuer K(n_in) < D < max K haengt es von der Animpfmenge ab, ob die
%       Kultur ueberlebt oder ausgewaschen wird (Hysterese). Beispiel mit
%       n_in = 10: D = 0.4 und b_0 = 1 -> Auswaschen, b_0 = 2 -> b* = 4.8.
%
%   Ist D groesser als die maximal moegliche Wachstumsrate, werden die
%   Bakterien ausgewaschen (b -> 0, n -> n_in).
%
%   Farben nach den Farbregeln: Zeitverlaeufe rot, Vergleichskurven grau,
%   Bifurkationsdiagramm dunkelgruen (stabil durchgezogen, instabil gestrichelt).
%
%   Fuer MATLAB R2025b.

%% Parameter (wie Folien: nu = 2 g Naehrstoff pro g Biomasse, kmax = 1/h, k50 = 0.5 g/l)
nus = 2; amax = 1; Ki = 5; Kc = 0.1; Km = 0.5;
Tend = 30;
options = odeset('RelTol',1e-6,'AbsTol',[1e-8; 1e-8]);   % schnell genug fuer Live-Drehen
names = {'Monod','Haldane','Contois'};
styles = {'-','--','-.'};

% Stil
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.639 0.078 0.180];   % Biomasse (rot 163/20/46)
colS  = [0.639 0.078 0.180];   % Naehrstoff (rot)
colG  = [0.55 0.55 0.55];      % Vergleichskurven (grau)
colB  = [0 0.392 0];           % Bifurkationsdiagramm (dunkelgruen 0/100/0)
Dg    = (0:0.002:1.2)';        % D-Gitter fuer Bifurkationsdiagramm

%% Zustand
S.kin  = 'Monod';
S.D    = 0.2;
S.Sin  = 10;
S.t    = Tend;
S.comp = false;
S.logX0 = log10(0.1);      % Animpfmenge b_0 = 0.1 g/l
S.bif  = false;
S.tt = linspace(0,Tend,501)';
S.busy = false; S.pending = false;
S.X  = zeros(501,3); S.Sub = zeros(501,3);

%% GUI
fig = uifigure('Name','Bioreaktor (Chemostat)', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[2 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x','1x'};
al.ColumnWidth = {'1x', 0};      % Bifurkationsdiagramm zunaechst aus
al.BackgroundColor = [1 1 1];

ax1 = mkAxes(al,1);
xlabel(ax1,'t (h)');
ylabel(ax1,'Biomasse b(t) (g/l)');
xlim(ax1,[-0.2 Tend+0.2]);
ylim(ax1,[0 12.5]);          % feste Achse: b <= (n_in + nu*b_0)/nu <= 12

ax2 = mkAxes(al,2);
xlabel(ax2,'t (h)');
ylabel(ax2,'Nährstoff n(t) (g/l)');
xlim(ax2,[-0.2 Tend+0.2]);
ylim(ax2,[-0.2 21]);         % feste Achse: n <= n_in <= 20

for i = 1:3
    hXc(i) = plot(ax1,NaN,NaN,styles{i},'Color',colG,'LineWidth',lw,'DisplayName',names{i}); %#ok<AGROW>
    hSc(i) = plot(ax2,NaN,NaN,styles{i},'Color',colG,'LineWidth',lw,'DisplayName',names{i}); %#ok<AGROW>
end
hX  = plot(ax1,NaN,NaN,'-','Color',colX,'LineWidth',lw+1);
hS  = plot(ax2,NaN,NaN,'-','Color',colS,'LineWidth',lw+1);
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hP2 = plot(ax2,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colX,'MarkerEdgeColor',colX,'HandleVisibility','off');
hM2 = plot(ax2,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colS,'MarkerEdgeColor',colS,'HandleVisibility','off');
lg1 = legend(ax1,hX); lg2 = legend(ax2,hS);
set([lg1 lg2],'Location','northeast','FontSize',fSize-6,'FontName',fName);

% --- Bifurkationsdiagramm: stationaere Zustaende b* ueber D
ax3 = mkAxes(al,[1 2]); ax3.Layout.Column = 2;
xlabel(ax3,'Verdünnungsrate D (1/h)');
ylabel(ax3,'stationärer Zustand b^* (g/l)');
xlim(ax3,[0 1.2]); ylim(ax3,[-0.3 12.5]);
hBs = plot(ax3,NaN,NaN,'-','Color',colB,'LineWidth',lw+1,'DisplayName','stabil');
hBu = plot(ax3,NaN,NaN,'--','Color',colB,'LineWidth',lw,'DisplayName','instabil');
hBd = plot(ax3,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hB3 = plot(ax3,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colX,'MarkerEdgeColor',colX, ...
    'DisplayName','Zustand b(t)');
lg3 = legend(ax3,[hBs hBu hB3]);
set(lg3,'Location','northeast','FontSize',fSize-6,'FontName',fName);
setVis3('off');

% --- Seitenleiste
pl = uigridlayout(gl,[19 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 100, 32, 6, 100, 32, 6, 100, 32, 6, 100, 32, 6, 100, 32, 6, 26, 26, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kK = uiknob(pl,'discrete','Items',names,'Value',S.kin, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kK.Layout.Row = 2;
kK.ValueChangedFcn = @(src,~) onPar('kin',src.Value);
mkLabel(pl,3,'Wachstumskinetik');

kD = uiknob(pl,'continuous','Limits',[0 1.2],'Value',S.D, ...
    'MajorTicks',0:0.2:1.2,'FontName',fName,'FontSize',16,'FontWeight','bold');
kD.Layout.Row = 5;
kD.ValueChangingFcn = @(~,evt) onPar('D',evt.Value);
kD.ValueChangedFcn  = @(src,~) onPar('D',src.Value);
mkLabel(pl,6,'Verdünnungsrate D (1/h)');

kS = uiknob(pl,'continuous','Limits',[1 20],'Value',S.Sin, ...
    'MajorTicks',[1 5:5:20],'FontName',fName,'FontSize',16,'FontWeight','bold');
kS.Layout.Row = 8;
kS.ValueChangingFcn = @(~,evt) onPar('Sin',evt.Value);
kS.ValueChangedFcn  = @(src,~) onPar('Sin',src.Value);
mkLabel(pl,9,'Zulaufkonzentration n_{in} (g/l)');

kT = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:5:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 14;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,15,'Zeit t (h)');

kX = uiknob(pl,'continuous','Limits',[-2 log10(2)],'Value',S.logX0, ...
    'MajorTicks',[-2 -1 0 log10(2)],'MajorTickLabels',{'0.01','0.1','1','2'}, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kX.Layout.Row = 11;
kX.ValueChangingFcn = @(~,evt) onPar('logX0',evt.Value);
kX.ValueChangedFcn  = @(src,~) onPar('logX0',src.Value);
mkLabel(pl,12,'Animpfmenge b_0 (g/l)');

cg = uigridlayout(pl,[1 3]);          % zentriert
cg.Layout.Row = 17;
cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0];
cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','alle Kinetiken vergleichen','Value',S.comp, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onPar('comp',src.Value);

cg2 = uigridlayout(pl,[1 3]);
cg2.Layout.Row = 18;
cg2.ColumnWidth = {'1x','fit','1x'};
cg2.Padding = [0 0 0 0];
cg2.BackgroundColor = [1 1 1];
cb2 = uicheckbox(cg2,'Text','Bifurkationsdiagramm','Value',S.bif, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb2.Layout.Column = 2;
cb2.ValueChangedFcn = @(src,~) onBif(src.Value);

update();

%% ---------------- Callbacks ----------------
    function onPar(name,v)
        S.(name) = v;
        requestUpdate();
    end

    function requestUpdate()
        % Drehereignisse zusammenfassen: laeuft gerade eine Rechnung, wird
        % nur vermerkt, dass danach einmal mit dem neuesten Wert gerechnet wird.
        if S.busy
            S.pending = true;
            return
        end
        S.busy = true;
        S.pending = true;
        while S.pending
            S.pending = false;
            update();
            drawnow;    % aufgestaute Drehereignisse jetzt abarbeiten (setzen ggf. pending)
        end
        S.busy = false;
    end

    function onTime(v)
        S.t = v;
        redraw();
    end

    function onBif(v)
        S.bif = v;
        if v
            al.ColumnWidth = {'1x','1x'}; setVis3('on');
        else
            al.ColumnWidth = {'1x', 0};   setVis3('off');
        end
    end

    function setVis3(st)
        ax3.Visible = st; hBs.Visible = st; hBu.Visible = st;
        hBd.Visible = st; hB3.Visible = st; lg3.Visible = st;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        isel = find(strcmp(names,S.kin));
        for i = 1:3
            if ~S.comp && i ~= isel, continue, end   % nur benoetigte Kinetiken rechnen
            q = [nus;amax;Ki;Kc;Km;S.D;S.Sin;i];
            [~,x] = ode15s(@model,S.tt,[10^S.logX0;S.Sin],options,q);   % n(0) = n_in
            S.X(:,i) = x(:,1); S.Sub(:,i) = x(:,2);
        end

        i = find(strcmp(names,S.kin));
        hX.DisplayName = ['Biomasse (' S.kin ')'];
        hS.DisplayName = ['Nährstoff (' S.kin ')'];
        if S.comp
            lg1 = legend(ax1,[hX hXc(setdiff(1:3,i))]);
            lg2 = legend(ax2,[hS hSc(setdiff(1:3,i))]);
        else
            lg1 = legend(ax1,hX); lg2 = legend(ax2,hS);
        end
        set([lg1 lg2],'Location','northeast','FontSize',fSize-6,'FontName',fName);
        bifurcation(i);
        redraw();
    end

    function redraw()
        i = find(strcmp(names,S.kin));
        idx = S.tt <= S.t + 1e-9;
        tt = S.tt(idx);
        set(hX,'XData',tt,'YData',S.X(idx,i));
        set(hS,'XData',tt,'YData',S.Sub(idx,i));
        for j = 1:3
            vis = S.comp && j ~= i;
            set(hXc(j),'XData',tt,'YData',S.X(idx,j),'Visible',vis);
            set(hSc(j),'XData',tt,'YData',S.Sub(idx,j),'Visible',vis);
        end
        Xt = interp1(S.tt,S.X(:,i),S.t);  St = interp1(S.tt,S.Sub(:,i),S.t);
        set(hM1,'XData',S.t,'YData',Xt);
        set(hM2,'XData',S.t,'YData',St);
        set(hP1,'XData',[S.t S.t],'YData',ax1.YLim);
        set(hP2,'XData',[S.t S.t],'YData',ax2.YLim);
        set(hB3,'XData',S.D,'YData',Xt);
        set(hBd,'XData',[S.D S.D],'YData',ax3.YLim);
        drawnow limitrate
    end

    function bifurcation(i)
        % stationaere Zustaende b* = (n_in - n*)/nu mit K(n*) = D, plus Auswaschen b* = 0
        n = numel(Dg);
        Xs = nan(n,1); Xu = nan(n,1);       % stabile / instabile Zweige (innen)
        W  = false(n,1);                    % Auswaschen stabil?
        for k = 1:n
            D = Dg(k);
            switch i
                case 1   % Monod
                    if D < amax
                        Sst = Km*D/(amax - D);
                        if Sst < S.Sin, Xs(k) = (S.Sin - Sst)/nus; end
                    end
                    W(k) = D > amax*S.Sin/(Km + S.Sin);
                case 2   % Haldane: (D/Ki) n^2 + (D - kmax) n + D k50 = 0
                    if D > 0
                        r = sort(roots([D/Ki, D - amax, D*Km]));
                        r = r(abs(imag(r)) < 1e-12 & real(r) > 0);
                        if numel(r) >= 1 && r(1) < S.Sin, Xs(k) = (S.Sin - r(1))/nus; end
                        if numel(r) == 2 && r(2) < S.Sin, Xu(k) = (S.Sin - r(2))/nus; end
                    end
                    W(k) = D > amax*S.Sin/(Km + S.Sin + S.Sin^2/Ki);
                case 3   % Contois: K(n_in, b = 0) = kmax
                    if D < amax
                        Sst = D*Kc/nus*S.Sin/(amax - D + D*Kc/nus);
                        Xs(k) = (S.Sin - Sst)/nus;
                    end
                    W(k) = D > amax;
            end
        end
        X0s = zeros(n,1); X0s(~W) = NaN;     % Auswaschen stabil
        X0u = zeros(n,1); X0u(W)  = NaN;     % Auswaschen instabil
        set(hBs,'XData',[Dg; NaN; Dg],'YData',[Xs; NaN; X0s]);
        set(hBu,'XData',[Dg; NaN; Dg],'YData',[Xu; NaN; X0u]);
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
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end

%% ---------------- Modell (x = [b; n], Parameter q wie oben) ----------------
function dx = model(~,x,q)
X = x(1);
S = max(x(2),0);

nus = q(1); amax = q(2); Ki = q(3); Kc = q(4); Km = q(5);
D = q(6); Sin = q(7); ind = q(8);

if ind == 1
    a = amax*S/(Km+S);
elseif ind == 2
    a = amax*S/(Km+S+S^2/Ki);
else
    a = amax*S/(Kc*X+S+eps);
end

dX = a*X - D*X;
dS = -nus*a*X - D*x(2) + D*Sin;

dx = [dX; dS];
end
