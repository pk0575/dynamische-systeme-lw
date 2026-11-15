function alcohol_app
% ALCOHOL_APP  Interaktive App zum Pharmakokinetik-Modell nach Pieters et al. (1990)
%
%   Bezeichnungen: C_M Magen, C_D Duenndarm, C_B Blut
%   (bei Pieters et al. 1990 / Wedel et al. 1991: C1, C2, C3)
%
%   dCM/dt = -k1*CM/(1+a*CM^2)                    (Magen)
%   dCD/dt =  k1*CM/(1+a*CM^2) - k2*CD            (Duenndarm)
%   dCB/dt =  k2*CD - Vmax*CB/(Km+CB)             (Blut)
%
%   Bedienelemente:
%     - Schalter maennlich / weiblich  (Parametersatz und Widmark-Faktor)
%     - Knopf Zeit t in [0, T]         (Kurven werden bis t gezeichnet)
%     - Knopf Alkoholmenge A (g)       (0.5 l Bier ca. 20 g, 0.2 l Wein ca. 16 g)
%     - Regler Koerpergewicht m (kg)
%     - Auswahl Messdaten: keine / Wilkinson 1977 / Pieters 1990
%     - Kontrollkaestchen Kompartimentschema (zeigt das Schema statt des Diagramms)
%
%   Anfangskonzentration im Magen nach Widmark:  CM(0) = A / (r*m)
%   mit Verteilungsfaktor r = 0.68 (maennlich) bzw. 0.55 (weiblich).
%
%   Messdaten: Wilkinson PK, Sedman AJ, Sakmar E, Kay DR, Wagner JG (1977),
%   Pharmacokinetics of ethanol after oral administration in the fasting
%   state, J Pharmacokinet Biopharm 5(3):207-224, Tabelle II:
%   mittlere Kapillarblut-Konzentration (mg/ml = g/l) von 8 nuechternen
%   Maennern (21-27 J., mittl. Koerpergewicht 74,6 kg) nach 11,2 / 22,4 /
%   33,6 / 45,0 g Alkohol (15/30/45/60 ml 95%iger Alkohol in 150 ml O-Saft).
%   Bei Auswahl werden maennlich / 74,6 kg eingestellt, alle vier
%   Messreihen gleichzeitig gezeigt (grau, beschriftet), die Reihe zur
%   eingestellten Alkoholmenge schwarz; die Alkoholmenge rastet auf die
%   vier Dosen ein.
%
%   Messdaten Pieters et al. (1990), Abb. 2 (aus der Abbildung ausgelesen):
%   Einzelkurven eines Mannes (Nr. 7, 3. Tag) und einer Frau (Nr. 9,
%   2. Tag) nach 28,5 g Alkohol, venoeses Blut. Zeitnullpunkt = Mitte der
%   Trinkzeit 8:45-9:00 Uhr (t = Uhrzeit - 8,875 h). Koerpergewicht der
%   beiden Personen ist nicht angegeben; in diesem Modus rechnet die App
%   daher mit den individuellen Parametern aus Tabelle 1 (inkl. C_M(0)),
%   Koerpergewicht und Alkoholmenge sind gesperrt, der Schalter waehlt
%   die Person.
%
%   Fuer MATLAB R2025b.

%% Parameter (Pieters et al., Alcohol & Alcoholism, 1990)
par.m = struct('Vmax',0.470,'Km',0.380,'a',0.42,'k1',5.55,'k2',7.05,'r',0.68);
par.w = struct('Vmax',0.480,'Km',0.405,'a',0.75,'k1',4.96,'k2',4.96,'r',0.55);

%% Messdaten Wilkinson et al. (1977), Tabelle II (NaN = nicht gemessen)
W.m  = 74.6;                       % mittleres Koerpergewicht (kg)
W.A  = [11.2 22.4 33.6 45.0];      % Alkoholmenge (g)
W.t  = [0 .067 .133 .167 .2 .267 .333 .417 .5 .667 .75 .833 1 1.167 1.25 ...
        1.33 1.5 1.75 2 2.25 2.5 2.75 3 3.5 3.75 4 4.25 4.5 4.75 5 5.25 ...
        5.5 5.75 6 6.25 6.5 6.75 7]';
