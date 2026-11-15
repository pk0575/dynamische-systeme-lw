function richtungsfeld_app
% RICHTUNGSFELD_APP  Richtungsfeld und Loesungen von Anfangswertproblemen
%
%   dx/dt = f(t,x),  x(t0) = x0
%
%   Klick in das Bild setzt einen Anfangswert (t0,x0); die zugehoerige
%   Loesung wird vorwaerts und rueckwaerts in der Zeit gezeichnet.
%   So entsteht die Loesungsschar: durch jeden Punkt geht genau eine
%   Loesung, Loesungskurven schneiden sich nicht (Existenz/Eindeutigkeit).
%
%   Beispiele
%     Exponentiell:  dx/dt = 0.5 x
%     Abkuehlung:    dx/dt = 0.5 (1 - x)
%     Logistisch:    dx/dt = (1 - x/2) x
%     Explosion:     dx/dt = x^2            (Loesung existiert nur endlich lange)
%     Wurzel:        dx/dt = 2 sqrt(|x|)    (Startwert 0: nicht eindeutig)
%     Nicht autonom: dx/dt = sin(x) + t - 3
%
%   Bedienelemente (Seitenleiste):
%     - Auswahl Differentialgleichung
%     - Taste: Loesungen loeschen
%     - Kontrollkaestchen: stationaere Loesungen anzeigen
%
%   Fuer MATLAB R2025b.

%% Beispiele
B(1).name = 'Exponentiell';   B(1).f = @(t,x) 0.5*x;
B(1).tl = [0 6];  B(1).xl = [-4 4];  B(1).ss = 0;
B(1).formel = '\bf dx/dt = 0.5 x';
B(2).name = 'Abkühlung';      B(2).f = @(t,x) 0.5*(1 - x);
B(2).tl = [0 6];  B(2).xl = [-2 4];  B(2).ss = 1;
B(2).formel = '\bf dx/dt = 0.5 (1 - x)';
B(3).name = 'Logistisch';     B(3).f = @(t,x) (1 - x/2).*x;
B(3).tl = [0 6];  B(3).xl = [-1 4];  B(3).ss = [0 2];
B(3).formel = '\bf dx/dt = (1 - x/2) x';
B(4).name = 'Explosion';      B(4).f = @(t,x) x.^2;
B(4).tl = [0 4];  B(4).xl = [-3 3];  B(4).ss = 0;
B(4).formel = '\bf dx/dt = x^2';
B(5).name = 'Wurzel';         B(5).f = @(t,x) 2*sqrt(abs(x));
B(5).tl = [0 4];  B(5).xl = [-1 4];  B(5).ss = 0;
B(5).formel = '\bf dx/dt = 2 (|x|)^{1/2}';
B(6).name = 'Nicht autonom';  B(6).f = @(t,x) sin(x) + t - 3;
B(6).tl = [0 6];  B(6).xl = [-4 6];  B(6).ss = [];
B(6).formel = '\bf dx/dt = sin(x) + t - 3';

fName = 'Times New Roman';
fSize = 24;
lw    = 2.5;
colR  = [0.20 0.60 0.25];      % Richtungsfeld (gruen, Farbregel 03.11.2026)
colS  = [0.000 0.392 0.000];   % stationaere Loesungen (dunkelgruen)
ROT   = [0.640 0.080 0.180; 0.850 0.150 0.150; 0.900 0.400 0.300; ...
         0.700 0.250 0.350; 0.950 0.550 0.450];

S.k = 1;  S.ss = true;  S.anz = 0;

%% GUI
fig = uifigure('Name','Richtungsfeld und Anfangswertprobleme', ...
    'Color',[1 1 1],'WindowState','maximized');
gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

ax = uiaxes(gl);
ax.Layout.Row = 1; ax.Layout.Column = 1;
ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
ax.Color = [1 1 1]; ax.Box = 'on';
hold(ax,'on')
xlabel(ax,'Zeit t'); ylabel(ax,'x');
ax.ButtonDownFcn = @(~,~) onKlick();
hF  = plot(ax,NaN,NaN,'-','Color',colR,'LineWidth',1.5,'HitTest','off');
hSS = plot(ax,NaN,NaN,'--','Color',colS,'LineWidth',2,'HitTest','off');
hL  = gobjects(0);

