function genschalter_app
% GENSCHALTER_APP  Bistabiler Genschalter durch Selbstaktivierung
%   Smolen, Baxter & Byrne, Am J Physiol Cell Physiol 274:C531 (1998),
%   Gl. 1 und Abb. 2 (Modell ohne Repressor)
%
%   d[TF-A]/dt = k1f*A^2/(A^2 + K1d) - k1d*A + rbas
%
%   A = [TF-A]: Transkriptionsfaktor, der als Dimer sein eigenes Gen aktiviert.
%   Parameter (Abb. 2A): K1d = 10, k1d = 1 /min, rbas = 0.1 /min;
%   k1f = max. Syntheserate (haengt von der Phosphorylierung ab, also vom
%   aeusseren Signal). Zeit in min, Konzentration dimensionslos.
%
%   Fuer 6.1 < k1f < 25.1 /min gibt es zwei stabile Gleichgewichte (niedrig,
%   hoch) und ein instabiles dazwischen (Bistabilitaet). Kurze Signal-Pulse
%   (voruebergehende Aenderung von k1f) schalten zwischen den Zustaenden um.
%   Pulsprotokoll wie in Abb. 2A:
%     t = 30-31 min: k1f = 50;  t = 60-63: k1f = 1;  t = 90-91: k1f = 100;
%     t = 120-121: k1f = 50;    t = 150-153: k1f = 1.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Grundwert k1f (max. Syntheserate von TF-A)
%     - Knopf Zeit
%     - Kontrollkaestchen: Signal-Pulse, feste y-Achse, Kompartimentschema (zeigt nur
%       das Schema statt der Diagramme), Phasenlinie, Bifurkationsdiagramm
%       (feste y-Achse fuer [TF-A]: 0-80, sonst an die Loesung angepasst)
%
%   Fuer MATLAB R2025b.

%% Parameter
K1d = 10; k1d = 1; rbas = 0.1;
pulses = [30 31 50; 60 63 1; 90 91 100; 120 121 50; 150 153 1];   % [Start Ende k1f]
Tend = 200;
kLim = [0 30];
kGrid = (kLim(1):0.02:kLim(2))';
options = odeset('RelTol',1e-8,'AbsTol',1e-10);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colA  = [0.000 0.447 0.741];   % TF-A (blau)
colK  = [0.850 0.325 0.098];   % Signal k1f (orange)

%% Zustand
S.k = 4; S.t = 0;           % Start vor der Bifurkation (bistabil erst ab k1f = 6.1); Zeitknopf bei 0
S.puls = true; S.phase = false; S.bif = false; S.schema = false;
S.fix = false;                % feste y-Achse fuer [TF-A]?
yFix = [0 80];                % feste Skala: deckt alle Einstellungen ab (max. ca. 74)
S.tt = (0:0.05:Tend)'; S.A = zeros(size(S.tt)); S.kt = zeros(size(S.tt));
S.busy = false; S.pending = false;

%% GUI
fig = uifigure('Name','Genschalter – Bistabilität durch Selbstaktivierung', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[6 2]);      % 6 gleiche Zeilen: links 4+2, rechts flexibel 6, 3+3 oder 2+2+2
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = repmat({'1x'},1,6);
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- Zeitverlauf TF-A
ax1 = mkAxes(al,[1 4],1);
xlabel(ax1,'Zeit t (min)');
ylabel(ax1,'[TF-A]');
xlim(ax1,[0 Tend]);
hA  = plot(ax1,NaN,NaN,'-','Color',colA,'LineWidth',lw+1);
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colA,'MarkerEdgeColor',colA);

% --- Signal k1f(t)
ax0 = mkAxes(al,[5 6],1);
xlabel(ax0,'Zeit t (min)');
ylabel(ax0,'k_{1,f} (1/min)');
xlim(ax0,[0 Tend]); ylim(ax0,[0 105]);
hK  = plot(ax0,NaN,NaN,'-','Color',colK,'LineWidth',lw);
hP0 = plot(ax0,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);

% --- Phasenlinie dA/dt ueber A
ax2 = mkAxes(al,1,2);
xlabel(ax2,'[TF-A]');
ylabel(ax2,'d[TF-A]/dt');
hF  = plot(ax2,NaN,NaN,'-','Color',colA,'LineWidth',lw);
yline(ax2,0,'-','Color',[0 0 0],'LineWidth',1);
hEs = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName','stabil');
hEu = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'LineWidth',2,'DisplayName','instabil');
hM2 = plot(ax2,NaN,NaN,'o','MarkerSize',9,'MarkerFaceColor',colA,'MarkerEdgeColor',colA,'HandleVisibility','off');
lg2 = legend(ax2,[hEs hEu]);
set(lg2,'Location','northeast','FontSize',fSize-8,'FontName',fName);