n = NaN;
W.C = [ ...
 % 11.2 g  22.4 g  33.6 g  45.0 g
   0       0       0       0
   .032    .071    n       n
   .096    .019    n       n
   n       n       .28     .30
   .13     .25     n       n
   .17     .30     n       n
   .16     .31     .42     .46
   .17     n       n       n
   .16     .41     .51     .59
   n       n       .61     .66
   .12     .40     n       n
   n       n       .65     .71
   .090    .33     .63     .77
   n       n       .59     .75
   .062    .29     n       n
   n       n       .53     .70
   .033    .24     .50     .71
   .020    .22     .43     .72
   .012    .18     .40     .64
   .0074   .15     n       n
   .0052   .12     .32     .57
   .0034   n       n       n
   .0024   .069    .28     .45
   n       .034    .22     .43
   n       .017    n       n
   n       .010    .15     .36
   n       .0068   n       n
   n       .0052   .081    .27
   n       .0037   .059    .22
   n       n       .042    .18
   n       n       .021    .15
   n       n       .014    .11
   n       n       .0099   .079
   n       n       .0056   .050
   n       n       n       .037
   n       n       n       .020
   n       n       n       .017
   n       n       n       .012 ];

%% Messdaten Pieters et al. (1990), Abb. 2, mit individuellen Parametern (Tab. 1)
P.m = struct('Vmax',0.228,'Km',0.092,'a',0.404,'k1',2.912,'k2',4.635,'C0',0.505, ...
    'name','Mann Nr. 7');
P.m.t = [8.875 9.00 9.16 9.31 9.49 9.67 9.85 10.10 10.35 10.58 10.85 11.33 ...
         11.82 12.35 12.81 13.32 13.79 15.31 15.78]' - 8.875;
P.m.C = [0 .054 .176 .215 .249 .297 .296 .305 .274 .241 .202 .136 ...
         .060 .042 .020 .011 .009 .007 .008]';
P.w = struct('Vmax',1.471,'Km',1.210,'a',2.916,'k1',4.120,'k2',2.834,'C0',0.878, ...
    'name','Frau Nr. 9');
P.w.t = [8.875 9.08 9.24 9.43 9.59 9.76 9.93 10.17 10.43 10.68 10.93 11.43 ...
         11.87 12.40 12.92 13.41 13.93 15.40 15.91]' - 8.875;
P.w.C = [0 .014 .098 .235 .328 .402 .431 .461 .393 .337 .282 .207 ...
         .123 .056 .036 .013 .006 .007 .009]';
PA = 28.5;                         % Alkoholmenge bei Pieters (g)

T     = 8;             % Simulationsende (h)
Amax  = 60;            % max. Alkoholmenge (g)
mLim  = [50 120];      % Bereich Koerpergewicht (kg)
yMax  = Amax/(par.w.r*mLim(1)) + 0.1;   % feste y-Achse fuer Vergleichbarkeit
nt    = 1001;
options = odeset('RelTol',1e-8,'AbsTol',1e-10);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 28;
lw    = 2;
colS  = [0.000 0.447 0.741];   % Magen     (blau)
colG  = [0.466 0.674 0.188];   % Duenndarm (gruen)
colC  = [0.850 0.150 0.150];   % Blut      (rot)

%% Zustand
S.sex = 'm';
S.A   = 40;
S.m   = 75;
S.t   = 0;
S.tt  = linspace(0,T,nt)';
S.x   = zeros(nt,3);
S.C0  = 0;
S.schema = false;
S.data   = 'keine';                % 'keine' | 'W' (Wilkinson) | 'P' (Pieters)

