function circadian_app
% CIRCADIAN_APP  Innere Uhr und Jetlag – Kronauer-Modell
%   (Forger, Jewett & Kronauer, J Biol Rhythms 14:532, 1999)
%
%   Lichtverarbeitung (Prozess L):
%     alpha(I) = a0*(I/I0)^p
%     dn/dt    = 60*(alpha(I)*(1-n) - beta*n)
%     B        = G*alpha(I)*(1-n)*(1-0.4*x)*(1-0.4*xc)
%   Oszillator (Prozess P, Van-der-Pol-Typ):
%     dx/dt  = pi/12*( xc + mu*(x/3 + 4/3*x^3 - 256/105*x^7) + B )
%     dxc/dt = pi/12*( q*B*xc - x*((24/(0.99729*tau))^2 + k*B) )
%
%   Zeit t in Stunden. Wachzeit (Licht) 7-23 Uhr Ortszeit, sonst dunkel.
%   Am Ende von Tag 3 (t = 72 h) wird die Ortszeit um die eingestellte
%   Zeitverschiebung geaendert (+ = Flug nach Osten, - = nach Westen).
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Zeitverschiebung (h)
%     - Knopf Lichtstaerke tagsueber (lux, logarithmisch)
%     - Schalter Licht-Dunkel / Dauerdunkel
%     - Knopf Zeit (Tage)
%
%   Fuer MATLAB R2025b.

%% Parameter
P.mu = 0.13; P.q = 1/3; P.k = 0.55; P.tau = 24.2;
P.G = 19.875; P.a0 = 0.05; P.beta = 0.0075; P.p = 0.5; P.I0 = 9500;
P.wake = 7; P.sleep = 23;     % Licht an/aus (Ortszeit, h)

days   = 14;                  % dargestellte Tage
tShift = 72;                  % Zeitpunkt der Zeitverschiebung (h)
preDays = 30;                 % Einschwingen vor Beginn (Tage)
dt     = 0.05;                % Ausgabeschritt (h)
options = odeset('RelTol',1e-7,'AbsTol',1e-9,'MaxStep',0.1);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.000 0.447 0.741];  % innere Uhr (blau)
colR  = [0.850 0.150 0.150];  % Referenz (rot, gestrichelt)
colN  = [0.88 0.88 0.88];     % Nacht

%% Zustand
S.shift = 6;                  % h
S.logI  = log10(500);         % Raumlicht
S.dd    = false;              % Dauerdunkel?
S.t     = days;               % Zeitknopf (Tage)
S.tt = []; S.x = []; S.xr = [];

