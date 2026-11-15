function hai_thunfisch_app
% HAI_THUNFISCH_APP  Raeuber-Beute-Modell "Shark-Tuna" (Garfinkel et al.,
%   Teaching Dynamics to Biology Undergraduates: the UCLA Experience,
%   Bull Math Biol, Fig. 3 und 5)
%
%   "Change equation":
%     S' = bS*S - dS*S + k*beta*S*T     (Haie: Geburt, Tod, fressen Thunfisch)
%     T' = bT*T - dT*T - beta*S*T       (Thunfisch: Geburt, Tod, gefressen)
%
%   Loesung entweder exakt (ode45) oder mit dem Euler-Verfahren
%     X_{n+1} = X_n + X'_n * dt
%   wie im Paper. Bei grosser Schrittweite dt laeuft die Euler-Loesung
%   spiralfoermig nach aussen, obwohl die exakten Bahnen geschlossen sind.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Startwert Thunfisch T0
%     - Knopf Startwert Haie S0
%     - Schalter Loesungsverfahren: exakt / Euler
%     - Knopf Schrittweite dt (nur Euler)
%     - Knopf Zeit (Jahre)
%     - Kontrollkaestchen: Richtungsfeld anzeigen
%
%   Fuer MATLAB R2025b.

%% Parameter (Zeit in Jahren)
bT = 0.6;  dT = 0.1;          % Thunfisch: Geburts-, Sterberate
bS = 0.1;  dS = 0.4;          % Haie: Geburts-, Sterberate
beta = 0.01;                  % Fressrate (Hai trifft Thunfisch)
k    = 0.2;                   % Umwandlung gefressener Thunfisch -> Haie
Teq = (dS - bS)/(k*beta);     % Gleichgewicht: 150 Thunfische
Seq = (bT - dT)/beta;         %                50 Haie

Tend = 50;
Tmax = 700; Smax = 180;       % Achsengrenzen
options = odeset('RelTol',1e-9,'AbsTol',1e-9);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colT  = [0.850 0.150 0.150];  % Thunfisch (rot, wie im Paper)
colS  = [0.000 0.447 0.741];  % Haie (blau)
colB  = [0.10 0.20 0.80];     % Bahn im Zustandsraum
colV  = [0.10 0.65 0.30];     % Richtungsfeld (gruen, wie im Paper)

%% Zustand
S.T0 = 100; S.S0 = 20;
S.euler = false; S.dt = 0.25;
S.t = Tend; S.field = true;
S.tt = []; S.X = [];

%% GUI
fig = uifigure('Name','Haie und Thunfische – Räuber-Beute-Modell', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {'1x','1x'};
al.BackgroundColor = [1 1 1];

% --- Zeitverlauf
ax1 = mkAxes(al,1);
xlabel(ax1,'Zeit t (Jahre)');
ylabel(ax1,'Anzahl');
xlim(ax1,[0 Tend]); ylim(ax1,[0 Tmax]);
hT  = plot(ax1,NaN,NaN,'-','Color',colT,'LineWidth',lw,'DisplayName','Thunfisch T');
hS  = plot(ax1,NaN,NaN,'-','Color',colS,'LineWidth',lw,'DisplayName','Haie S');
hP  = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hMT = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colT,'MarkerEdgeColor',colT,'HandleVisibility','off');
hMS = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colS,'MarkerEdgeColor',colS,'HandleVisibility','off');
lg1 = legend(ax1,[hT hS]);
set(lg1,'Location','northeast','FontSize',fSize-6,'FontName',fName);

% --- Zustandsraum mit Richtungsfeld
ax2 = mkAxes(al,2);
xlabel(ax2,'Thunfisch T');
ylabel(ax2,'Haie S');
xlim(ax2,[0 Tmax]); ylim(ax2,[0 Smax]);
[Tg,Sg] = meshgrid(linspace(25,Tmax-25,16), linspace(8,Smax-8,13));
U = (bT-dT)*Tg - beta*Sg.*Tg;              % T'
W = (bS-dS)*Sg + k*beta*Sg.*Tg;            % S'
% Pfeile gleicher Laenge (Richtung), in Achsenkoordinaten normiert
Un = U/Tmax; Wn = W/Smax; L = sqrt(Un.^2 + Wn.^2) + eps;
hQ = quiver(ax2,Tg,Sg,0.035*Tmax*Un./L,0.035*Smax*Wn./L,0, ...
    'Color',colV,'LineWidth',1.2,'MaxHeadSize',0.8);
