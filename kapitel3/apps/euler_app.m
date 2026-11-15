function euler_app
% EULER_APP  Euler-Verfahren mit einstellbarer Schrittweite h
%
%   dx/dt = f(t,x),  x(t0) = x0
%   Euler:  x_{n+1} = x_n + h*f(t_n,x_n),   t_n = t0 + n*h
%
%   Beispiele
%     Abkuehlung:        dT/dt = 0.03*(5 - T),          T(0) = 80
%     Logistisch (Hefe): dx/dt = 0.55*(1 - x/210)*x,    x(0) = 10
%     Michaelis-Menten:  dS/dt = -0.5*S/(S + 1),        S(0) = 2
%
%   Beobachtungen
%     - halbe Schrittweite: etwa halber Fehler (Verfahren erster Ordnung)
%     - Abkuehlung: fuer h > 1/k = 33.3 Schwingung, fuer h > 2/k = 66.7 Divergenz
%     - logistisch: h = 1 ergibt das diskrete Modell aus Kapitel I,
%       fuer r*h > 2 (h > 3.6) Zweierzyklen, fuer groessere h Chaos
%
%   Bedienelemente (Seitenleiste):
%     - Auswahl Beispiel
%     - Knopf Schrittweite h
%     - Knopf Anzahl der Euler-Schritte
%     - Kontrollkaestchen: Tangentenstuecke, exakte Loesung, Richtungsfeld
%
%   Fuer MATLAB R2025b.

%% Beispiele
B(1).name  = 'Abkühlung';
B(1).f     = @(t,x) 0.03*(5 - x);
B(1).x0    = 80;  B(1).Tend = 240;
B(1).hLim  = [1 80];  B(1).h = 10;
B(1).yLim  = [-60 140];
B(1).xlab  = 'Zeit t (min)';  B(1).ylab = 'Temperatur T (°C)';
B(1).formel = '\bf dT/dt = 0.03 (5 - T),   T(0) = 80';

B(2).name  = 'Logistisch';
B(2).f     = @(t,x) 0.55*(1 - x/210).*x;
B(2).x0    = 10;  B(2).Tend = 30;
B(2).hLim  = [0.1 5];  B(2).h = 1;
B(2).yLim  = [0 320];
B(2).xlab  = 'Zeit t (h)';  B(2).ylab = 'Hefe x';
B(2).formel = '\bf dx/dt = 0.55 (1 - x/210) x,   x(0) = 10';

B(3).name  = 'Michaelis-Menten';
B(3).f     = @(t,x) -0.5*x./(x + 1);
B(3).x0    = 2;   B(3).Tend = 10;
B(3).hLim  = [0.1 5];  B(3).h = 1;
B(3).yLim  = [-0.5 2.5];
B(3).xlab  = 'Zeit t';  B(3).ylab = 'Substrat S';
B(3).formel = '\bf dS/dt = -0.5 S/(S + 1),   S(0) = 2';

% Stil wie in fischerei_app.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.640 0.080 0.180];   % exakte Loesung (dunkelrot)
colE  = [0.900 0.350 0.400];   % Euler (hellrot)
colT  = [0.20 0.60 0.25];      % Tangenten (gruen, Farbregel 03.11.2026)
colR  = [0.60 0.82 0.62];      % Richtungsfeld (hellgruen)
options = odeset('RelTol',1e-9,'AbsTol',1e-10);

%% Zustand
S.k     = 1;                   % Beispiel
S.h     = B(1).h;
S.n     = 100;                 % Anzahl gezeigter Schritte (wird begrenzt)
S.tang  = true;
S.exakt = true;
S.feld  = false;

