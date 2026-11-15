function lineare_dgl_app
% LINEARE_DGL_APP  Folgen und lineare Differenzengleichungen 1. Ordnung
%   (Kapitel I: arithmetische Folge, geometrische Folge, Newtonsches
%   Gesetz der Abkuehlung, allgemeiner Fall)
%
%   x_{n+1} = a x_n + b,  n >= 0
%
%   Beispiele (Auswahl in der Seitenleiste):
%     - arithmetische Folge   x_{n+1} = x_n + b      (Knopf b, x_0 = 20)
%     - geometrische Folge    x_{n+1} = a x_n        (Knopf a, x_0 = 1)
%     - Abkuehlung            T_{n+1} = T_n + alpha (T^u - T_n)
%                             (Knopf alpha, T_0 = 35, T^u = 23),
%                             d.h. a = 1 - alpha, b = alpha T^u
%     - allgemein             x_{n+1} = a x_n + b    (Knoepfe a und b, x_0 = 1)
%   Stationaerer Zustand (a ~= 1): x* = b/(1 - a).
%
%   Bedienelemente (Seitenleiste):
%     - Auswahl Beispiel
%     - Knopf Parameter (b, a bzw. alpha), im allgemeinen Fall zweiter Knopf b
%     - Knopf Startwert x_0 bzw. T_0
%     - Knopf Schritt n (Folge wird bis n gezeichnet, Start n = 0)
%     - Kontrollkaestchen: stationaerer Zustand, Treppendiagramm (Graph von
%       f(x) = a x + b, Identitaet, Iteration), Kompartimentschema
%
%   Ersetzt die App-Designer-Apps app_arithmetric, app_geometric und
%   app_newton_cooling sowie den linearen Teil von app_updatefunction
%   (Stil wie alcohol_app, genschalter_app, chemostat_hopf_app).
%
%   Fuer MATLAB R2025b.

%% Beispiele: Name, Startwert, Schritte, y-Achse, Knopf 1 (Name, Grenzen, Start)
E(1) = struct('name','arithmetische Folge','x0',20,'N',10,'yl',[5 45], ...
    'p1','b','l1',[-2 4],'v1',1,'lab1','b','eq','\bf {\itx}_{n+1} = {\itx}_n + {\itb}','var','x_n','varn','x_{n+1}','l0',[0 40],'lab0','Startwert x_0');
E(2) = struct('name','geometrische Folge','x0',1,'N',30,'yl',[-0.2 4.2], ...
    'p1','a','l1',[0 2],'v1',1.05,'lab1','a','eq','\bf {\itx}_{n+1} = {\ita} {\itx}_n','var','x_n','varn','x_{n+1}','l0',[0 4],'lab0','Startwert x_0');
E(3) = struct('name','Abkühlung','x0',35,'N',20,'yl',[8 38], ...
    'p1','alpha','l1',[0 2.5],'v1',0.5,'lab1','\alpha','eq','\bf {\itT}_{n+1} = {\itT}_n + \alpha ({\itT}^u - {\itT}_n)','var','T_n','varn','T_{n+1}','l0',[10 38],'lab0','Anfangstemperatur T_0');
E(4) = struct('name','allgemein','x0',1,'N',20,'yl',[-10 10], ...
    'p1','a','l1',[-1.5 1.5],'v1',0.5,'lab1','a','eq','\bf {\itx}_{n+1} = {\ita} {\itx}_n + {\itb}','var','x_n','varn','x_{n+1}','l0',[-10 10],'lab0','Startwert x_0');
Tu  = 23;                      % Umgebungstemperatur (Abkuehlung)
bLim = [-5 5];                 % zweiter Knopf (b) im allgemeinen Fall

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie bisherige Kapitel-I-Apps)
colF  = [0.000 0.447 0.741];   % Aktualisierungsfunktion (blau)

%% Zustand
S.e = 1; S.p = E(1).v1; S.b = 1; S.n = 0;
S.x0 = [E.x0];                 % Startwert je Beispiel
S.stat = false; S.cob = false; S.schema = false;
S.x = [];
S.busy = false; S.pending = false;