hE  = plot(ax2,Teq,Seq,'+','Color',[0 0 0],'MarkerSize',14,'LineWidth',2);
hB  = plot(ax2,NaN,NaN,'-','Color',colB,'LineWidth',lw);
hB0 = plot(ax2,NaN,NaN,'o','MarkerSize',9,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
hM2 = plot(ax2,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colB,'MarkerEdgeColor',colB);

% --- Seitenleiste
pl = uigridlayout(gl,[18 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 115, 35, 10, 115, 35, 10, 55, 35, 10, 115, 35, 10, 115, 35, 10, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kT0 = uiknob(pl,'continuous','Limits',[50 300],'Value',S.T0, ...
    'MajorTicks',50:50:300,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT0.Layout.Row = 2;
kT0.ValueChangingFcn = @(~,evt) onPar('T0',evt.Value);
kT0.ValueChangedFcn  = @(src,~) onPar('T0',src.Value);
mkLabel(pl,3,'Startwert Thunfisch T_0');

kS0 = uiknob(pl,'continuous','Limits',[10 100],'Value',S.S0, ...
    'MajorTicks',10:15:100,'FontName',fName,'FontSize',16,'FontWeight','bold');
kS0.Layout.Row = 5;
kS0.ValueChangingFcn = @(~,evt) onPar('S0',evt.Value);
kS0.ValueChangedFcn  = @(src,~) onPar('S0',src.Value);
mkLabel(pl,6,'Startwert Haie S_0');

sw = uiswitch(pl,'slider','Items',{'exakt','Euler'},'ItemsData',{false,true}, ...
    'Value',S.euler,'FontName',fName,'FontSize',18,'FontWeight','bold');
sw.Layout.Row = 8;
sw.ValueChangedFcn = @(src,~) onEuler(src.Value);
mkLabel(pl,9,'Lösungsverfahren');

kDt = uiknob(pl,'continuous','Limits',[0.01 0.5],'Value',S.dt, ...
    'MajorTicks',[0.01 0.1:0.1:0.5],'FontName',fName,'FontSize',16,'FontWeight','bold');
kDt.Layout.Row = 11;
kDt.ValueChangingFcn = @(~,evt) onPar('dt',evt.Value);
kDt.ValueChangedFcn  = @(src,~) onPar('dt',src.Value);
kDt.Enable = 'off';
lDt = mkLabel(pl,12,'Schrittweite \Delta t (Jahre)');
lDt.Enable = 'off';

kTt = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:10:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kTt.Layout.Row = 14;
kTt.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kTt.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,15,'Zeit t (Jahre)');

cg = uigridlayout(pl,[1 3]);          % zentriert
cg.Layout.Row = 17;
cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0];
cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','Richtungsfeld anzeigen','Value',S.field, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onField(src.Value);

update();

%% ---------------- Callbacks ----------------
    function onPar(name,v)
        S.(name) = v;
        update();
    end

    function onEuler(v)
        S.euler = v;
        st = 'off'; if v, st = 'on'; end
        kDt.Enable = st; lDt.Enable = st;
        update();
    end

    function onTime(v)
        S.t = v;
        redraw();
    end

    function onField(v)
        S.field = v;
        hQ.Visible = v;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        x0 = [S.T0; S.S0];
        if S.euler
            % Euler-Verfahren: X_{n+1} = X_n + X'_n * dt
            n  = floor(Tend/S.dt);
            tt = (0:n)'*S.dt;
            X  = nan(n+1,2); X(1,:) = x0';
            for i = 1:n
                X(i+1,:) = X(i,:) + S.dt*rhs(X(i,:)')';
                if any(X(i+1,:) < 0) || any(X(i+1,:) > 1e4)   % Verfahren entgleist
                    X(i+1,:) = max(X(i+1,:),0);
                    break
                end
            end
        else
            tt = linspace(0,Tend,2001)';
            [~,X] = ode45(@(t,x) rhs(x),tt,x0,options);
        end
        S.tt = tt; S.X = X;

        if S.euler && S.dt >= 0.2
            mk = '.'; else, mk = 'none';
        end
        set([hT hS hB],'Marker',mk,'MarkerSize',12);
        set(hB0,'XData',S.T0,'YData',S.S0);
        redraw();
    end

    function dx = rhs(x)
        T = x(1); Sh = x(2);
        dT_ = bT*T - dT*T - beta*Sh*T;
        dS_ = bS*Sh - dS*Sh + k*beta*Sh*T;
        dx = [dT_; dS_];
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        set(hT,'XData',S.tt(idx),'YData',S.X(idx,1));
        set(hS,'XData',S.tt(idx),'YData',S.X(idx,2));
        set(hB,'XData',S.X(idx,1),'YData',S.X(idx,2));
        j = find(idx & ~isnan(S.X(:,1)),1,'last');
        set(hMT,'XData',S.tt(j),'YData',S.X(j,1));
        set(hMS,'XData',S.tt(j),'YData',S.X(j,2));
        set(hM2,'XData',S.X(j,1),'YData',S.X(j,2));
        set(hP,'XData',[S.t S.t],'YData',[0 Tmax]);
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
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end
