function chemostat_hopf_app
% CHEMOSTAT_HOPF_APP  Algen und Raedertierchen im Chemostat
%   nach Fussmann, Ellner, Shertzer & Hairston, "Crossing the Hopf
%   bifurcation in a live predator-prey system", Science 290:1358 (2000)
%
%   N: Stickstoff, C: Algen (Chlorella), R: reproduktive Raedertierchen,
%   B: alle Raedertierchen (Brachionus); Zeit in Tagen.
%
%   dN/dt = D*(Ni - N) - FC(N)*C
%   dC/dt = FC(N)*C - FB(C)*B/eps - D*C
%   dR/dt = FB(C)*R - (D + m + lambda)*R
%   dB/dt = FB(C)*R - (D + m)*B
%   FC(N) = bC*N/(KC + N),   FB(C) = bB*C/(KB + C)
%
%   Je nach Verduennungsrate D: stabiles Gleichgewicht (sehr klein),
%   Raeuber-Beute-Zyklen (mittel, nach Hopf-Bifurkation), wieder stabiles
%   Gleichgewicht (gross), Auswaschen der Raedertierchen (sehr gross).
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Verduennungsrate D (1/Tag)
%     - Knopf Stickstoff im Zulauf Ni (umol/l), 20 ... 160
%     - Knopf Zeit (Tage)
%     - Kontrollkaestchen: Bifurkationsdiagramm
%     - Kontrollkaestchen: Kompartimentschema / Bioreaktor (Bild statt Diagramme)
%
%   Am Geraet wird der Zufluss F (l/Tag) eingestellt; ins Modell geht nur
%   die Verduennungsrate D = F/V ein (V = Reaktorvolumen, konstant).
%
%   Parameterwerte aus Fussmann et al. (2000), Fussnote 18; Ni = 80 umol/l.
%   Alle Groessen in umol Stickstoff pro Liter (Fussnote 18):
%     1 umol/l Chlorella   = 5e4 Zellen/ml
%     1 umol/l Brachionus  = 5 Weibchen/ml
%   Im Experiment liegen die Hopf-Bifurkationen bei 0.32 < D < 0.64
%   und D ~ 1.16 pro Tag; das Modell sagt sie bei etwas kleineren
%   D voraus (hier ca. 0.15 und 0.98 pro Tag).
%
%   y-Achsen: fest beim Drehen an D, mitwachsend mit Ni
%   (Algen bis 1.1*Ni+5, Raedertierchen bis 0.22*Ni+2; deckt alle D ab).
%   Das Bild des Bioreaktors laedt 'raedertierchen_foto.png' aus dem
%   Ordner der App (fehlt die Datei, bleibt der Platz leer).
%
%   Fuer MATLAB R2025b.

%% Parameter
P.Ni = 80;   P.bC = 3.3;  P.KC = 4.3;      % Stickstoff im Zulauf, Algen
P.bB = 2.25; P.KB = 15;   P.eps = 0.25;    % Raedertierchen
P.m  = 0.055; P.lam = 0.4;                 % Sterberate, Seneszenz
y0   = [P.Ni; 10; 1; 1];                   % N (= Zulauf), C, R, B
Tend = 120;
NiLim = [20 160];                          % Bereich des Ni-Knopfs
dGrid = (0.025:0.025:1.8)';                  % fuer das Bifurkationsdiagramm
% Gerechnet wird mit den Logarithmen der Zustaende (u = ln y): Algen fallen
% zeitweise auf ~1e-11 umol/l; so bleiben auch sehr kleine Werte relativ
% genau, und ode45 ist schnell genug fuer fluessiges Drehen am Knopf.
options = odeset('RelTol',1e-5,'AbsTol',1e-5,'InitialStep',1e-3,'MaxStep',0.5);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colC  = [0.466 0.674 0.188];   % Algen (gruen)
colB  = [0.850 0.325 0.098];   % Raedertierchen (orange)

%% Zustand
S.d    = 0;                                % Start ohne Durchfluss (vor der 1. Hopf-Bifurkation bei D ~ 0.15)
S.t    = 0;
S.bif  = false;
S.tt   = (0:0.1:Tend)';
S.Y    = zeros(numel(S.tt),4);
S.busy = false; S.pending = false;
S.bifB = [];                               % zwischengespeichertes Diagramm
S.pic  = '';                               % '' | 'S' (Schema) | 'R' (Reaktor)