%% GUI
fig = uifigure('Name','Alkoholkonzentration im Blut', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

% --- Achsen
ax = uiaxes(gl);
ax.Layout.Row = 1; ax.Layout.Column = 1;
ax.FontSize   = fSize;
ax.FontWeight = 'bold';
ax.FontName   = fName;
ax.Color      = [1 1 1];
ax.Box        = 'on';
hold(ax,'on')
xlabel(ax,'Zeit t (h)');
ylabel(ax,'Alkoholkonzentration (g/l)');
xlim(ax,[-0.2, T+0.2]);
ylim(ax,[-0.05, yMax]);

hS = plot(ax,NaN,NaN,'Color',colS,'LineWidth',lw,'DisplayName','Magen');
hG = plot(ax,NaN,NaN,'Color',colG,'LineWidth',lw,'DisplayName','Dünndarm');
hC = plot(ax,NaN,NaN,'Color',colC,'LineWidth',lw+1,'DisplayName','Blut');
hP = plot(ax,NaN,NaN,'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle',':', ...
    'HandleVisibility','off');
hM = plot(ax,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',colC, ...
    'MarkerEdgeColor',colC,'HandleVisibility','off');

hD = plot(ax,NaN,NaN,'o','MarkerSize',10,'LineWidth',2,'MarkerEdgeColor','k', ...
    'MarkerFaceColor',[1 1 1],'DisplayName','Messung','Visible','off');

% alle vier Wilkinson-Messreihen (grau); die aktuelle Dosis zeigt hD (schwarz)
grW = [0.62 0.62 0.62];
hWo = gobjects(1,4); tW = gobjects(1,4);
for kk = 4:-1:1
    hWo(kk) = plot(ax,NaN,NaN,'o','MarkerSize',8,'LineWidth',1.5,'MarkerEdgeColor',grW, ...
        'MarkerFaceColor',[1 1 1],'HandleVisibility','off','Visible','off');
    [cpk,ipk] = max(W.C(:,kk));
    tW(kk) = text(ax,W.t(ipk)+0.2,cpk+0.03, ...
        [strrep(sprintf('%.1f',W.A(kk)),'.',',') ' g'],'FontName',fName, ...
        'FontSize',fSize-8,'FontWeight','bold','Color',grW, ...
        'HorizontalAlignment','left','VerticalAlignment','bottom','Visible','off');
end
uistack(hD,'top');

lg = [];
makeLegend();

% --- Kompartimentschema (gleiche Zelle wie das Diagramm, zunaechst ausgeblendet)
axS = uiaxes(gl);
axS.Layout.Row = 1; axS.Layout.Column = 1;
axS.Color = [1 1 1];
drawSchema(axS);
set(findall(axS),'Visible','off');

% --- Seitenleiste
pl = uigridlayout(gl,[17 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...
pl.RowHeight = {'1x', 55, 35, 30, 70, 35, 30, 170, 35, 30, 170, 35, 30, 34, 10, 28, '1x'};   % '1x' oben/unten = vertikal mittig
pl.BackgroundColor = [1 1 1];

mkLabel(pl,3,'Geschlecht');
sw = uiswitch(pl,'slider','Items',{'männlich','weiblich'}, ...
    'ItemsData',{'m','w'},'Value',S.sex, ...
    'FontName',fName,'FontSize',22,'FontWeight','bold');
sw.Layout.Row = 2;
sw.ValueChangedFcn = @(src,~) onSex(src.Value);

mkLabel(pl,12,'Zeit t (h)');
kT = uiknob(pl,'continuous','Limits',[0 T],'Value',S.t, ...
    'MajorTicks',0:1:T,'FontName',fName,'FontSize',18,'FontWeight','bold');
kT.Layout.Row = 11;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);

mkLabel(pl,9,'Alkoholmenge (g)');
kA = uiknob(pl,'continuous','Limits',[0 Amax],'Value',S.A, ...
    'MajorTicks',0:10:Amax,'FontName',fName,'FontSize',18,'FontWeight','bold');
kA.Layout.Row = 8;
kA.ValueChangingFcn = @(~,evt) onA(evt.Value);
kA.ValueChangedFcn  = @(src,~) onAdone(src.Value);

mkLabel(pl,6,'Körpergewicht (kg)');
sm = uislider(pl,'Limits',mLim,'Value',S.m, ...
    'MajorTicks',mLim(1):10:mLim(2),'FontName',fName,'FontSize',16,'FontWeight','bold');
sm.Layout.Row = 5;
sm.ValueChangingFcn = @(~,evt) onM(evt.Value);
sm.ValueChangedFcn  = @(src,~) onM(src.Value);

cgD = uigridlayout(pl,[1 3]);          % zentriert
cgD.Layout.Row = 14;
cgD.ColumnWidth = {'1x','fit','1x'};
cgD.Padding = [0 0 0 0];
cgD.BackgroundColor = [1 1 1];
ddD = uidropdown(cgD,'Items',{'keine Messdaten','Wilkinson 1977','Pieters 1990'}, ...
    'ItemsData',{'keine','W','P'},'Value',S.data, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold','BackgroundColor',[1 1 1]);
ddD.Layout.Column = 2;
ddD.ValueChangedFcn = @(src,~) onData(src.Value);

cg = uigridlayout(pl,[1 3]);          % zentriert
cg.Layout.Row = 16;
cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0];
cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','Kompartimentschema','Value',S.schema, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onSchema(src.Value);

% Startlösung
solve();
redraw();

%% ---------------- Callbacks ----------------
    function onSex(v), S.sex = v; solve(); redraw(); end
    function onTime(v), S.t = v; redraw(); end
    function onA(v),   S.A = v;   solve(); redraw(); end

    function onAdone(v)
        % bei eingeblendeten Messdaten auf die gemessenen Dosen einrasten
        if strcmp(S.data,'W'), v = nearestDose(v); kA.Value = v; end
        onA(v);
    end

    function A = nearestDose(v)
        [~,k] = min(abs(W.A - v)); A = W.A(k);
    end

    function onData(v)
        S.data = v;
        kA.Enable = 'on'; sm.Enable = 'on';
        switch v
            case 'W'
                % Versuchsbedingungen: Maenner, mittleres Gewicht 74,6 kg
                S.sex = 'm'; sw.Value = 'm';
                S.m = W.m;   sm.Value = W.m;
                S.A = nearestDose(S.A); kA.Value = S.A;
            case 'P'
                % Einzelpersonen: 28,5 g, Gewicht unbekannt -> gesperrt
                S.A = PA; kA.Value = PA;
                kA.Enable = 'off'; sm.Enable = 'off';
        end
        solve();
        makeLegend();
        redraw();
    end

    function makeLegend()
        if strcmp(S.data,'keine'), h = [hS hG hC]; else, h = [hS hG hC hD]; end
        lg = legend(ax,h);
        set(lg,'Location','northeast','FontSize',fSize-4,'FontName',fName, ...
            'AutoUpdate','off');
        if S.schema, lg.Visible = 'off'; end
    end
    function onM(v),   S.m = v;   solve(); redraw(); end

    function onSchema(v)
        % Schema statt Diagramm zeigen (und umgekehrt)
        S.schema = v;
        if v, a = 'off'; b = 'on'; else, a = 'on'; b = 'off'; end
        set(findall(ax),'Visible',a); lg.Visible = a;
        set(findall(axS),'Visible',b);
        redraw();                      % Sichtbarkeit der Messdaten neu setzen
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function solve()
        if strcmp(S.data,'P')
            p  = P.(S.sex);            % individuelle Parameter (Pieters, Tab. 1)
            C0 = p.C0;                 % C_M(0) dort mitgeschaetzt
        else
            p  = par.(S.sex);
            C0 = S.A/(p.r*S.m);        % Widmark: CM(0) = A/(r*m)
        end
        S.C0 = C0;
        if C0 <= 0
            S.x = zeros(nt,3);
            return
        end
        q = [p.k1; p.a; p.k2; p.Vmax; p.Km];
        [~,x] = ode15s(@model,S.tt,[C0;0;0],options,q);
        S.x = max(x,0);
    end

    function redraw()
        idx = S.tt <= S.t + 1e-12;
        tt  = S.tt(idx);
        set(hS,'XData',tt,'YData',S.x(idx,1));
        set(hG,'XData',tt,'YData',S.x(idx,2));
        set(hC,'XData',tt,'YData',S.x(idx,3));

        cBlut = interp1(S.tt,S.x(:,3),S.t);
        set(hM,'XData',S.t,'YData',cBlut);
        set(hP,'XData',[S.t S.t],'YData',[-0.05 yMax]);

        % Messdaten: Datensatz zur naechstgelegenen Dosis, bis Zeit t
        showW = strcmp(S.data,'W') && ~S.schema;
        switch S.data
            case 'W'
                [~,k] = min(abs(W.A - S.A));
                for j = 1:4
                    okj = ~isnan(W.C(:,j)) & W.t <= S.t + 1e-12;
                    set(hWo(j),'XData',W.t(okj),'YData',W.C(okj,j));
                    if j == k, col = [0 0 0]; else, col = grW; end
                    tW(j).Color = col;
                end
                ok = ~isnan(W.C(:,k)) & W.t <= S.t + 1e-12;
                set(hD,'XData',W.t(ok),'YData',W.C(ok,k), ...
                    'DisplayName',['Messung ' strrep(sprintf('%.1f',W.A(k)),'.',',') ' g']);
            case 'P'
                q  = P.(S.sex);
                ok = q.t <= S.t + 1e-12;
                set(hD,'XData',q.t(ok),'YData',q.C(ok),'DisplayName',['Messung ' q.name]);
        end
        if strcmp(S.data,'keine') || S.schema
            hD.Visible = 'off';
        else
            hD.Visible = 'on';
        end
        set(hWo,'Visible','off'); set(tW,'Visible','off');
        if showW
            [~,k] = min(abs(W.A - S.A));
            set(hWo(setdiff(1:4,k)),'Visible','on');
            set(tW,'Visible','on');
        end

        drawnow limitrate
    end

    function drawSchema(sa)
        % Kompartimentschema: Magen -> Duenndarm -> Blut -> Abbau; jeder Pfeil = ein Term
        hold(sa,'on'); axis(sa,'off');
        sa.DataAspectRatio = [1 1 1];
        xlim(sa,[-4 122]); ylim(sa,[2 48]);
        disableDefaultInteractivity(sa); sa.Toolbar.Visible = 'off';
        fs = 15; fn = 'Times New Roman'; L = 1.6;
        tint = @(c) 1 - (1-c)*0.3;
        by = 18; bh = 12; bw = 18; ym = by + bh/2;
        box(24,colS,'Magen','C_M'); box(62,colG,'Dünndarm','C_D'); box(100,colC,'Blut','C_B');
        % Getraenk -> Magen: Anfangswert (gestrichelt)
        text(sa,9,ym+4.6,'Getränk','HorizontalAlignment','center','FontSize',fs-1,'FontWeight','bold','FontName',fn);
        text(sa,9,ym+1.6,'Alkoholmenge A','HorizontalAlignment','center','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        arrow([0 ym],[24 ym],'--');
        text(sa,10,by-3,{'Anfangswert:','C_M(0) = A/(r m)','m: Körpergewicht,', ...
            ['r = 0,68 ' char(9794) ' / 0,55 ' char(9792)]}, ...
            'HorizontalAlignment','center','VerticalAlignment','top','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        % Magen -> Duenndarm
        arrow([42 ym],[62 ym],'-');
        text(sa,52,ym+1.6,'Magenentleerung','HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        text(sa,52,ym-1.4,'\boldmath$k_1\,\frac{C_M}{1+a\,C_M^2}$','Interpreter','latex', ...
            'HorizontalAlignment','center','VerticalAlignment','top','FontSize',fs+1);
        % Duenndarm -> Blut
        arrow([80 ym],[100 ym],'-');
        text(sa,90,ym+1.6,'Resorption','HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        text(sa,90,ym-1.4,'\boldmath$k_2\,C_D$','Interpreter','latex', ...
            'HorizontalAlignment','center','VerticalAlignment','top','FontSize',fs+1);
        % Blut -> Abbau (Michaelis-Menten)
        arrow([109 by+bh],[109 by+bh+8],'-');
        text(sa,109,by+bh+10.2,char(8709),'HorizontalAlignment','center','FontSize',fs+6,'FontName',fn,'FontWeight','bold');
        text(sa,107,by+bh+6.3,'Abbau in der Leber (ADH)','HorizontalAlignment','right','FontSize',fs-3,'FontName',fn,'FontWeight','bold');
        text(sa,107,by+bh+2.6,'\boldmath$V_{max}\,\frac{C_B}{K_m+C_B}$','Interpreter','latex', ...
            'HorizontalAlignment','right','FontSize',fs+1);
        text(sa,109,by-2.2,{'= Blutalkohol-','konzentration'},'HorizontalAlignment','center', ...
            'VerticalAlignment','top','FontSize',fs-3,'FontName',fn,'FontWeight','bold');

        function box(x0,col,ttl,var)
            rectangle(sa,'Position',[x0 by bw bh],'Curvature',[5/bw 5/bh], ...
                'FaceColor',tint(col),'EdgeColor','k','LineWidth',L);
            text(sa,x0+bw/2,by+bh*0.64,ttl,'HorizontalAlignment','center','FontSize',fs,'FontWeight','bold','FontName',fn);
            text(sa,x0+bw/2,by+bh*0.30,var,'HorizontalAlignment','center','FontSize',fs,'FontName',fn,'FontWeight','bold');
        end
        function arrow(p,q,ls)
            u = (q - p)/norm(q - p); l = 1.8; w = 0.8; n = [-u(2) u(1)];
            plot(sa,[p(1) q(1)-l*u(1)],[p(2) q(2)-l*u(2)],['k' ls],'LineWidth',L);
            patch(sa,[q(1), q(1)-l*u(1)+w*n(1), q(1)-l*u(1)-w*n(1)], ...
                     [q(2), q(2)-l*u(2)+w*n(2), q(2)-l*u(2)-w*n(2)],'k','EdgeColor','k');
        end
    end

    function mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',22, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end

%% ---------------- Modell ----------------
function dx = model(~,x,q)
CM = x(1); CD = x(2); CB = x(3);
k1 = q(1); a = q(2); k2 = q(3); Vmax = q(4); Km = q(5);

flux = k1*CM/(1+a*CM^2);     % Magenentleerung

dCM = -flux;
dCD =  flux - k2*CD;
dCB =  k2*CD - Vmax*CB/(Km+CB);

dx = [dCM; dCD; dCB];
end
