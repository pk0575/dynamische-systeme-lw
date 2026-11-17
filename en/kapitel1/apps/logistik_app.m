function logistik_app
% LOGISTIK_APP  Logistisches Wachstumsmodell (zeitdiskret), Kapitel I
%
%   Zwei Formen (Auswahl in der Seitenleiste):
%     1) y_{n+1} = a y_n (1 - y_n),            0 <= a <= 4, 0 <= y_0 <= 1
%        stationaer: y_alpha* = 0 (stabil fuer a < 1),
%                    y_beta*  = 1 - 1/a (stabil fuer 1 < a < 3, f'(y_beta*) = 2 - a)
%     2) x_{n+1} = x_n + r (1 - x_n/K) x_n     (vor der Variablentransformation)
%        stationaer: x* = 0 (instabil fuer r > 0, f'(0) = 1 + r),
%                    x* = K (stabil fuer 0 < r < 2, f'(K) = 1 - r)
%   Zusammenhang: a = 1 + r, y_n = r x_n / ((1 + r) K).
%
%   Bedienelemente (Seitenleiste):
%     - Auswahl der Form
%     - Knopf a bzw. r, Knopf K (nur Form 2), Knopf Startwert, Knopf Schritt n
%     - Kontrollkaestchen: stationaere Zustaende, Stoerung ab n = 5 (Start im
%       nichttrivialen stationaeren Zustand, kleine zufaellige Stoerungen),
%       Treppendiagramm (f, Identitaet, Iteration), Bifurkationsdiagramm,
%       Kompartimentschema
%
%   Ersetzt die App-Designer-Apps app_logistic_a, app_logistic_a_perturbation,
%   app_logistic_rK, app_updatefunction_logistica und den quadratischen Teil von
%   app_updatefunction (Stil wie alcohol_app, genschalter_app, chemostat_hopf_app).
%
%   Fuer MATLAB R2025b.

%% Parameter
N     = 50;                    % Anzahl Schritte
rs    = RandStream('mt19937ar','Seed',5);
pertd = 0.005*randn(rs,1,N);   % feste kleine Stoerungen (reproduzierbar, relativ zur Skala)
% Form 1 (a) und Form 2 (r, K): Grenzen, Achsen, Beschriftungen
F(1) = struct('pLim',[0 4],'pTick',0:0.5:4,'pLab','Wachstumsparameter a', ...
    'sLim',[0 1],'sTick',0:0.25:1,'sLab','Startwert y_0','yl',[-0.05 1.05],'cl',[0 1], ...
    'v','y','eq','\bf {\ity}_{n+1} = {\ita} {\ity}_n (1 - {\ity}_n)','bx','a','by','y_n (Langzeitverhalten)','bl',[0 1]);
F(2) = struct('pLim',[0 3],'pTick',0:0.5:3,'pLab','Wachstumsrate r', ...
    'sLim',[0 10],'sTick',0:2:10,'sLab','Startwert x_0','yl',[-0.2 11],'cl',[0 11], ...
    'v','x','eq','\bf {\itx}_{n+1} = {\itx}_n + {\itr} (1 - {\itx}_n/{\itK}) {\itx}_n','bx','r','by','x_n/K (Langzeitverhalten)','bl',[0 1.4]);
KLim  = [0.5 8];

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie bisherige Kapitel-I-Apps)
colF  = [0.000 0.447 0.741];   % Aktualisierungsfunktion (blau)

%% Zustand
S.f = 1;
S.p = [2.5 1];                 % a (Form 1) bzw. r (Form 2)
S.s = [0.05 0.1];              % Startwert y_0 bzw. x_0
S.K = 5; S.n = 0;
S.stat = false; S.pert = false; S.cob = false; S.bif = false; S.schema = false;
S.y = [];
S.busy = false; S.pending = false;

%% GUI
fig = uifigure('Name','Logistisches Wachstumsmodell (zeitdiskret)', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[2 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x','1x'};
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- Folge ueber n
ax1 = mkAxes(al,[1 2],1);
xlabel(ax1,'n');
xlim(ax1,[-0.5 N+0.5]);
hS1 = plot(ax1,NaN,NaN,'--','Color',[0 0 0],'LineWidth',1.5);      % stationaere Zustaende
hX  = plot(ax1,NaN,NaN,'.','MarkerSize',30,'LineWidth',lw-0.5,'LineStyle','--','Color',colX);
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',14,'MarkerEdgeColor',colX,'LineWidth',2);

% --- Treppendiagramm
ax2 = mkAxes(al,1,2);
ax2.DataAspectRatio = [1 1 1];
hI  = plot(ax2,NaN,NaN,'-','Color',[0 0 0],'LineWidth',1.5);       % Identitaet
hF  = plot(ax2,NaN,NaN,'-','Color',colF,'LineWidth',lw+1);
hC  = plot(ax2,NaN,NaN,'-','Color',colX,'LineWidth',1.5);
hEs = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName','stabil');
hEu = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'LineWidth',2,'DisplayName','instabil');
lg2 = legend(ax2,[hEs hEu]);
set(lg2,'Location','northwest','FontSize',fSize-8,'FontName',fName);

% --- Bifurkationsdiagramm (fuer beide Formen einmalig berechnet)
ax3 = mkAxes(al,2,2);
hB  = plot(ax3,NaN,NaN,'.','Color',[0 0.39 0],'MarkerSize',2);   % dunkelgruen wie die Folien (02.11.2026)
hBa = plot(ax3,NaN,NaN,'-','Color',colX,'LineWidth',lw);
BIF = computeBif();

% --- Kompartimentschema (ueber die ganze Flaeche)
axS = uiaxes(al);
axS.Layout.Row = [1 2]; axS.Layout.Column = [1 2];
axS.Color = [1 1 1];
hold(axS,'on'); axis(axS,'off'); axS.DataAspectRatio = [1 1 1];
disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[24 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Form (Titel, Auswahl, Gleichung) | 4 x (Knopf, Titel, Abstand) | 5 Kaestchen
rowH = {'1x', 28, 34, 44, 105, 32, 6, 105, 32, 6, 105, 32, 6, 105, 32, 14, 26, 26, 26, 26, 26, '1x', 0, 0};
pl.RowHeight = rowH;
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

mkLabel(pl,2,'Form');
dd = uidropdown(pl,'Items',{'a·yₙ(1 − yₙ)','xₙ + r(1 − xₙ/K)xₙ'},'ItemsData',[1 2], ...
    'Value',S.f,'FontName',fName,'FontSize',18,'FontWeight','bold');
dd.Layout.Row = 3;
dd.ValueChangedFcn = @(src,~) onForm(src.Value);
hEq = uilabel(pl,'Text','','Interpreter','tex','FontName',fName,'FontSize',22,'HorizontalAlignment','center');
hEq.Layout.Row = 4;

kP = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
kP.Layout.Row = 5;
kP.ValueChangingFcn = @(~,evt) onPar('p',evt.Value);
kP.ValueChangedFcn  = @(src,~) onPar('p',src.Value);
hLP = mkLabel(pl,6,'');

kK = uiknob(pl,'continuous','Limits',KLim,'Value',S.K,'MajorTicks',[0.5 2 4 6 8], ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kK.Layout.Row = 8;
kK.ValueChangingFcn = @(~,evt) onPar('K',evt.Value);
kK.ValueChangedFcn  = @(src,~) onPar('K',src.Value);
hLK = mkLabel(pl,9,'Tragfähigkeit K');

kS = uiknob(pl,'continuous','FontName',fName,'FontSize',16,'FontWeight','bold');
kS.Layout.Row = 11;
kS.ValueChangingFcn = @(~,evt) onPar('s',evt.Value);
kS.ValueChangedFcn  = @(src,~) onPar('s',src.Value);
hLS = mkLabel(pl,12,'');

kN = uiknob(pl,'continuous','Limits',[0 N],'Value',S.n, ...
    'MajorTicks',0:10:N,'MinorTicks',0:N,'FontName',fName,'FontSize',16,'FontWeight','bold');
kN.Layout.Row = 14;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);       % Rastung: einrasten beim Loslassen
mkLabel(pl,15,'Schritt n');

cb1 = mkCheck(17,'stationäre Zustände',S.stat);
cb1.ValueChangedFcn = @(src,~) onStat(src.Value);
cb2 = mkCheck(18,'Störung ab n = 5',S.pert);
cb2.ValueChangedFcn = @(src,~) onPert(src.Value);
cb3 = mkCheck(19,'Treppe',S.cob);
cb3.ValueChangedFcn = @(src,~) onView('cob',src.Value);
cb4 = mkCheck(20,'Bifurkationsdiagramm',S.bif);
cb4.ValueChangedFcn = @(src,~) onView('bif',src.Value);
cb5 = mkCheck(21,'Kompartimentschema',S.schema);
cb5.ValueChangedFcn = @(src,~) onView('schema',src.Value);

onForm(S.f);
layoutRight();

%% ---------------- Callbacks ----------------
    function onForm(f)
        % Form wechseln: Knoepfe, Achsen, Bifurkationsdiagramm und Schema anpassen
        S.f = f; Fo = F(f);
        setKnob(kP,Fo.pLim,Fo.pTick,S.p(f));
        setKnob(kS,Fo.sLim,Fo.sTick,S.s(f));
        hLP.Text = ['\bf ' Fo.pLab]; hLS.Text = ['\bf ' Fo.sLab];
        hEq.Text = Fo.eq;
        % Knopf K nur in Form 2 (Zeilen sonst auf Hoehe 0)
        rh = rowH;
        if f == 1, rh{8} = 0; rh{9} = 0; rh{10} = 0; end
        pl.RowHeight = rh;
        kK.Visible = (f == 2); hLK.Visible = (f == 2);
        ylim(ax1,Fo.yl); ylabel(ax1,[Fo.v '_n']);
        xlim(ax2,Fo.cl); ylim(ax2,Fo.cl);
        xlabel(ax2,Fo.v); ylabel(ax2,['f(' Fo.v ')']);
        set(hI,'XData',Fo.cl,'YData',Fo.cl);
        xlim(ax3,Fo.pLim); ylim(ax3,Fo.bl);
        xlabel(ax3,Fo.bx); ylabel(ax3,Fo.by);
        set(hB,'XData',BIF{f}(:,1),'YData',BIF{f}(:,2));
        kS.Enable = ~S.pert;
        drawSchema();
        requestUpdate();
    end

    function setKnob(k,lim,tick,v)
        % Grenzen so umstellen, dass der Wert nie ausserhalb liegt
        k.Limits = [min(k.Limits(1),lim(1)) max(k.Limits(2),lim(2))];
        k.Value = v; k.Limits = lim; k.MajorTicks = tick;
    end

    function onPar(name,v)
        switch name
            case 'p', S.p(S.f) = v;
            case 's', S.s(S.f) = v;
            otherwise, S.(name) = v;
        end
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

    function onPert(v)
        % Start im stationaeren Zustand, Startwert-Knopf dann ohne Wirkung
        S.pert = v;
        kS.Enable = ~v;
        requestUpdate();
    end

    function onView(name,v)
        S.(name) = v;
        layoutRight();
    end

    function layoutRight()
        if S.schema
            % nur das Kompartimentschema zeigen (ueber die ganze Flaeche)
            al.ColumnWidth = {'1x','1x'};
            setVis(findall(ax1)', false);
            setVis([findall(ax2)' lg2], false);
            setVis(findall(ax3)', false);
            setVis(findall(axS)', true);
            cb3.Enable = 'off'; cb4.Enable = 'off';
            return
        end
        setVis(findall(axS)', false);
        setVis(findall(ax1)', true);
        cb3.Enable = 'on'; cb4.Enable = 'on';
        % rechte Spalte: Treppendiagramm und/oder Bifurkationsdiagramm
        axs = {ax2, ax3};
        on  = [S.cob, S.bif];
        n = nnz(on);
        if n > 0
            al.ColumnWidth = {'1x','1x'};
        else
            al.ColumnWidth = {'1x', 0};
        end
        r = 1; h = 2/max(n,1);
        for j = find(on)
            axs{j}.Layout.Row = [r r+h-1];
            r = r + h;
        end
        setVis([findall(ax2)' lg2], S.cob);
        setVis(findall(ax3)', S.bif);
    end

    function setVis(h,v)
        st = 'off'; if v, st = 'on'; end
        set(h,'Visible',st);
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function v = fUpd(u)
        % Aktualisierungsfunktion der gewaehlten Form
        if S.f == 1
            v = S.p(1)*u.*(1 - u);
        else
            v = u + S.p(2)*(1 - u/S.K).*u;
        end
    end

    function [ys,st] = steady()
        % stationaere Zustaende und ihre Stabilitaet |f'(y*)| < 1
        if S.f == 1
            a = S.p(1);
            ys = 0; st = a < 1;                    % f'(0) = a
            if a > 1
                ys(2) = 1 - 1/a; st(2) = abs(2 - a) < 1;   % f'(y_beta*) = 2 - a
            end
        else
            r = S.p(2);
            ys = [0 S.K];                          % f'(0) = 1 + r, f'(K) = 1 - r
            st = [abs(1 + r) < 1, abs(1 - r) < 1];
        end
    end

    function update()
        y = zeros(1,N+1);
        sc = 1; if S.f == 2, sc = S.K; end         % Skala der Stoerung
        if S.pert
            ys = steady(); y(1) = ys(end);         % Start im nichttrivialen stationaeren Zustand
        else
            y(1) = S.s(S.f);
        end
        for k = 1:N
            y(k+1) = fUpd(y(k));
            if S.pert && k >= 5
                y(k+1) = y(k+1) + sc*pertd(k);     % kleine Stoerung
            end
        end
        S.y = y;
        % Treppendiagramm: Aktualisierungsfunktion und stationaere Zustaende
        cl = F(S.f).cl;
        ug = linspace(cl(1),cl(2),400);
        set(hF,'XData',ug,'YData',fUpd(ug));
        [ys,st] = steady();
        set(hEs,'XData',ys(st),'YData',ys(st));
        set(hEu,'XData',ys(~st),'YData',ys(~st));
        p = S.p(S.f);
        set(hBa,'XData',[p p],'YData',F(S.f).bl);
        redraw();
    end

    function B = computeBif()
        % fuer jeden Parameter: 500 Schritte einschwingen, dann 150 Werte aufzeichnen
        % Form 1: y_{n+1} = a y (1-y);  Form 2 in u = x/K: u_{n+1} = u + r (1-u) u (unabhaengig von K)
        B = cell(1,2);
        for f = 1:2
            pg = (F(f).pLim(1):0.005:F(f).pLim(2))';
            u = 0.05*ones(size(pg));
            Y = zeros(numel(pg),150);
            for k = 1:650
                if f == 1, u = pg.*u.*(1 - u); else, u = u + pg.*(1 - u).*u; end
                if k > 500, Y(:,k-500) = u; end
            end
            P = repmat(pg,1,150);
            B{f} = [P(:) Y(:)];
        end
    end

    function redraw()
        n = S.n; k = 0:n; y = S.y;
        set(hX,'XData',k,'YData',y(k+1));
        set(hM1,'XData',n,'YData',y(n+1));
        set(hP1,'XData',[n n],'YData',ax1.YLim);
        if S.stat
            ys = steady();
            xs = repmat([0 N NaN],1,numel(ys));
            yy = reshape([ys; ys; nan(size(ys))],1,[]);
            set(hS1,'XData',xs,'YData',yy);
        else
            set(hS1,'XData',NaN,'YData',NaN);
        end
        % Treppe: (y_0,0) -> (y_0,y_1) -> (y_1,y_1) -> (y_1,y_2) -> ...
        cx = y(1); cy = 0;
        for j = 1:n
            cx = [cx, y(j), y(j+1)];               %#ok<AGROW>
            cy = [cy, y(j+1), y(j+1)];             %#ok<AGROW>
        end
        set(hC,'XData',cx,'YData',cy);
        drawnow limitrate
    end

    function drawSchema()
        % Kompartimentschema: ein Kasten fuer die Population, jeder Pfeil ein Term
        % der Aenderung pro Schritt (Folie "Veraenderliche Wachstumsrate"):
        %   x_{n+1} - x_n = R(x_n) x_n = r x_n - (r/K) x_n^2
        %   y_{n+1} - y_n = (a - 1) y_n - a y_n^2
        cla(axS);
        xlim(axS,[0 100]); ylim(axS,[0 60]);
        fs = 26; fn = 'Times New Roman'; L = 2; G = [0.88 0.88 0.88];   % Linienstaerke Kasten = Pfeil-Standard; Schrift gross genug fuer den Hoersaal (min. 22 pt)
        yc = 30;
        v = F(S.f).v;
        sbox(40,22,20,16,'Population',['\it' v '_n']);
        sink(8,yc); arrow([12 yc],[40 yc]);
        arrow([60 yc],[88 yc]); sink(92,yc);
        if S.f == 1
            tx(25,yc+4.5,'(\ita\rm\bf - 1) \ity_n',fs+1,'FontWeight','bold'); tx(25,yc-5,'Vermehrung',fs-4);
            tx(75,yc+4.5,'\ita\rm\bf \ity_n^2',fs+1,'FontWeight','bold'); tx(75,yc-5,'Konkurrenz',fs-4);
            tx(50,53,'\ity_{n+1}\rm\bf - \ity_n\rm\bf = (\ita\rm\bf - 1) \ity_n\rm\bf - \ita\rm\bf \ity_n^2',fs+2);
            tx(50,9,{'\ity_n\rm\bf: Populationsgröße als Anteil der maximal möglichen Größe', ...
                '(\ita\rm\bf < 1: auch der Vermehrungsterm ist negativ, die Population nimmt ab)'},fs-4);
        else
            tx(25,yc+4.5,'\itr\rm\bf \itx_n',fs+1,'FontWeight','bold'); tx(25,yc-5,'Vermehrung',fs-4);
            tx(75,yc+4.5,'(\itr\rm\bf/\itK\rm\bf) \itx_n^2',fs+1,'FontWeight','bold'); tx(75,yc-5,'Konkurrenz',fs-4);
            tx(50,53,'\itx_{n+1}\rm\bf - \itx_n\rm\bf = \itr\rm\bf (1 - \itx_n\rm\bf/\itK\rm\bf) \itx_n\rm\bf = \itr\rm\bf \itx_n\rm\bf - (\itr\rm\bf/\itK\rm\bf) \itx_n^2',fs+2);
            tx(50,9,{'\itR\rm\bf(\itx\rm\bf) = \itr\rm\bf (1 - \itx\rm\bf/\itK\rm\bf): (pro Kopf) Wachstumsrate, nimmt mit der Population ab', ...
                '\itr\rm\bf: Wachstumsrate bei kleiner Population,  \itK\rm\bf: Tragfähigkeit'},fs-4);
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