% --- Bifurkationsdiagramm Gleichgewichte ueber k1f
ax3 = mkAxes(al,2,2);
xlabel(ax3,'max. Syntheserate k_{1,f} (1/min)');
ylabel(ax3,'Gleichgewicht [TF-A]^*');
xlim(ax3,kLim); ylim(ax3,[0 kLim(2)+2]);
hBs = plot(ax3,NaN,NaN,'-','Color',[0 0 0],'LineWidth',lw+1,'DisplayName','stabil');
hBu = plot(ax3,NaN,NaN,'--','Color',[0 0 0],'LineWidth',lw,'DisplayName','instabil');
hB3 = plot(ax3,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colA,'MarkerEdgeColor',colA,'HandleVisibility','off');
lg3 = legend(ax3,[hBs hBu]);
set(lg3,'Location','northwest','FontSize',fSize-8,'FontName',fName);
computeBif();

% --- Kompartimentschema: jeder Pfeil entspricht einem Term der Modellgleichung
axS = uiaxes(al);
axS.Layout.Row = [1 6]; axS.Layout.Column = 2;
axS.Color = [1 1 1];
drawSchema(axS);

% --- Seitenleiste
pl = uigridlayout(gl,[14 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Knopf | Titel | Abstand | Knopf | Titel | Abstand | 2 Kaestchen | Abstand | 2 Kaestchen
pl.RowHeight = {'1x', 130, 35, 10, 130, 35, 40, 28, 28, 40, 28, 28, 28, '1x'};   % '1x' oben/unten = vertikal mittig
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kKn = uiknob(pl,'continuous','Limits',kLim,'Value',S.k, ...
    'MajorTicks',kLim(1):5:kLim(2),'FontName',fName,'FontSize',16,'FontWeight','bold');
kKn.Layout.Row = 2;
kKn.ValueChangingFcn = @(~,evt) onPar('k',evt.Value);
kKn.ValueChangedFcn  = @(src,~) onPar('k',src.Value);
mkLabel(pl,3,'max. Syntheserate k_{1,f} (1/min)');

kT = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:50:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 5;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,6,'Zeit t (min)');

cb1 = mkCheck(8,'Signal-Pulse',S.puls);
cb1.ValueChangedFcn = @(src,~) onPar('puls',src.Value);
cb5 = mkCheck(11,'Kompartimentschema',S.schema);
cb5.ValueChangedFcn = @(src,~) onView('schema',src.Value);
cb2 = mkCheck(12,'Phasenlinie',S.phase);
cb2.ValueChangedFcn = @(src,~) onView('phase',src.Value);
cb3 = mkCheck(13,'Bifurkationsdiagramm',S.bif);
cb3.ValueChangedFcn = @(src,~) onView('bif',src.Value);
cb4 = mkCheck(9,'feste y-Achse für [TF-A]',S.fix);
cb4.ValueChangedFcn = @(src,~) onFix(src.Value);

layoutRight();
update();

%% ---------------- Callbacks ----------------
    function onPar(name,v)
        S.(name) = v;
        requestUpdate();
    end

    function requestUpdate()
        % Drehereignisse zusammenfassen (nur mit dem neuesten Wert rechnen)
        if S.busy, S.pending = true; return, end
        S.busy = true; S.pending = true;
        while S.pending
            S.pending = false;
            update();
            drawnow;
        end
        S.busy = false;
    end

    function onTime(v)
        S.t = v;
        redraw();
    end

    function onFix(v)
        S.fix = v;
        setYlim();
        redraw();
    end

    function setYlim()
        if S.fix
            ylim(ax1,yFix);
        else
            ylim(ax1,[0, max(1, 1.1*max(S.A))]);    % an aktuelle Loesung angepasst
        end
    end

    function onView(name,v)
        S.(name) = v;
        layoutRight();
    end

    function layoutRight()
        if S.schema
            % nur das Kompartimentschema zeigen (ueber die ganze Flaeche)
            al.ColumnWidth = {'1x','1x'};
            axS.Layout.Row = [1 6]; axS.Layout.Column = [1 2];
            setVis(findall(ax1)', false); setVis(findall(ax0)', false);
            setVis([ax2 hF hEs hEu hM2 lg2], false);
            setVis([ax3 hBs hBu hB3 lg3], false);
            setVis(findall(axS)', true);
            cb2.Enable = 'off'; cb3.Enable = 'off';
            return
        end
        setVis(findall(axS)', false);
        axS.Layout.Column = 2;            % ausgeblendet in die rechte Spalte
        setVis(findall(ax1)', true); setVis(findall(ax0)', true);
        cb2.Enable = 'on'; cb3.Enable = 'on';
        % rechte Spalte: Phasenlinie und/oder Bifurkationsdiagramm
        axs = {ax2, ax3};
        on  = [S.phase, S.bif];
        n = nnz(on);
        if n > 0
            al.ColumnWidth = {'1x','1x'};
        else
            al.ColumnWidth = {'1x', 0};
        end
        h = 6/max(n,1); r = 1;
        for j = find(on)
            axs{j}.Layout.Row = [r r+h-1];
            r = r + h;
        end
        setVis([ax2 hF hEs hEu hM2 lg2], S.phase);
        setVis([ax3 hBs hBu hB3 lg3], S.bif);
    end

    function setVis(h,v)
        st = 'off'; if v, st = 'on'; end
        set(h,'Visible',st);
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function k = kOf(t)
        % Signal k1f(t): Grundwert plus (optional) Pulse
        k = S.k;
        if S.puls
            i = find(t >= pulses(:,1) & t < pulses(:,2), 1);
            if ~isempty(i), k = pulses(i,3); end
        end
    end

    function [Ar,st] = steady(k)
        % Gleichgewichte: k1d A^3 - (k + rbas) A^2 + k1d K1d A - rbas K1d = 0
        r = roots([k1d, -(k + rbas), k1d*K1d, -rbas*K1d]);
        Ar = sort(real(r(abs(imag(r)) < 1e-9 & real(r) > 0)));
        fp = 2*k*Ar*K1d./(Ar.^2 + K1d).^2 - k1d;   % Ableitung f'(A)
        st = fp < 0;
    end

    function update()
        % stueckweise integrieren (Unstetigkeiten an den Pulsgrenzen)
        if S.puls
            br = unique([0; pulses(:,1); pulses(:,2); Tend]);
        else
            br = [0; Tend];
        end
        A = zeros(size(S.tt));
        Ar0 = steady(S.k); a = Ar0(1);      % Start im niedrigen Gleichgewicht
        A(1) = a;
        for j = 1:numel(br)-1
            kk = kOf(br(j));
            idx = find(S.tt >= br(j) & S.tt <= br(j+1));
            ts = S.tt(idx);
            if numel(ts) < 2, continue, end
            [~,y] = ode15s(@(t,y) kk*y^2/(y^2 + K1d) - k1d*y + rbas, ts, a, options);
            A(idx) = y; a = y(end);
        end
        S.A = A;
        S.kt = arrayfun(@kOf,S.tt);
        setYlim();

        % Phasenlinie fuer den Grundwert k
        [Ar,st] = steady(S.k);
        Amax = max(1.2*max(Ar), 2);
        Ag = linspace(0,Amax,500);
        set(hF,'XData',Ag,'YData',S.k*Ag.^2./(Ag.^2 + K1d) - k1d*Ag + rbas);
        xlim(ax2,[0 Amax]);
        set(hEs,'XData',Ar(st),'YData',zeros(1,nnz(st)));
        set(hEu,'XData',Ar(~st),'YData',zeros(1,nnz(~st)));
        redraw();
    end

    function computeBif()
        n = numel(kGrid);
        lo = nan(n,1); mid = nan(n,1); hi = nan(n,1);
        for j = 1:n
            Ar = steady(kGrid(j));
            if numel(Ar) == 3
                lo(j) = Ar(1); mid(j) = Ar(2); hi(j) = Ar(3);
            elseif numel(Ar) == 1
                if Ar < 1, lo(j) = Ar; else, hi(j) = Ar; end
            end
        end
        set(hBs,'XData',[kGrid; NaN; kGrid],'YData',[lo; NaN; hi]);
        set(hBu,'XData',kGrid,'YData',mid);
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        set(hA,'XData',S.tt(idx),'YData',S.A(idx));
        set(hK,'XData',S.tt(idx),'YData',S.kt(idx));
        At = interp1(S.tt,S.A,S.t);
        set(hM1,'XData',S.t,'YData',At);
        set(hP1,'XData',[S.t S.t],'YData',ax1.YLim);
        set(hP0,'XData',[S.t S.t],'YData',ax0.YLim);
        set(hM2,'XData',At,'YData',S.k*At^2/(At^2 + K1d) - k1d*At + rbas);
        set(hB3,'XData',kOf(S.t),'YData',At);
        drawnow limitrate
    end

    function drawSchema(ax)
        % Kompartimentschema: Selbstaktivierung von TF-A in einer eukaryotischen Zelle.
        % Jeder Pfeil entspricht einem Term von
        %   d[TF-A]/dt = k1f A^2/(A^2+K1d) - k1d A + rbas.
        % Dimerisierung und Bindung an TF-RE: schnelles Gleichgewicht (Doppelpfeile).
        G = [0.78 0.78 0.78]; L = 1.6;
        hold(ax,'on'); axis(ax,'off');
        ax.DataAspectRatio = [1 1 1];
        xlim(ax,[-24 100]); ylim(ax,[0 63]);
        disableDefaultInteractivity(ax); ax.Toolbar.Visible = 'off';
        fs = 14; fn = 'Times New Roman';
        y0 = 14; y1 = 18;
        % Zellkern mit doppelter Kernhuelle
        rectangle(ax,'Position',[1.5 5.5 64.5 26],'Curvature',[8/64.5 8/26], ...
            'FaceColor',[0.95 0.95 0.95],'EdgeColor','k','LineWidth',L);
        rectangle(ax,'Position',[2.4 6.4 62.7 24.2],'Curvature',[8/62.7 8/24.2], ...
            'FaceColor','none','EdgeColor','k','LineWidth',1.0);
        text(ax,2,4.8,'Zellkern','FontSize',fs-2,'FontAngle','italic','FontName',fn,'VerticalAlignment','top','FontWeight','bold');   % unter der Kernhuelle
        text(ax,97,61,'Cytoplasma','FontSize',fs-2,'FontAngle','italic','FontName',fn, ...
            'HorizontalAlignment','right','VerticalAlignment','top','FontWeight','bold');
        % DNA mit Bindungsstelle TF-RE und Gen tf-a
        plot(ax,[4 63.5],[y1 y1],'k','LineWidth',L); plot(ax,[4 63.5],[y0 y0],'k','LineWidth',L);
        rectangle(ax,'Position',[14 y0 9 4],'FaceColor',G,'EdgeColor','k','LineWidth',L);
        rectangle(ax,'Position',[36 y0 26 4],'FaceColor',G,'EdgeColor','k','LineWidth',L);
        text(ax,18.5,10,'TF-RE','HorizontalAlignment','center','FontSize',fs,'FontWeight','bold','FontName',fn);
        text(ax,30.5,10,'DNA','HorizontalAlignment','center','FontSize',fs,'FontWeight','bold','FontName',fn);
        text(ax,49,10,'tf-a','HorizontalAlignment','center','FontSize',fs+4,'FontAngle','italic','FontName','Times New Roman','FontWeight','bold');
        % gebundenes, phosphoryliertes TF-A-Dimer
        for dx = [-2.2 2.2]
            ell(18.5+dx,y1+3.2); phos(18.5+dx,y1+7.2);
        end
        text(ax,13.6,y1+3.0,{'TF-A-','Dimer'},'HorizontalAlignment','right','FontSize',fs-3,'FontWeight','bold','FontName',fn);
        % Signal (Kinase) phosphoryliert das gebundene Dimer -> bestimmt k1f
        text(ax,-15,27,{'Signal (Kinase):','Phosphorylierung','des gebundenen','Dimers bestimmt','k_{1,f} = max.','Syntheserate'}, ...
            'HorizontalAlignment','center','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        arrow([-1 26.4],[15 25.6],'-',1.2);
        % Aktivierung der Synthese (+)
        arrow([24 23.5],[44.2 26.5],'-',1.4);
        text(ax,33,27.3,'+','FontSize',fs+6,'FontWeight','bold','HorizontalAlignment','center','FontName',fn);
        text(ax,33,21.6,'aktiviert','FontSize',fs-3,'HorizontalAlignment','center','FontName',fn,'FontWeight','bold');
        % aktivierte Synthese (gestrichelt)
        plot(ax,[45 45 68.5 68.5],[y1+1 34 34 39.8],'k--','LineWidth',1.4); head(68.5,41.6,0,1);
        text(ax,33.5,35.2,{'Synthese k_{1,f} A^2/(A^2+K_{1,d})','(Transkription + Translation)'}, ...
            'FontSize',fs-3,'FontName',fn,'VerticalAlignment','bottom','FontWeight','bold');
        % Grundsynthese (gestrichelt, duenn)
        plot(ax,[60 60 71.5 71.5],[y1+1 28 28 39.8],'k--','LineWidth',1.0); head(71.5,41.6,0,1);
        text(ax,73,33.5,'Grundsynthese r_{bas}','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        % Monomer TF-A und Abbau
        ell(70,45);
        text(ax,70,50.6,'TF-A','HorizontalAlignment','center','FontSize',fs,'FontWeight','bold','FontName',fn);
        arrow([72.5 45],[86 45],'-',1.4);
        text(ax,89,45,char(8709),'HorizontalAlignment','center','FontSize',fs+6,'FontName',fn,'FontWeight','bold');
        text(ax,79,47.5,'Abbau k_{1,d}','HorizontalAlignment','center','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        % Dimerisierung (Doppelpfeil, schnelles Gleichgewicht)
        ell(38,51); ell(42.2,51);
        arrow([45 49.5],[67.5 46],'-',1.4,true);
        text(ax,56,53.8,{'Dimerisierung','(schnelles Gleichgew.)'},'HorizontalAlignment','center', ...
            'VerticalAlignment','bottom','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        % Kernimport + Bindung an TF-RE (Doppelpfeil, gebogen)
        tb = linspace(0,1,60)';
        P0 = [36 48.5]; P1 = [22 44]; P2 = [18.5 y1+9.6];
        B = (1-tb).^2*P0 + 2*(1-tb).*tb*P1 + tb.^2*P2;
        plot(ax,B(:,1),B(:,2),'k','LineWidth',1.4);
        dv = B(end,:) - B(end-3,:); dv = dv/norm(dv); head(P2(1),P2(2)-0.4,dv(1),dv(2));
        dv = B(1,:) - B(4,:);       dv = dv/norm(dv); head(P0(1)+0.4*dv(1),P0(2)+0.4*dv(2),dv(1),dv(2));
        text(ax,11,37,{'Kernimport +','Bindung an TF-RE','K_{1,d} (schnelles','Gleichgew.)'}, ...
            'HorizontalAlignment','center','FontSize',fs-3,'FontName',fn,'FontWeight','bold');

        function ell(cx,cy)
            rectangle(ax,'Position',[cx-2.1 cy-2.9 4.2 5.8],'Curvature',[1 1], ...
                'FaceColor',G,'EdgeColor','k','LineWidth',L);
        end
        function phos(cx,cy)
            rectangle(ax,'Position',[cx-1.1 cy-1.1 2.2 2.2],'Curvature',[1 1], ...
                'FaceColor',[1 1 1],'EdgeColor','k','LineWidth',1.2);
            text(ax,cx,cy,'P','HorizontalAlignment','center','FontSize',8,'FontWeight','bold','FontName',fn);
        end
        function arrow(p,q,ls,w,both)
            % gerader Pfeil von p nach q (optional mit Spitze an beiden Enden)
            if nargin < 5, both = false; end
            u = (q - p)/norm(q - p); l = 1.8;
            a0 = p; if both, a0 = p + l*u; end
            plot(ax,[a0(1) q(1)-l*u(1)],[a0(2) q(2)-l*u(2)],['k' ls],'LineWidth',w);
            head(q(1),q(2),u(1),u(2));
            if both, head(p(1),p(2),-u(1),-u(2)); end
        end
        function head(x,y,ux,uy)
            % gefuellte Pfeilspitze bei (x,y) in Richtung (ux,uy)
            l = 1.8; w = 0.8; nx = -uy; ny = ux;
            patch(ax,[x, x-l*ux+w*nx, x-l*ux-w*nx],[y, y-l*uy+w*ny, y-l*uy-w*ny],'k','EdgeColor','k');
        end
    end

    function ax = mkAxes(parent,row,col)
        ax = uiaxes(parent);
        ax.Layout.Row = row; ax.Layout.Column = col;
        ax.FontSize   = fSize;
        ax.FontWeight = 'bold';
        ax.FontName   = fName;
        ax.Color      = [1 1 1];
        ax.Box        = 'on';
        hold(ax,'on')
    end

    function mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',['\bf ' txt],'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end

    function cbx = mkCheck(row,txt,val)
        g = uigridlayout(pl,[1 3]);          % zentriert
        g.Layout.Row = row;
        g.ColumnWidth = {'1x','fit','1x'};
        g.Padding = [0 0 0 0];
        g.BackgroundColor = [1 1 1];
        cbx = uicheckbox(g,'Text',txt,'Value',val, ...
            'FontName',fName,'FontSize',16,'FontWeight','bold');
        cbx.Layout.Column = 2;
    end
end