%% GUI
fig = uifigure('Name','Algen und Rädertierchen im Chemostat (Hopf-Bifurkation)', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[2 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x','1x'};
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

ax1 = mkAxes(al,1,1);
xlabel(ax1,'Zeit t (Tage)');
ylabel(ax1,'Algen C (µmol N/l)');
xlim(ax1,[0 Tend]);
hC  = plot(ax1,NaN,NaN,'-','Color',colC,'LineWidth',lw+1);
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colC,'MarkerEdgeColor',colC);

ax2 = mkAxes(al,2,1);
xlabel(ax2,'Zeit t (Tage)');
ylabel(ax2,'Rädertierchen B (µmol N/l)');
xlim(ax2,[0 Tend]);
hB  = plot(ax2,NaN,NaN,'-','Color',colB,'LineWidth',lw+1);
hP2 = plot(ax2,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hM2 = plot(ax2,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colB,'MarkerEdgeColor',colB);

% --- Bifurkationsdiagramm: Minimum/Maximum von B nach Einschwingen
ax3 = mkAxes(al,[1 2],2);
xlabel(ax3,'Verdünnungsrate D (1/Tag)');
ylabel(ax3,'Rädertierchen B (Min./Max.)');
xlim(ax3,[0 1.8]);
hBif = plot(ax3,NaN,NaN,'.','Color',[0 0 0],'MarkerSize',16);
hBd  = plot(ax3,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1.5);
hB3  = plot(ax3,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colB,'MarkerEdgeColor',colB);
setVis3('off');
setYLim();

% --- Kompartimentschema und Bioreaktor-Bild (gleiche Zelle, zunaechst verborgen)
gS = uigridlayout(gl,[1 1]); gS.Layout.Row = 1; gS.Layout.Column = 1;
gS.BackgroundColor = [1 1 1];
axS = mkPic(gS); drawSchema(axS); gS.Visible = 'off';
gR = uigridlayout(gl,[1 1]); gR.Layout.Row = 1; gR.Layout.Column = 1;
gR.BackgroundColor = [1 1 1];
hNiTxt = [];                               % Ni-Angabe im Reaktorbild
axR = mkPic(gR); drawReactor(axR); gR.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[14 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 130, 35, 10, 130, 35, 10, 130, 35, 40, 28, 28, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kD = uiknob(pl,'continuous','Limits',[0 1.8],'Value',S.d, ...
    'MajorTicks',0:0.3:1.8,'FontName',fName,'FontSize',16,'FontWeight','bold');
kD.Layout.Row = 2;
kD.ValueChangingFcn = @(~,evt) onD(evt.Value);
kD.ValueChangedFcn  = @(src,~) onD(src.Value);
mkLabel(pl,3,'Verdünnungsrate D (1/Tag)');

kN = uiknob(pl,'continuous','Limits',NiLim,'Value',P.Ni, ...
    'MajorTicks',NiLim(1):20:NiLim(2),'FontName',fName,'FontSize',16,'FontWeight','bold');
kN.Layout.Row = 5;
kN.ValueChangingFcn = @(~,evt) onNi(evt.Value,false);
kN.ValueChangedFcn  = @(src,~) onNi(src.Value,true);
mkLabel(pl,6,'Stickstoff im Zulauf N_i (µmol/l)');

kT = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:20:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 8;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,9,'Zeit t (Tage)');

cb  = mkCheck(11,'Bifurkationsdiagramm',@(src,~) onBif(src.Value));
cbS = mkCheck(12,'Kompartimentschema',@(src,~) onPic('S',src.Value));
cbR = mkCheck(13,'Bioreaktor',@(src,~) onPic('R',src.Value));
gl.RowHeight = {'1x'};                % nur eine Zeile (Seitenleiste ueber volle Hoehe)

update();

%% ---------------- Callbacks ----------------
    function onD(v)
        S.d = v;
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

    function onNi(v,final)
        % Stickstoff im Zulauf: Startwert N(0), y-Achsen und Bifurkations-
        % diagramm haengen von Ni ab
        P.Ni = v; y0(1) = v;
        S.bifB = []; set(hBif,'XData',NaN,'YData',NaN);
        setYLim();
        if ~isempty(hNiTxt), hNiTxt.String = sprintf('\\itN_i\\rm\\bf = %.0f µmol/l',v); end
        requestUpdate();
        if final && S.bif, computeBif(); redraw(); end
    end

    function setYLim()
        % beim Drehen an D fest, waechst mit Ni (deckt alle D ab)
        ylim(ax1,[0 1.1*P.Ni+5]);
        ylim(ax2,[0 0.22*P.Ni+2]);
        ylim(ax3,[0 0.22*P.Ni+2]);
    end

    function onTime(v)
        S.t = v;
        redraw();
    end

    function onBif(v)
        S.bif = v;
        if v
            if isempty(S.bifB), computeBif(); end
            al.ColumnWidth = {'1x','1x'}; setVis3('on');
        else
            al.ColumnWidth = {'1x', 0};   setVis3('off');
        end
        redraw();
    end

    function onPic(which,v)
        % Schema bzw. Reaktorbild statt der Diagramme zeigen
        if v, S.pic = which; else, S.pic = ''; end
        cbS.Value = strcmp(S.pic,'S');
        cbR.Value = strcmp(S.pic,'R');
        gS.Visible = strcmp(S.pic,'S');
        gR.Visible = strcmp(S.pic,'R');
        al.Visible = isempty(S.pic);
        cb.Enable  = isempty(S.pic);
    end

    function setVis3(st)
        ax3.Visible = st; hBif.Visible = st; hBd.Visible = st; hB3.Visible = st;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        [~,U] = ode45(@(t,u) rhsLog(u,S.d),S.tt,log(y0),options);
        Y = exp(U);
        S.Y = Y;
        redraw();
    end

    function computeBif()
        % einmalig: fuer jedes D 300 Tage rechnen, Min/Max von B
        % in den letzten 100 Tagen (nach dem Einschwingen)
        fig.Pointer = 'watch'; drawnow
        xs = []; ys = [];
        for k = 1:numel(dGrid)
            dk = dGrid(k);
            [~,U] = ode45(@(t,u) rhsLog(u,dk),[0 (200:0.1:300)],log(y0),options);
            Y = exp(U);
            b = Y(2:end,4);
            xs = [xs; dGrid(k); dGrid(k)];   %#ok<AGROW>
            ys = [ys; min(b); max(b)];       %#ok<AGROW>
        end
        S.bifB = [xs ys];
        set(hBif,'XData',xs,'YData',ys);
        fig.Pointer = 'arrow';
    end

    function dy = rhs(y,d)
        N = y(1); C = y(2); R = y(3); B = y(4);
        FC = P.bC*N/(P.KC + N);
        FB = P.bB*C/(P.KB + C);
        dy = [ d*(P.Ni - N) - FC*C;
               FC*C - FB*B/P.eps - d*C;
               FB*R - (d + P.m + P.lam)*R;
               FB*R - (d + P.m)*B ];
    end

    function du = rhsLog(u,d)
        % Modell fuer u = ln(y):  du/dt = (dy/dt) / y
        y  = exp(u);
        du = rhs(y,d)./y;
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        tt = S.tt(idx);
        set(hC,'XData',tt,'YData',S.Y(idx,2));
        set(hB,'XData',tt,'YData',S.Y(idx,4));
        Ct = interp1(S.tt,S.Y(:,2),S.t);  Bt = interp1(S.tt,S.Y(:,4),S.t);
        set(hM1,'XData',S.t,'YData',Ct);
        set(hM2,'XData',S.t,'YData',Bt);
        set(hP1,'XData',[S.t S.t],'YData',ax1.YLim);
        set(hP2,'XData',[S.t S.t],'YData',ax2.YLim);
        set(hBd,'XData',[S.d S.d],'YData',ax3.YLim);
        set(hB3,'XData',S.d,'YData',Bt);
        drawnow limitrate
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

    function c = mkCheck(row,txt,fcn)
        g = uigridlayout(pl,[1 3]);          % zentriert
        g.Layout.Row = row;
        g.ColumnWidth = {'1x','fit','1x'};
        g.Padding = [0 0 0 0];
        g.BackgroundColor = [1 1 1];
        c = uicheckbox(g,'Text',txt,'Value',false, ...
            'FontName',fName,'FontSize',16,'FontWeight','bold');
        c.Layout.Column = 2;
        c.ValueChangedFcn = fcn;
    end

    function mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',['\bf ' txt],'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end

%% ---------------- Kompartimentschema / Bioreaktor-Bild ----------------
    function sa = mkPic(parent)
        sa = uiaxes(parent);
        sa.Color = [1 1 1];
        hold(sa,'on'); axis(sa,'off');
        sa.DataAspectRatio = [1 1 1];
        disableDefaultInteractivity(sa); sa.Toolbar.Visible = 'off';
    end

    function drawSchema(sa)
        % Kompartimentschema: jeder Pfeil = ein Term der Modellgleichungen
        xlim(sa,[-2 136]); ylim(sa,[-4 42]);
        fs = 15; fn = 'Times New Roman'; L = 1.6;
        colN = [0.000 0.447 0.741];
        tint = @(c,f) 1 - (1 - c)*(1 - f);
        mi = char(8722);                                  % Minuszeichen
        yb = 22; hb = 12; ym = yb + hb/2;
        sbox(14,yb,16,hb,tint(colN,0.7),'Stickstoff','\itN',fs);
        sbox(44,yb,16,hb,tint(colC,0.7),'Algen','\itC',fs);
        rectangle(sa,'Position',[90 19.5 44 20.5],'Curvature',[5/44 5/20.5], ...
            'FaceColor',tint(colB,0.88),'EdgeColor','k','LineWidth',L);
        tx(112,37.3,'Rädertierchen  \itB',fs,'FontWeight','bold');
        sbox(93,yb,15,hb,tint(colB,0.55),'reproduktiv','\itR',fs-2);
        sbox(116,yb,15,hb,tint(colB,0.55),'gealtert',['\itB\rm\bf ' mi ' \itR'],fs-2);
        % Zulauf
        tx(7,ym+3.2,'Zulauf',fs-1,'FontWeight','bold');
        sarrow([0 ym],[14 ym]);
        tl(7,ym-1.4,'$D\,N_i$',fs+1,'top');
        % N -> C
        sarrow([30 ym],[44 ym]);
        tx(37,ym+1.4,'Aufnahme',fs-3,'VerticalAlignment','bottom');
        tl(37,ym-1.4,'$F_C(N)\,C$',fs+1,'top');
        % C -> R
        sarrow([60 ym],[93 ym]);
        tx(76.5,ym+1.4,'Fraß',fs-3,'VerticalAlignment','bottom');
        tx(76.5,ym-1.4,{['Algen: ' mi '\itF_B\rm\bf(\itC\rm\bf) \itB\rm\bf/\epsilon'], ...
            'Geburten: \itF_B\rm\bf(\itC\rm\bf) \itR'},fs-4,'VerticalAlignment','top');
        % R -> B-R
        sarrow([108 ym],[116 ym]);
        tx(112,ym+1.2,'Altern',fs-5,'VerticalAlignment','bottom');
        tl(112,ym-1.2,'$\lambda R$',fs,'top');
        % Abfluss (und Tod)
        sink(22,yb,'Abfluss \itD N');
        sink(52,yb,'Abfluss \itD C');
        sink(100.5,19.5,'(\itD\rm\bf + \itm\rm\bf) \itR');
        sink(123.5,19.5,['(\itD\rm\bf + \itm\rm\bf)(\itB\rm\bf ' mi ' \itR\rm\bf)']);
        tx(112,6,'Abfluss + Tod',fs-3);
        % Funktionen und Parameter
        text(sa,0,5,'\boldmath$F_C(N)=\frac{b_C\,N}{K_C+N},\qquad F_B(C)=\frac{b_B\,C}{K_B+C}$', ...
            'Interpreter','latex','FontSize',fs+1,'HorizontalAlignment','left');
        tx(0,-1.5,'\itD\rm\bf: Verdünnungsrate,  \epsilon: Umwandlungseffizienz,  \itm\rm\bf: Sterberate', ...
            fs-3,'HorizontalAlignment','left');

        function sbox(x0,y0,w,h,fc,ttl,var,f)
            rectangle(sa,'Position',[x0 y0 w h],'Curvature',[4.4/w 4.4/h], ...
                'FaceColor',fc,'EdgeColor','k','LineWidth',L);
            tx(x0+w/2,y0+h*0.66,ttl,f,'FontWeight','bold');
            tx(x0+w/2,y0+h*0.30,var,f);
        end
        function sink(x,ytop,lab)
            sarrow([x ytop],[x ytop-8]);
            tx(x,ytop-10.2,char(8709),fs+6);
            tx(x+1.3,ytop-4,lab,fs-3,'HorizontalAlignment','left');
        end
        function sarrow(p,q)
            u = (q - p)/norm(q - p); l = 1.8; w = 0.8; n = [-u(2) u(1)];
            plot(sa,[p(1) q(1)-l*u(1)],[p(2) q(2)-l*u(2)],'k-','LineWidth',L);
            patch(sa,[q(1), q(1)-l*u(1)+w*n(1), q(1)-l*u(1)-w*n(1)], ...
                     [q(2), q(2)-l*u(2)+w*n(2), q(2)-l*u(2)-w*n(2)],'k','EdgeColor','k');
        end
        function tx(x,y,s,f,varargin)
            text(sa,x,y,s,'FontName',fn,'FontSize',f,'HorizontalAlignment','center', ...
                'Interpreter','tex',varargin{:},'FontWeight','bold');
        end
        function tl(x,y,s,f,va)
            text(sa,x,y,['\boldmath' s],'Interpreter','latex','FontSize',f, ...
                'HorizontalAlignment','center','VerticalAlignment',va);
        end
    end

    function drawReactor(ra)
        % Skizze des Chemostaten (Bioreaktor)
        xlim(ra,[0 132]); ylim(ra,[0 81]);
        fs = 14; fn = 'Times New Roman';
        rs = RandStream('mt19937ar','Seed',3);           % feste Zufallsanordnung
        water = [0.80 0.90 0.97]; glass = [0.25 0.25 0.25]; edgeW = [0.3 0.5 0.8];
        tint = @(c,f) 1 - (1 - c)*(1 - f);
        % --- Vorratsgefaess
        rbox([4 8 20 26],[1 1 1],glass,2,2);
        rectangle(ra,'Position',[4.3 8.3 19.4 19],'FaceColor',[0.86 0.92 0.98],'EdgeColor','none');
        rbox([4 8 20 26],'none',glass,2,2);
        tx(14,22,'Nährmedium',fs,'FontWeight','bold');
        tx(14,17.5,'Stickstoff',fs-1);
        hNiTxt = tx(14,13.5,sprintf('\\itN_i\\rm\\bf = %.0f µmol/l',P.Ni),fs-1);
        tx(14,4.5,'Vorrat',fs,'FontWeight','bold');
        % --- Leitung Vorrat -> Pumpe -> Reaktor
        pipe([18 18 36],[30 46 46],0.35*[1 1 1],5);
        pipe([44 47 47 56 56],[46 46 69 69 61.5],0.35*[1 1 1],5);
        circ(40,46,4.5,[1 1 1],glass,2);
        a = linspace(deg2rad(165),deg2rad(35),30);
        plot(ra,40+2.0*cos(a),46.9+2.0*sin(a),'k-','LineWidth',1.5);
        e = [40+2.0*cos(a(end)) 46.9+2.0*sin(a(end))]; d = [sin(a(end)) -cos(a(end))];
        head(e,d,0.9,0.5);
        tx(40,44.2,'Pumpe',fs-5);
        tx(31,54.5,'Zufluss \itF\rm\bf (l/Tag)',fs,'FontWeight','bold');
        farrow([26 49],[33 49]);
        % --- Reaktor
        x0 = 50; x1 = 86; yb = 8; yt = 64; lev = 50;
        rectangle(ra,'Position',[x0 yb x1-x0 lev-yb],'FaceColor',water,'EdgeColor','none');
        plot(ra,[x0 x1],[lev lev],'Color',edgeW,'LineWidth',1.2);
        for yy = [59 56 53], ell(56,yy,1.0,1.6,0,water,edgeW,1); end
        % Ruehrer
        plot(ra,[68 68],[yt+0.8 16],'Color',glass,'LineWidth',2.5);
        patch(ra,[62 68 68],[17 15.5 18.5],0.5*[1 1 1],'EdgeColor',glass);
        patch(ra,[74 68 68],[17 15.5 18.5],0.5*[1 1 1],'EdgeColor',glass);
        rbox([64 yt+0.8 8 5],0.55*[1 1 1],glass,2,1);
        tx(68,yt+3.3,'M',fs-2,'FontWeight','bold','Color',[1 1 1]);
        plot(ra,[72.5 79.5],[68.5 74],'Color',0.4*[1 1 1],'LineWidth',0.8);
        tx(80,74,'Rührer',fs-2,'HorizontalAlignment','left');
        % Belueftung
        pipe([30 60 60],[3.5 3.5 9],0.55*[1 1 1],3);
        tx(28,3.5,'Luft',fs-2,'HorizontalAlignment','right');
        farrow([31 6],[38 6]);
        for i = 0:13
            xx = 60 + 1.2*randn(rs); yy = 11 + i*2.8; r = 0.6 + 0.25*rand(rs);
            if yy < lev-1, circ(xx,yy,r,[1 1 1],edgeW,0.8); end
        end
        % Algen
        xa = x0+1 + (x1-x0-2)*rand(rs,260,1); ya = yb+1 + (lev-yb-2)*rand(rs,260,1);
        scatter(ra,xa,ya,28,colC,'filled','MarkerFaceAlpha',0.9);
        % Raedertierchen
        pos = [55 40 20; 78 44 -30; 72 30 60; 57 22 -15; 81 20 10; 66 38 -70; 76 12 35; 53 13 80];
        for i = 1:size(pos,1), rotifer(pos(i,1),pos(i,2),pos(i,3),0.85); end
        % Glaswand und Deckel (ueber dem Inhalt)
        plot(ra,[x0 x0 x1 x1],[yt yb yb yt],'Color',glass,'LineWidth',3);
        plot(ra,[x0-1.5 x1+1.5],[yt yt],'Color',glass,'LineWidth',4);
        tx(68,4.5,'Volumen \itV',fs,'FontWeight','bold');
        % Raedertierchen: Mikroskopaufnahme (Brachionus-Weibchen mit Ei)
        fImg = fullfile(fileparts(mfilename('fullpath')),'raedertierchen_foto.png');
        if isfile(fImg)
            img = imread(fImg);
            [ihR,iwR,~] = size(img); sc = 24/ihR;          % Dateneinheiten pro Pixel
            xi0 = 132 - iwR*sc; yi0 = 50; yi1 = yi0 + ihR*sc;
            image(ra,'XData',[xi0 xi0+iwR*sc],'YData',[yi1 yi0],'CData',img);
            rectangle(ra,'Position',[xi0 yi0 iwR*sc ihR*sc],'EdgeColor',0.5*[1 1 1],'LineWidth',0.8);
            lab = {'Räderorgan',[70 95],72.0; 'Augenfleck',[168 167],67.5; ...
                   'Magen',[200 250],63.0; 'Panzer',[118 330],58.5; 'Fuß',[268 425],53.0};
            for i = 1:size(lab,1)
                px = lab{i,2};
                plot(ra,[xi0+px(1)*sc, xi0-1.7],[yi1-px(2)*sc, lab{i,3}],'Color',0.35*[1 1 1],'LineWidth',0.7);
                tx(xi0-2,lab{i,3},lab{i,1},fs-3,'HorizontalAlignment','right');
            end
            tx(xi0+345*sc,yi1-345*sc,'Ei',fs-3,'FontWeight','bold');
            tx(xi0+iwR*sc/2,78.5,'Rädertierchen (\itBrachionus\rm\bf)',fs-2,'FontWeight','bold');
            tx(xi0+iwR*sc/2,76.3,'Weibchen mit angeheftetem Ei',fs-4,'Color',0.3*[1 1 1]);
        end
        % Ueberlauf -> Ablauf
        pipe([86 96 96],[lev-1 lev-1 30],0.35*[1 1 1],5);
        rbox([88 8 18 20],[1 1 1],glass,2,2);
        rectangle(ra,'Position',[88.3 8.3 17.4 8],'FaceColor',[0.82 0.88 0.75],'EdgeColor','none');
        rbox([88 8 18 20],'none',glass,2,2);
        tx(97,4.5,'Ablauf',fs,'FontWeight','bold');
        farrow([99 46],[99 38]);
        tx(101,44.5,'Abfluss \itF',fs,'FontWeight','bold','HorizontalAlignment','left');
        tx(101,40.5,{'Medium + Algen','+ Rädertierchen'},fs-3, ...
            'HorizontalAlignment','left','VerticalAlignment','top');
        % Verduennungsrate
        rbox([3.4 61.4 35.2 14.2],[1 1 1],0.6*[1 1 1],1,1.5);
        tx(21,71.5,'Verdünnungsrate',fs,'FontWeight','bold');
        text(ra,21,66,'\boldmath$D=\frac{F}{V}\quad(1/\mathrm{Tag})$','Interpreter','latex', ...
            'FontSize',fs+4,'HorizontalAlignment','center');
        % Legende
        circ(112,27,0.7,colC,'none',0.5);
        tx(115,27,'Algen (\itChlorella\rm\bf)',fs-3,'HorizontalAlignment','left');
        rotifer(112,20,0,0.75);
        tx(115,20,{'Rädertierchen','(\itBrachionus\rm\bf)'},fs-3,'HorizontalAlignment','left');

        function rotifer(x,y,ang,s)
            t = deg2rad(ang); Rm = [cos(t) -sin(t); sin(t) cos(t)];
            ell(x,y,2.2*s,4.2*s,ang,colB,[0 0 0],0.8);
            for dx = [-0.7 0.7]
                c = [x y]' + Rm*[dx*s; 2.2*s];
                circ(c(1),c(2),0.65*s,tint(colB,0.55),[0 0 0],0.8);
                for b = deg2rad(linspace(-60,60,5) + 25*sign(dx))
                    u = Rm*[sin(b); cos(b)];
                    plot(ra,c(1)+[0.65 1.25]*s*u(1),c(2)+[0.65 1.25]*s*u(2),'k-','LineWidth',0.6);
                end
            end
            base = [x y]' + Rm*[0; -1.8*s];
            for dx = [-0.35 0.35]
                toe = [x y]' + Rm*[dx*s; -3.3*s];
                plot(ra,[base(1) toe(1)],[base(2) toe(2)],'k-','LineWidth',1.2);
            end
        end
        function ell(x,y,w,h,ang,fc,ec,elw)
            t = linspace(0,2*pi,40); tt = deg2rad(ang);
            px = w/2*cos(t); py = h/2*sin(t);
            patch(ra,x + px*cos(tt) - py*sin(tt), y + px*sin(tt) + py*cos(tt),fc, ...
                'EdgeColor',ec,'LineWidth',elw);
        end
        function circ(x,y,r,fc,ec,elw)
            rectangle(ra,'Position',[x-r y-r 2*r 2*r],'Curvature',[1 1], ...
                'FaceColor',fc,'EdgeColor',ec,'LineWidth',elw);
        end
        function rbox(p,fc,ec,elw,rad)
            rectangle(ra,'Position',p,'Curvature',[2*rad/p(3) 2*rad/p(4)], ...
                'FaceColor',fc,'EdgeColor',ec,'LineWidth',elw);
        end
        function pipe(xs,ys,col,w)
            plot(ra,xs,ys,'Color',col,'LineWidth',w,'LineJoin','round');
        end
        function farrow(p,q)
            u = (q - p)/norm(q - p);
            plot(ra,[p(1) q(1)-1.6*u(1)],[p(2) q(2)-1.6*u(2)],'k-','LineWidth',2.2);
            head(q,u,1.8,0.9);
        end
        function head(q,u,l,w)
            n = [-u(2) u(1)];
            patch(ra,[q(1), q(1)-l*u(1)+w*n(1), q(1)-l*u(1)-w*n(1)], ...
                     [q(2), q(2)-l*u(2)+w*n(2), q(2)-l*u(2)-w*n(2)],'k','EdgeColor','k');
        end
        function h = tx(x,y,s,f,varargin)
            h = text(ra,x,y,s,'FontName',fn,'FontSize',f,'HorizontalAlignment','center', ...
                'Interpreter','tex',varargin{:},'FontWeight','bold');
        end
    end

end