pl = uigridlayout(gl,[9 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
pl.RowHeight = {'1x', 35, 30, 20, 45, 20, 28, 120, '1x'};
pl.BackgroundColor = [1 1 1];

dd = uidropdown(pl,'Items',{B.name},'ItemsData',1:numel(B),'Value',S.k, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold');
dd.Layout.Row = 2;
dd.ValueChangedFcn = @(src,~) onBeispiel(src.Value);
mkLabel(3,'Differentialgleichung');

bt = uibutton(pl,'Text','Lösungen löschen','FontName',fName, ...
    'FontSize',18,'FontWeight','bold');
bt.Layout.Row = 5;
bt.ButtonPushedFcn = @(~,~) loeschen();

g = uigridlayout(pl,[1 3]);
g.Layout.Row = 7; g.ColumnWidth = {'1x','fit','1x'};
g.Padding = [0 0 0 0]; g.BackgroundColor = [1 1 1];
cb = uicheckbox(g,'Text','stationäre Lösungen','Value',S.ss, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onSS(src.Value);

lInfo = uilabel(pl,'Text','Klick ins Bild: Anfangswert setzen', ...
    'FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'HorizontalAlignment','center','WordWrap','on');
lInfo.Layout.Row = 8;

setBeispiel();

%% ---------------- Callbacks ----------------
    function onBeispiel(v)
        S.k = v;
        setBeispiel();
    end

    function onSS(v)
        S.ss = v;
        if v, hSS.Visible = 'on'; else, hSS.Visible = 'off'; end
    end

    function loeschen()
        delete(hL); hL = gobjects(0); S.anz = 0;
        lInfo.Text = 'Klick ins Bild: Anfangswert setzen';
    end

    function setBeispiel()
        loeschen();
        b = B(S.k);
        xlim(ax,b.tl); ylim(ax,b.xl);
        title(ax,b.formel,'Interpreter','tex','FontSize',fSize);
        % Richtungsfeld: Strecken gleicher Laenge im Bild
        nt = 25; nx = 19;
        [Tg,Xg] = meshgrid(linspace(b.tl(1),b.tl(2),nt),linspace(b.xl(1),b.xl(2),nx));
        F  = b.f(Tg,Xg);
        sx = diff(b.tl)/nt*0.35; sy = diff(b.xl)/nx*0.35;
        d  = sqrt(1 + (F*sx/sy).^2);
        dt = sx./d; dx = F.*dt;
        XD = [Tg(:)-dt(:), Tg(:)+dt(:), NaN(numel(Tg),1)]';
        YD = [Xg(:)-dx(:), Xg(:)+dx(:), NaN(numel(Tg),1)]';
        set(hF,'XData',XD(:),'YData',YD(:));
        % stationaere Loesungen
        if isempty(b.ss)
            set(hSS,'XData',NaN,'YData',NaN);
        else
            XS = repmat([b.tl NaN],1,numel(b.ss));
            YS = reshape([b.ss; b.ss; NaN(1,numel(b.ss))],1,[]);
            set(hSS,'XData',XS,'YData',YS);
        end
        onSS(S.ss);
    end

    function onKlick()
        b = B(S.k);
        p = ax.CurrentPoint;
        t0 = p(1,1); x0 = p(1,2);
        S.anz = S.anz + 1;
        c = ROT(mod(S.anz-1,size(ROT,1))+1,:);
        gr = 10*max(abs(b.xl));
        opt = odeset('RelTol',1e-8,'AbsTol',1e-10,'MaxStep',diff(b.tl)/200, ...
            'Events',@(t,x) deal(abs(x) - gr, 1, 0));
        tv = []; xv = [];
        if t0 < b.tl(2)
            [tv,xv] = ode45(b.f,[t0 b.tl(2)],x0,opt);
        end
        tr = []; xr = [];
        if t0 > b.tl(1)
            [tr,xr] = ode45(b.f,[t0 b.tl(1)],x0,opt);
        end
        tt = [flipud(tr); tv]; xx = [flipud(xr); xv];
        hL(end+1) = plot(ax,tt,xx,'-','Color',c,'LineWidth',lw,'HitTest','off');
        hL(end+1) = plot(ax,t0,x0,'o','MarkerSize',10,'MarkerFaceColor',c, ...
            'MarkerEdgeColor',c,'HitTest','off');
        lInfo.Text = sprintf('Anfangswert\nt0 = %.2f,  x0 = %.2f',t0,x0);
        if ~isempty(tv) && tv(end) < b.tl(2) - 1e-6
            lInfo.Text = sprintf('%s\nLösung verlässt das Bild bei t = %.2f', ...
                lInfo.Text,tv(end));
        end
    end

    function mkLabel(row,txt)
        h = uilabel(pl,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end