%% GUI
fig = uifigure('Name','Innere Uhr und Jetlag', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

ax = uiaxes(gl);
ax.Layout.Row = 1; ax.Layout.Column = 1;
ax.FontSize   = fSize;
ax.FontWeight = 'bold';
ax.FontName   = fName;
ax.Color      = [1 1 1];
ax.Box        = 'on';
ax.Layer      = 'top';
hold(ax,'on')
xlabel(ax,'Zeit (Tage)');
ylabel(ax,'Zustand der inneren Uhr x');
xlim(ax,[0 days]);
ylim(ax,[-1.6 1.6]);
ax.XTick = 0:days;

hN = gobjects(0);             % Nacht-Flaechen
hNleg = patch(ax,NaN,NaN,colN,'EdgeColor','none','DisplayName','Nacht (dunkel)');
hR = plot(ax,NaN,NaN,'--','Color',colR,'LineWidth',lw, ...
    'DisplayName','an Ortszeit angepasst');
hX = plot(ax,NaN,NaN,'-','Color',colX,'LineWidth',lw+1, ...
    'DisplayName','innere Uhr');
hP = plot(ax,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hM = plot(ax,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colX, ...
    'MarkerEdgeColor',colX,'HandleVisibility','off');
hF = xline(ax,tShift/24,'-','Flug','Color',[0 0 0],'LineWidth',1.5, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'LabelVerticalAlignment','bottom','HandleVisibility','off');

lg = legend(ax,[hX hR hNleg]);
set(lg,'Location','northeast','FontSize',fSize-4,'FontName',fName);

% --- Seitenleiste
pl = uigridlayout(gl,[13 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 125, 35, 10, 125, 35, 10, 55, 35, 10, 125, 35, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kS = uiknob(pl,'continuous','Limits',[-12 12],'Value',S.shift, ...
    'MajorTicks',-12:3:12,'FontName',fName,'FontSize',16,'FontWeight','bold');
kS.Layout.Row = 2;
kS.ValueChangedFcn = @(src,~) onPar('shift',round(src.Value));
mkLabel(pl,3,'Zeitverschiebung (h)  + = Ost');

kI = uiknob(pl,'continuous','Limits',[1 4],'Value',S.logI, ...
    'MajorTicks',1:4,'MajorTickLabels',{'10','100','1000','10000'}, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kI.Layout.Row = 5;
kI.ValueChangedFcn = @(src,~) onPar('logI',src.Value);
mkLabel(pl,6,'Lichtstärke tagsüber (lux)');

sw = uiswitch(pl,'slider','Items',{'Tag/Nacht','Dauerdunkel'}, ...
    'ItemsData',{false,true},'Value',S.dd, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold');
sw.Layout.Row = 8;
sw.ValueChangedFcn = @(src,~) onPar('dd',src.Value);
mkLabel(pl,9,'Licht');

kT = uiknob(pl,'continuous','Limits',[0 days],'Value',S.t, ...
    'MajorTicks',0:2:days,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 11;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,12,'Zeit (Tage)');

% Startlösung
update();

%% ---------------- Callbacks ----------------
    function onPar(name,v)
        S.(name) = v;
        if strcmp(name,'shift'), kS.Value = v; end   % auf ganze Stunden einrasten
        update();
    end

    function onTime(v)
        S.t = v;
        redraw();
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        fig.Pointer = 'watch'; drawnow
        I = 10^S.logI;

        % 1) Einschwingen im normalen Tag-Nacht-Rhythmus (Heimatzeit)
        L0 = @(t) lightLD(t,I,0,Inf,P);
        [~,y] = ode45(@(t,y) rhs(t,y,L0(t),P),[0 preDays*24],[-0.5;-0.5;0],options);
        y0 = y(end,:)';

        tt = (0:dt:days*24)';

        % 2) Referenz: synchronisierte Uhr ohne Reise (24-h-periodisch)
        [~,yr] = ode45(@(t,y) rhs(t,y,L0(t),P),(0:dt:(days+1)*24)',y0,options);
        tr = (0:dt:(days+1)*24)';
        xr = interp1(tr,yr(:,1),tt);
        if ~S.dd
            % nach dem Flug: um die Zeitverschiebung versetzter Rhythmus
            after = tt >= tShift;
            xr(after) = interp1(tr,yr(:,1),tt(after) + mod(S.shift,24));
        end

        % 3) Simulation mit Reise bzw. Dauerdunkel
        if S.dd
            L = @(t) 0;
        else
            L = @(t) lightLD(t,I,S.shift,tShift,P);
        end
        [~,ys] = ode45(@(t,y) rhs(t,y,L(t),P),tt,y0,options);

        S.tt = tt/24; S.x = ys(:,1); S.xr = xr;

        drawNights();
        hF.Visible = ~S.dd && S.shift ~= 0;
        hR.Visible = ~S.dd;
        redraw();
        fig.Pointer = 'arrow';
    end

    function drawNights()
        delete(hN); hN = gobjects(0);
        if S.dd
            hN = patch(ax,[0 days days 0],[-1.6 -1.6 1.6 1.6],colN, ...
                'EdgeColor','none','HandleVisibility','off');
        else
            % dunkle Intervalle in Heimatzeit bestimmen
            th = (0:0.01:days*24)';
            dark = arrayfun(@(t) lightLD(t,1,S.shift,tShift,P) == 0, th);
            d = diff([0; dark; 0]);
            s = find(d == 1); e = find(d == -1) - 1;
            for i = 1:numel(s)
                a = th(s(i))/24; b = th(e(i))/24;
                hN(end+1) = patch(ax,[a b b a],[-1.6 -1.6 1.6 1.6],colN, ...
                    'EdgeColor','none','HandleVisibility','off'); %#ok<AGROW>
            end
        end
        uistack(hN,'bottom');
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        set(hX,'XData',S.tt(idx),'YData',S.x(idx));
        set(hR,'XData',S.tt,'YData',S.xr);
        xt = interp1(S.tt,S.x,S.t);
        set(hM,'XData',S.t,'YData',xt);
        set(hP,'XData',[S.t S.t],'YData',[-1.6 1.6]);
        drawnow limitrate
    end

    function mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end

%% ---------------- Lichtprogramm ----------------
function I = lightLD(t,Iday,shift,tShift,P)
% Licht von P.wake bis P.sleep Uhr Ortszeit; ab tShift ist die Ortszeit
% gegenueber der Heimatzeit um 'shift' Stunden verschoben.
if t >= tShift
    h = mod(t + shift, 24);
else
    h = mod(t, 24);
end
if h >= P.wake && h < P.sleep
    I = Iday;
else
    I = 0;
end
end

%% ---------------- Modell (Forger, Jewett & Kronauer 1999) ----------------
function dy = rhs(~,y,I,P)
x = y(1); xc = y(2); n = y(3);

alpha = P.a0*(I/P.I0)^P.p;
B = P.G*alpha*(1-n)*(1-0.4*x)*(1-0.4*xc);

dx  = pi/12*( xc + P.mu*(x/3 + 4/3*x^3 - 256/105*x^7) + B );
dxc = pi/12*( P.q*B*xc - x*((24/(0.99729*P.tau))^2 + P.k*B) );
dn  = 60*( alpha*(1-n) - P.beta*n );

dy = [dx; dxc; dn];
end