%% GUI
fig = uifigure('Name','Folgen und lineare Differenzengleichungen 1. Ordnung', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- Folge x_n ueber n
ax1 = mkAxes(al,1,1);
xlabel(ax1,'n');
hX  = plot(ax1,NaN,NaN,'.','MarkerSize',38,'LineWidth',lw,'LineStyle','--','Color',colX);
hS  = plot(ax1,NaN,NaN,'--','Color',[0 0 0],'LineWidth',lw);       % stationaerer Zustand
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',16,'MarkerEdgeColor',colX,'LineWidth',2);

% --- Treppendiagramm: Graph von f(x) = a x + b, Identitaet und Iteration
ax2 = mkAxes(al,1,2);
ax2.DataAspectRatio = [1 1 1];
hI  = plot(ax2,NaN,NaN,'-','Color',[0 0 0],'LineWidth',1.5);       % Identitaet
hF  = plot(ax2,NaN,NaN,'-','Color',colF,'LineWidth',lw+1);
hC  = plot(ax2,NaN,NaN,'-','Color',colX,'LineWidth',1.5);
hEs = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName','stabil');
hEu = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'LineWidth',2,'DisplayName','instabil');
lg2 = legend(ax2,[hEs hEu]);
set(lg2,'Location','northwest','FontSize',fSize-8,'FontName',fName);