%% GUI
fig = uifigure('Name','Euler-Verfahren – Schrittweite und Genauigkeit', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

ax = uiaxes(gl);
ax.Layout.Row = 1; ax.Layout.Column = 1;
ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
ax.Color = [1 1 1]; ax.Box = 'on';
hold(ax,'on')

hR = plot(ax,NaN,NaN,'-','Color',colR,'LineWidth',1.5,'HandleVisibility','off');
hX = plot(ax,NaN,NaN,'-','Color',colX,'LineWidth',lw+1,'DisplayName','exakte Lösung');
hT = plot(ax,NaN,NaN,'-','Color',colT,'LineWidth',lw,'DisplayName','Tangentenstücke');
hE = plot(ax,NaN,NaN,'o','MarkerSize',9,'MarkerFaceColor',colE, ...
    'MarkerEdgeColor',colE,'DisplayName','Euler x_n^h');
hL = plot(ax,NaN,NaN,':','Color',colE,'LineWidth',1.5,'HandleVisibility','off');
lg = legend(ax,[hX hT hE]);
set(lg,'Location','northeast','FontSize',fSize-6,'FontName',fName);

% --- Seitenleiste
pl = uigridlayout(gl,[16 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
pl.RowHeight = {'1x', 35, 30, 10, 115, 35, 10, 115, 35, 10, 28, 28, 28, 10, 90, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

dd = uidropdown(pl,'Items',{B.name},'ItemsData',1:numel(B),'Value',S.k, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold');
dd.Layout.Row = 2;
dd.ValueChangedFcn = @(src,~) onBeispiel(src.Value);
mkLabel(pl,3,'Beispiel');

kh = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
kh.Layout.Row = 5;
kh.ValueChangingFcn = @(~,evt) onH(evt.Value);
kh.ValueChangedFcn  = @(src,~) onH(src.Value);
lh = mkLabel(pl,6,'');

kn = uiknob(pl,'discrete','FontName',fName,'FontSize',16,'FontWeight','bold');
kn.Layout.Row = 8;
kn.ValueChangedFcn = @(src,~) onN(src.Value);
mkLabel(pl,9,'Anzahl Schritte');

mkCheck(pl,11,'Tangentenstücke',S.tang,@(v) onCheck('tang',v));
mkCheck(pl,12,'exakte Lösung',S.exakt,@(v) onCheck('exakt',v));
mkCheck(pl,13,'Richtungsfeld',S.feld,@(v) onCheck('feld',v));

lInfo = uilabel(pl,'Text','','FontName',fName,'FontSize',18, ...
    'FontWeight','bold','HorizontalAlignment','center','WordWrap','on');
lInfo.Layout.Row = 15;

setBeispiel();

%% ---------------- Callbacks ----------------
    function onBeispiel(v)
        S.k = v;
        setBeispiel();
    end

    function onH(v)
        S.h = v;
        lh.Text = sprintf('Schrittweite h = %.2f',S.h);
        setNKnob();
        redraw();
    end

    function onN(v)
        S.n = v;
        redraw();
    end

    function onCheck(name,v)
        S.(name) = v;
        redraw();
    end

    function setBeispiel()
        b = B(S.k);
        S.h = b.h;
        kh.Limits = b.hLim; kh.Value = S.h;
        kh.MajorTicks = linspace(b.hLim(1),b.hLim(2),5);
        lh.Text = sprintf('Schrittweite h = %.2f',S.h);
        xlim(ax,[0 b.Tend]); ylim(ax,b.yLim);
        xlabel(ax,b.xlab); ylabel(ax,b.ylab);
        title(ax,b.formel,'Interpreter','tex','FontSize',fSize);
        % exakte Loesung (sehr genau numerisch)
        tt = linspace(0,b.Tend,1500)';
        [~,y] = ode45(b.f,tt,b.x0,options);
        S.tx = tt; S.xx = y(:,1);
        set(hX,'XData',S.tx,'YData',S.xx);
        % Richtungsfeld
        [Tg,Xg] = meshgrid(linspace(0,b.Tend,25),linspace(b.yLim(1),b.yLim(2),17));
        F  = b.f(Tg,Xg);
        sx = b.Tend/25*0.35; sy = diff(b.yLim)/17*0.35;     % Laenge im Bild
        d  = sqrt(1 + (F*sx/sy).^2);
        dt = sx./d; dx = F.*dt;
        XD = [Tg(:)-dt(:), Tg(:)+dt(:), NaN(numel(Tg),1)]';
        YD = [Xg(:)-dx(:), Xg(:)+dx(:), NaN(numel(Tg),1)]';
        set(hR,'XData',XD(:),'YData',YD(:));
        S.n = 1e6;               % alle Schritte zeigen
        setNKnob();
        redraw();
    end

    function setNKnob()
        N = floor(B(S.k).Tend/S.h + 1e-9);
        N = max(N,1);
        items = unique(round(linspace(0,N,min(N,10)+1)));
        kn.Items = arrayfun(@num2str,items,'UniformOutput',false);
        kn.ItemsData = items;
        [~,i] = min(abs(items - min(S.n,N)));
        S.n = items(i);
        kn.Value = S.n;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function redraw()
        b = B(S.k);
        n = S.n;
        t = (0:n)'*S.h;
        x = zeros(n+1,1); x(1) = b.x0;
        for j = 1:n
            x(j+1) = x(j) + S.h*b.f(t(j),x(j));
            if ~isfinite(x(j+1)), x(j+1:end) = NaN; break; end
        end
        set(hE,'XData',t,'YData',x);
        set(hL,'XData',t,'YData',x);
        % Tangentenstuecke
        if S.tang && n > 0
            XT = [t(1:end-1), t(2:end), NaN(n,1)]';
            YT = [x(1:end-1), x(2:end), NaN(n,1)]';
            set(hT,'XData',XT(:),'YData',YT(:),'Visible','on');
            hL.Visible = 'off';
        else
            hT.Visible = 'off';
            hL.Visible = 'on';
        end
        hX.Visible = onoff(S.exakt);
        hR.Visible = onoff(S.feld);
        % Fehler im letzten Schritt
        if n > 0
            xe = interp1(S.tx,S.xx,t(end));
            lInfo.Text = sprintf('bei t = %.4g:\nEuler %.4g\nexakt %.4g\nFehler %.3g', ...
                t(end),x(end),xe,x(end)-xe);
        else
            lInfo.Text = 'Startwert';
        end
        drawnow limitrate
    end

    function s = onoff(v)
        if v, s = 'on'; else, s = 'off'; end
    end

    function h = mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end

    function mkCheck(parent,row,txt,val,fcn)
        g = uigridlayout(parent,[1 3]);
        g.Layout.Row = row;
        g.ColumnWidth = {'1x','fit','1x'};
        g.Padding = [0 0 0 0];
        g.BackgroundColor = [1 1 1];
        c = uicheckbox(g,'Text',txt,'Value',val, ...
            'FontName',fName,'FontSize',16,'FontWeight','bold');
        c.Layout.Column = 2;
        c.ValueChangedFcn = @(src,~) fcn(src.Value);
    end
end