% --- Kompartimentschema (gleiche Zelle, zunaechst verborgen)
gS = uigridlayout(gl,[1 1]); gS.Layout.Row = 1; gS.Layout.Column = 1;
gS.BackgroundColor = [1 1 1];
axS = uiaxes(gS); axS.Color = [1 1 1];
hold(axS,'on'); axis(axS,'off'); axS.DataAspectRatio = [1 1 1];
disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';
gS.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[20 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Beispiel (Titel, Auswahl, Gleichung) | 4 x (Knopf, Titel, Abstand) | 3 Kaestchen
% ('1x' oben/unten = vertikal mittig; Zeilen des Knopfs b nur im allgemeinen Fall)
rowH = {'1x', 28, 34, 44, 105, 32, 6, 105, 32, 6, 105, 32, 6, 105, 32, 14, 26, 26, 26, '1x'};
pl.RowHeight = rowH;
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

mkLabel(pl,2,'Beispiel');
dd = uidropdown(pl,'Items',{E.name},'ItemsData',1:numel(E),'Value',S.e, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold');
dd.Layout.Row = 3;
dd.ValueChangedFcn = @(src,~) onExample(src.Value);
hEq = uilabel(pl,'Text',E(1).eq,'Interpreter','tex','FontName',fName,'FontSize',24, ...
    'HorizontalAlignment','center');
hEq.Layout.Row = 4;

k1 = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
k1.Layout.Row = 5;
k1.ValueChangingFcn = @(~,evt) onPar('p',evt.Value);
k1.ValueChangedFcn  = @(src,~) onPar('p',src.Value);
hL1 = mkLabel(pl,6,'');

k2 = uiknob(pl,'continuous','Limits',bLim,'Value',S.b,'MajorTicks',bLim(1):2.5:bLim(2), ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
k2.Layout.Row = 8;
k2.ValueChangingFcn = @(~,evt) onPar('b',evt.Value);
k2.ValueChangedFcn  = @(src,~) onPar('b',src.Value);
hL2 = mkLabel(pl,9,'b');

k0 = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
k0.Layout.Row = 11;
k0.ValueChangingFcn = @(~,evt) onX0(evt.Value);
k0.ValueChangedFcn  = @(src,~) onX0(src.Value);
hL0 = mkLabel(pl,12,'');

kN = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
kN.Layout.Row = 14;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);       % Rastung: einrasten beim Loslassen
mkLabel(pl,15,'Schritt n');

cbS = mkCheck(17,'stationärer Zustand',S.stat);
cbS.ValueChangedFcn = @(src,~) onStat(src.Value);
cbT = mkCheck(18,'Treppendiagramm',S.cob);
cbT.ValueChangedFcn = @(src,~) onCob(src.Value);
cbM = mkCheck(19,'Kompartimentschema',S.schema);
cbM.ValueChangedFcn = @(src,~) onSchema(src.Value);

onExample(S.e);
onCob(S.cob);

%% ---------------- Callbacks ----------------
    function onExample(e)
        % Beispiel wechseln: Knoepfe, Achsen und Schema anpassen
        S.e = e; Ex = E(e);
        S.p = Ex.v1; S.n = 0;
        % Grenzen so umstellen, dass der Wert nie ausserhalb liegt
        k1.Limits = [min(k1.Limits(1),Ex.l1(1)) max(k1.Limits(2),Ex.l1(2))];
        k1.Value = Ex.v1; k1.Limits = Ex.l1;
        k1.MajorTicks = linspace(Ex.l1(1),Ex.l1(2),5);
        hL1.Text = ['\bf ' Ex.lab1];
        k0.Limits = [min(k0.Limits(1),Ex.l0(1)) max(k0.Limits(2),Ex.l0(2))];
        k0.Value = S.x0(e); k0.Limits = Ex.l0;
        k0.MajorTicks = linspace(Ex.l0(1),Ex.l0(2),5);
        hL0.Text = ['\bf ' Ex.lab0];
        % Knopf b nur im allgemeinen Fall (Zeilen sonst auf Hoehe 0)
        on2 = (e == 4);
        k2.Visible = on2; hL2.Visible = on2;
        rh = rowH;
        if ~on2, rh{8} = 0; rh{9} = 0; rh{10} = 0; end
        pl.RowHeight = rh;
        kN.Value = 0; kN.Limits = [0 Ex.N];
        kN.MajorTicks = 0:Ex.N/5:Ex.N; kN.MinorTicks = 0:Ex.N;   % Rastung bei ganzen Schritten
        hEq.Text = Ex.eq;
        xlim(ax1,[-0.1 Ex.N+0.1]); ylim(ax1,Ex.yl);
        ax1.XTick = 0:max(1,Ex.N/10):Ex.N;
        ylabel(ax1,Ex.var);
        xlim(ax2,Ex.yl); ylim(ax2,Ex.yl);
        xlabel(ax2,Ex.var); ylabel(ax2,Ex.varn);
        set(hI,'XData',Ex.yl,'YData',Ex.yl);
        if e ~= 3
            ax1.YTickMode = 'auto'; ax1.YTickLabelMode = 'auto';
        end
        drawSchema();
        requestUpdate();
    end

    function onPar(name,v)
        S.(name) = v;
        requestUpdate();
    end

    function onX0(v)
        S.x0(S.e) = v;
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

    function onStep(v)
        nNew = round(v);                        % zeitdiskret: nur ganze Schritte
        if nNew == S.n, return, end             % nur bei Schrittwechsel neu zeichnen
        S.n = nNew;
        redraw();
    end

    function onSnap(src)
        % Knopf auf den ganzen Schritt einrasten lassen
        src.Value = round(src.Value);
        onStep(src.Value);
    end

    function onStat(v)
        S.stat = v;
        redraw();
    end

    function onCob(v)
        % Treppendiagramm in der rechten Spalte ein-/ausblenden
        S.cob = v;
        if v, al.ColumnWidth = {'1x','1x'}; else, al.ColumnWidth = {'1x', 0}; end
        st = 'off'; if v, st = 'on'; end
        set([findall(ax2)' lg2],'Visible',st);
    end

    function onSchema(v)
        S.schema = v;
        if v, drawSchema(); end
        gS.Visible = v;
        al.Visible = ~v;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function [a,b] = coeff()
        % Koeffizienten a, b der Differenzengleichung x_{n+1} = a x_n + b
        switch S.e
            case 1, a = 1;         b = S.p;
            case 2, a = S.p;       b = 0;
            case 3, a = 1 - S.p;   b = S.p*Tu;
            otherwise, a = S.p;    b = S.b;
        end
    end

    function update()
        Ex = E(S.e);
        [a,b] = coeff();
        x = zeros(1,Ex.N+1); x(1) = S.x0(S.e);
        if S.e == 3                                % Achsenmarken T^u und T_0
            if abs(x(1) - Tu) < 0.5
                ax1.YTick = Tu; ax1.YTickLabel = {'T^u'};
            elseif x(1) > Tu
                ax1.YTick = [Tu x(1)]; ax1.YTickLabel = {'T^u','T_0'};
            else
                ax1.YTick = [x(1) Tu]; ax1.YTickLabel = {'T_0','T^u'};
            end
        end
        for k = 1:Ex.N
            x(k+1) = a*x(k) + b;
        end
        S.x = x;
        % Treppendiagramm: Graph von f und stationaerer Zustand (Schnitt mit der Identitaet)
        set(hF,'XData',Ex.yl,'YData',a*Ex.yl + b);
        if abs(1 - a) > 1e-12
            xs = b/(1 - a);
            if abs(a) < 1                          % stabil fuer |f'(x*)| = |a| < 1
                set(hEs,'XData',xs,'YData',xs); set(hEu,'XData',NaN,'YData',NaN);
            else
                set(hEu,'XData',xs,'YData',xs); set(hEs,'XData',NaN,'YData',NaN);
            end
        else
            set(hEs,'XData',NaN,'YData',NaN); set(hEu,'XData',NaN,'YData',NaN);
        end
        redraw();
    end

    function redraw()
        Ex = E(S.e);
        n = min(S.n,Ex.N);
        k = 0:n;
        set(hX,'XData',k,'YData',S.x(k+1));
        set(hM1,'XData',n,'YData',S.x(n+1));
        set(hP1,'XData',[n n],'YData',ax1.YLim);
        [a,b] = coeff();
        if S.stat && abs(1 - a) > 1e-12
            xs = b/(1 - a);                        % stationaerer Zustand
            set(hS,'XData',[0 Ex.N],'YData',[xs xs]);
        else
            set(hS,'XData',NaN,'YData',NaN);       % a = 1: kein (eindeutiger) stationaerer Zustand
        end
        % Treppe: (x_0,x_0) -> (x_0,x_1) -> (x_1,x_1) -> (x_1,x_2) -> ...
        cx = S.x(1); cy = S.x(1);
        for j = 1:n
            cx = [cx, S.x(j), S.x(j+1)];           %#ok<AGROW>
            cy = [cy, S.x(j+1), S.x(j+1)];         %#ok<AGROW>
        end
        set(hC,'XData',cx,'YData',cy);
        if S.schema, drawSchema(); end             % Pfeilrichtungen haengen von a, b und x_n ab
        drawnow limitrate
    end

    function drawSchema()
        % Kompartimentschema: ein Kasten fuer die Zustandsgroesse, jeder Pfeil ein Term
        % der Aenderung pro Schritt  x_{n+1} - x_n = r x_n + b  mit  r = a - 1
        % (Folie "Geometrische Folge": a = 1 + r, (pro Kopf) Wachstumsrate r).
        % Pfeilrichtungen folgen dem Vorzeichen der Terme im aktuellen Schritt n.
        cla(axS);
        xlim(axS,[0 100]); ylim(axS,[0 60]);
        fs = 26; fn = 'Times New Roman'; L = 2; G = [0.88 0.88 0.88];   % Linienstaerke Kasten = Pfeil-Standard; Schrift gross genug fuer den Hoersaal (min. 22 pt)
        [a,b] = coeff(); r = a - 1;
        yc = 30;                                   % Hoehe der Pfeile
        Ex = E(S.e); n = min(S.n,Ex.N);
        if numel(S.x) == Ex.N + 1, xn = S.x(n+1); else, xn = S.x0(S.e); end
        if S.e == 3
            sbox(40,22,20,16,'Temperatur','\itT_n');
            rectangle(axS,'Position',[4 22 20 16],'Curvature',[0.2 0.3], ...
                'FaceColor',[1 1 1],'EdgeColor','k','LineWidth',L,'LineStyle','--');
            tx(14,32.5,'Umgebung',fs-1,'FontWeight','bold'); tx(14,27,'\itT^u',fs);
            d = S.p*(Tu - xn);                     % Aenderung im Schritt n
            if d > 1e-9                            % T_n < T^u: Waerme fliesst in den Koerper
                arrow([24 yc],[40 yc]);
                tx(32,yc+4.5,'\alpha (\itT^u\rm\bf - \itT_n\rm\bf)',fs-1,'FontWeight','bold');
                tx(32,yc-5,'Wärmeaufnahme',fs-4);
            elseif d < -1e-9                       % T_n > T^u: Waerme fliesst an die Umgebung
                arrow([40 yc],[24 yc]);
                tx(32,yc+4.5,'\alpha (\itT_n\rm\bf - \itT^u\rm\bf)',fs-1,'FontWeight','bold');
                tx(32,yc-5,'Wärmeabgabe',fs-4);
            else
                tx(32,yc,'kein Wärmefluss',fs-4);
            end
            tx(50,53,'\itT_{n+1}\rm\bf - \itT_n\rm\bf = \alpha (\itT^u\rm\bf - \itT_n\rm\bf)',fs+2);
            tx(50,9,{'Pfeilrichtung im aktuellen Schritt (Knopf \itn\rm\bf):', ...
                sprintf('\\itn\\rm\\bf = %d:   \\itT_n\\rm\\bf = %.2f,   \\alpha (\\itT^u\\rm\\bf - \\itT_n\\rm\\bf) = %.2f',n,xn,d)},fs-4);
            return
        end
        sbox(40,22,20,16,'Bestand','\itx_n');
        % Konvention (alle Schemata): Vermehrung immer links (wie im Malaria-Modell),
        % weitere Prozesse rechts; Pfeilrichtung = Vorzeichen des Terms
        % Vermehrung bzw. Abnahme proportional zum Bestand (links)
        if S.e == 2 || S.e == 4
            if r*xn >= 0                           % Term r x_n im aktuellen Schritt
                sink(8,yc); arrow([12 yc],[40 yc]);
                tx(25,yc+4.5,'\itr\rm\bf \itx_n',fs+1,'FontWeight','bold'); tx(25,yc-5,'Vermehrung',fs-4);
            else
                arrow([40 yc],[12 yc]); sink(8,yc);
                tx(25,yc+4.5,'-\itr\rm\bf \itx_n',fs+1,'FontWeight','bold'); tx(25,yc-5,'Abnahme',fs-4);
            end
        end
        % konstanter Zu- bzw. Abfluss b (rechts)
        if S.e == 1 || S.e == 4
            if b >= 0
                sink(92,yc); arrow([88 yc],[60 yc]);
                tx(75,yc+4.5,'\itb',fs+1,'FontWeight','bold'); tx(75,yc-5,'Zufluss',fs-4);
            else
                arrow([60 yc],[88 yc]); sink(92,yc);
                tx(75,yc+4.5,'-\itb',fs+1,'FontWeight','bold'); tx(75,yc-5,'Abfluss',fs-4);
            end
        end
        switch S.e
            case 1
                tx(50,53,'\itx_{n+1}\rm\bf - \itx_n\rm\bf = \itb',fs+2);
                tx(50,9,'Änderung pro Schritt konstant',fs-4);
            case 2
                tx(50,53,'\itx_{n+1}\rm\bf - \itx_n\rm\bf = \itr\rm\bf \itx_n\rm\bf,   \itr\rm\bf = \ita\rm\bf - 1',fs+2);
                tx(50,9,{'Änderung pro Schritt proportional zum Bestand', ...
                    sprintf('\\itr\\rm\\bf = %.2f;   \\itn\\rm\\bf = %d:   \\itx_n\\rm\\bf = %.2f,   \\itr\\rm\\bf \\itx_n\\rm\\bf = %.2f',r,n,xn,r*xn)},fs-4);
            otherwise
                tx(50,53,'\itx_{n+1}\rm\bf - \itx_n\rm\bf = \itr\rm\bf \itx_n\rm\bf + \itb\rm\bf,   \itr\rm\bf = \ita\rm\bf - 1',fs+2);
                tx(50,9,{sprintf('\\itr\\rm\\bf = %.2f: (pro Kopf) Wachstumsrate,  \\itb\\rm\\bf = %.2f: Zu- bzw. Abfluss',r,b), ...
                    sprintf('\\itn\\rm\\bf = %d:   \\itx_n\\rm\\bf = %.2f,   \\itr\\rm\\bf \\itx_n\\rm\\bf = %.2f',n,xn,r*xn)},fs-4);
        end

        function sbox(x0,y0,w,h,ttl,var)
            rectangle(axS,'Position',[x0 y0 w h],'Curvature',[0.2 0.3], ...
                'FaceColor',G,'EdgeColor','k','LineWidth',L);
            tx(x0+w/2,y0+h*0.66,ttl,fs-1,'FontWeight','bold');
            tx(x0+w/2,y0+h*0.30,var,fs);
        end
        function sink(x,y)
            tx(x,y,char(8709),fs+6);               % Quelle bzw. Senke
        end
        function arrow(p,q)
            % Standard-Pfeil aller Schemata (Kapitel I, Folien-Stil): gefuellte Flaeche aus Schaft
            % und Spitze; Masse relativ zur x-Achsenbreite (100 Einheiten) -> gleiche Optik in allen Apps.
            % Hilfsvariablen mit Praefix ar_, damit nichts im umgebenden Schema ueberschrieben wird.
            ar_W = diff(axS.XLim)/100;
            ar_u = (q - p)/norm(q - p); ar_n = [-ar_u(2) ar_u(1)];
            ar_t = 0.12*ar_W; ar_l = 2.6*ar_W; ar_w = 1.2*ar_W;   % halbe Schaftbreite, Spitzenlaenge, halbe Spitzenbreite
            ar_b = q - ar_l*ar_u;                              % Beginn der Spitze
            ar_V = [p + ar_t*ar_n; ar_b + ar_t*ar_n; ar_b + ar_w*ar_n; q; ...
                    ar_b - ar_w*ar_n; ar_b - ar_t*ar_n; p - ar_t*ar_n];
            patch(axS,'XData',ar_V(:,1),'YData',ar_V(:,2),'FaceColor','k','EdgeColor','k', ...
                'LineWidth',0.5,'Clipping','off');
        end
        function tx(x,y,s,f,varargin)
            text(axS,x,y,s,'FontName',fn,'FontSize',f,'FontWeight','bold','HorizontalAlignment','center', ...
                'Interpreter','tex',varargin{:});
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

    function h = mkLabel(parent,row,txt)
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
