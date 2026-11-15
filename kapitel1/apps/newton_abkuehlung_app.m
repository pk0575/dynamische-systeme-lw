function newton_abkuehlung_app
% NEWTON_ABKUEHLUNG_APP  Newtonsches Gesetz der Abkuehlung (Kapitel I, Folien 33-37)
%
%   T_{n+1} = T_n + alpha (T^u - T_n),  n >= 0
%   Loesung:  T_n = (T_0 - T^u) (1 - alpha)^n + T^u
%
%   Verhalten (Folie 33 und "Veranschaulichung"):
%     0 < alpha < 1   monotones Abklingen gegen T^u
%     alpha = 1       T^u schon nach einem Schritt
%     1 < alpha < 2   gedaempfte Oszillation um T^u
%     alpha = 2       periodisch, T_{n+2} = T_n
%     alpha > 2       aufschaukelnde Oszillation
%
%   Bedienelemente (Seitenleiste):
%     - Auswahl Beispiel: frei, Folienbeispiele (alpha = 0.1/0.2/0.5,
%       1.9, 2, 2.1) und Umfrage (T_0 = 40, T^u = 20, alpha = 1.5)
%     - Knopf alpha (rastet beim Loslassen auf Vielfache von 0.05 ein)
%     - Knoepfe Anfangstemperatur T_0 und Umgebungstemperatur T^u
%     - Knopf Schritt n (Folge wird bis n gezeichnet, Start n = 0)
%     - Kontrollkaestchen: Vergleich alpha = 0.1, 0.2, 0.5 (wie Folie),
%       Loesungsformel, Zahlenwerte an der T-Achse, Kompartimentschema
%
%   Stil wie alcohol_app, genschalter_app, chemostat_hopf_app.
%   Fuer MATLAB R2025b.

%% Parameter
N     = 20;                    % Anzahl Zeitschritte (wie auf den Folien)
aLim  = [0 2.5];               % Knopf alpha
TLim  = [0 60];                % Knoepfe T_0 und T^u
aCmp  = [0.1 0.2 0.5];         % Vergleich (Folie "Veranschaulichung", Bild 1)
mkCmp = {'o','s','d'};

% Beispiele: Name, alpha, T_0, T^u, Vergleich
P(1) = struct('name','frei wählen',               'alpha',0.5,'T0',40,'Tu',20,'cmp',false);
P(2) = struct('name','Folie: α = 0.1, 0.2, 0.5',  'alpha',0.5,'T0',40,'Tu',20,'cmp',true);
P(3) = struct('name','Folie: α = 1.9',            'alpha',1.9,'T0',40,'Tu',20,'cmp',false);
P(4) = struct('name','Folie: α = 2',              'alpha',2,  'T0',40,'Tu',20,'cmp',false);
P(5) = struct('name','Folie: α = 2.1',            'alpha',2.1,'T0',22,'Tu',20,'cmp',false);
P(6) = struct('name','Umfrage: α = 1.5',          'alpha',1.5,'T0',40,'Tu',20,'cmp',false);

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie die anderen Kapitel-I-Apps)
colF  = [0.000 0.447 0.741];   % Loesungsformel (blau)
colC  = [0 0 0; 0.30 0.30 0.30; 0.55 0.55 0.55];   % Vergleich (Graustufen wie Folie)
colOK = [0.00 0.45 0.20];      % physikalisch sinnvoll (0 < alpha <= 1)
colNO = [0.64 0.08 0.18];      % Ueberschwingen ueber T^u (alpha > 1)

%% Zustand
S.alpha = P(1).alpha; S.T0 = P(1).T0; S.Tu = P(1).Tu; S.n = 0;
S.cmp = false; S.formel = false; S.zahlen = false; S.schema = false;
S.T = []; S.TC = [];
S.busy = false; S.pending = false; S.preset = false;

%% GUI
fig = uifigure('Name','Newtonsches Gesetz der Abkühlung', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 1]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.BackgroundColor = [1 1 1];

% --- Temperatur T_n ueber n
ax1 = mkAxes(al,1,1);
xlabel(ax1,'n'); ylabel(ax1,'T_n');
xlim(ax1,[-0.3 N+0.3]); ax1.XTick = 0:2:N;
hTu = plot(ax1,NaN,NaN,'-','Color',[0 0 0],'LineWidth',1.5);          % Umgebungstemperatur
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);       % aktueller Schritt
hX  = plot(ax1,NaN,NaN,'.','MarkerSize',38,'LineWidth',lw,'LineStyle','--','Color',colX);
hF  = plot(ax1,NaN,NaN,'o','MarkerSize',18,'LineWidth',2,'LineStyle','none','Color',colF);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',16,'MarkerEdgeColor',colX,'LineWidth',2);
hC  = gobjects(1,numel(aCmp));
for j = 1:numel(aCmp)
    hC(j) = plot(ax1,NaN,NaN,['--' mkCmp{j}],'MarkerSize',10,'LineWidth',lw, ...
        'Color',colC(j,:),'MarkerFaceColor',colC(j,:), ...
        'DisplayName',sprintf('\\alpha = %.1f',aCmp(j)));
end
lg1 = legend(ax1,hC);
set(lg1,'Location','northeast','FontSize',fSize-4,'FontName',fName,'Visible','off');
hTxt = text(ax1,0,0,'','HorizontalAlignment','center', ...
    'VerticalAlignment','top','FontName',fName,'FontSize',fSize-2,'FontWeight','bold', ...
    'Interpreter','tex','Color',colF);
hTxt.Units = 'normalized'; hTxt.Position = [0.5 0.97 0];   % Loesungsformel oben in der Mitte

% --- Kompartimentschema (gleiche Zelle, zunaechst verborgen)
gS = uigridlayout(gl,[1 1]); gS.Layout.Row = 1; gS.Layout.Column = 1;
gS.BackgroundColor = [1 1 1];
axS = uiaxes(gS); axS.Color = [1 1 1];
hold(axS,'on'); axis(axS,'off'); axS.DataAspectRatio = [1 1 1];
disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';
gS.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[19 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Beispiel (Titel, Auswahl, Gleichung) | alpha (Knopf, Titel, Verhalten) |
%         T_0 und T^u nebeneinander | n (Knopf, Titel, Wert) | 4 Kaestchen
% Knoepfe ('1x') wachsen mit der Fensterhoehe; Verhaltenstext mit Platz fuer zwei Zeilen
pl.RowHeight = {6, 28, 34, 44, '1.2x', 30, 64, '1x', 6, '1x', 30, 28, 10, 26, 26, 26, 26, 6};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

mkLabel(pl,2,'Beispiel');
dd = uidropdown(pl,'Items',{P.name},'ItemsData',1:numel(P),'Value',1, ...
    'FontName',fName,'FontSize',18,'FontWeight','bold');
dd.Layout.Row = 3;
dd.ValueChangedFcn = @(src,~) onPreset(src.Value);
hEq = uilabel(pl,'Text','\bf {\itT}_{n+1} = {\itT}_n + \alpha ({\itT}^u - {\itT}_n)', ...
    'Interpreter','tex','FontName',fName,'FontSize',22,'HorizontalAlignment','center');
hEq.Layout.Row = 4;

kA = uiknob(pl,'continuous','Limits',aLim,'Value',S.alpha, ...
    'MajorTicks',aLim(1):0.5:aLim(2),'MinorTicks',aLim(1):0.1:aLim(2), ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kA.Layout.Row = 5;
kA.ValueChangingFcn = @(~,evt) onAlpha(evt.Value,false);
kA.ValueChangedFcn  = @(src,~) onAlpha(src.Value,true);
hLA = mkLabel(pl,6,'\alpha = 0.50');
hReg = uilabel(pl,'Text','','FontName',fName,'FontSize',16,'FontWeight','bold', ...
    'HorizontalAlignment','center','WordWrap','on','Interpreter','tex');
hReg.Layout.Row = 7;

% T_0 und T^u nebeneinander
gT = uigridlayout(pl,[2 2]);
gT.Layout.Row = 8;
gT.RowHeight = {'1x', 30}; gT.ColumnWidth = {'1x','1x'};
gT.Padding = [0 0 0 0]; gT.RowSpacing = 2; gT.ColumnSpacing = 4;
gT.BackgroundColor = [1 1 1];
k0 = uiknob(gT,'continuous','Limits',TLim,'Value',S.T0,'MajorTicks',TLim(1):20:TLim(2), ...
    'MinorTicks',TLim(1):5:TLim(2),'FontName',fName,'FontSize',14,'FontWeight','bold');
k0.Layout.Row = 1; k0.Layout.Column = 1;
k0.ValueChangingFcn = @(~,evt) onTemp('T0',evt.Value,false);
k0.ValueChangedFcn  = @(src,~) onTemp('T0',src.Value,true);
kU = uiknob(gT,'continuous','Limits',TLim,'Value',S.Tu,'MajorTicks',TLim(1):20:TLim(2), ...
    'MinorTicks',TLim(1):5:TLim(2),'FontName',fName,'FontSize',14,'FontWeight','bold');
kU.Layout.Row = 1; kU.Layout.Column = 2;
kU.ValueChangingFcn = @(~,evt) onTemp('Tu',evt.Value,false);
kU.ValueChangedFcn  = @(src,~) onTemp('Tu',src.Value,true);
hL0 = uilabel(gT,'Text','','FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hL0.Layout.Row = 2; hL0.Layout.Column = 1;
hLU = uilabel(gT,'Text','','FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hLU.Layout.Row = 2; hLU.Layout.Column = 2;

kN = uiknob(pl,'continuous','Limits',[0 N],'Value',0,'MajorTicks',0:4:N,'MinorTicks',0:N, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kN.Layout.Row = 10;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);       % Rastung: einrasten beim Loslassen
mkLabel(pl,11,'Schritt n');
hVal = uilabel(pl,'Text','','FontName',fName,'FontSize',18,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hVal.Layout.Row = 12;

cbV = mkCheck(14,'Vergleich α = 0.1, 0.2, 0.5',S.cmp);
cbV.ValueChangedFcn = @(src,~) onCmp(src.Value);
cbF = mkCheck(15,'Lösungsformel',S.formel);
cbF.ValueChangedFcn = @(src,~) onFormel(src.Value);
cbZ = mkCheck(16,'Zahlenwerte',S.zahlen);
cbZ.ValueChangedFcn = @(src,~) onZahlen(src.Value);
cbM = mkCheck(17,'Kompartimentschema',S.schema);
cbM.ValueChangedFcn = @(src,~) onSchema(src.Value);

requestUpdate();

%% ---------------- Callbacks ----------------
    function onPreset(i)
        % Beispiel aus den Folien bzw. der Umfrage einstellen
        S.preset = true;
        S.alpha = P(i).alpha; S.T0 = P(i).T0; S.Tu = P(i).Tu;
        kA.Value = S.alpha; k0.Value = S.T0; kU.Value = S.Tu;
        S.n = N; kN.Value = N;                     % ganze Folge zeigen (wie auf der Folie)
        if i == 6, S.n = 2; kN.Value = 2; end      % Umfrage: gefragt ist T_2
        cbV.Value = P(i).cmp;
        S.preset = false;
        onCmp(P(i).cmp);
    end

    function onAlpha(v,final)
        if final
            v = round(v*20)/20;                    % Rastung auf Vielfache von 0.05 (z.B. alpha = 2 genau)
            kA.Value = v;
        end
        S.alpha = v;
        freeMode();
        requestUpdate();
    end

    function onTemp(name,v,final)
        if final
            v = round(v);                          % ganze Grad
            if strcmp(name,'T0'), k0.Value = v; else, kU.Value = v; end
        end
        S.(name) = v;
        freeMode();
        requestUpdate();
    end

    function freeMode()
        % Handeingabe: Auswahl auf "frei waehlen" zuruecksetzen (Vergleich bleibt wie gewaehlt)
        if ~S.preset && dd.Value ~= 1, dd.Value = 1; end
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
        nNew = round(v);                           % zeitdiskret: nur ganze Schritte
        if nNew == S.n, return, end
        S.n = nNew;
        redraw();
    end

    function onSnap(src)
        src.Value = round(src.Value);
        onStep(src.Value);
    end

    function onCmp(v)
        S.cmp = v;
        if v, kA.Enable = 'off'; else, kA.Enable = 'on'; end
        lg1.Visible = v;
        requestUpdate();
    end

    function onFormel(v)
        S.formel = v;
        redraw();
    end

    function onZahlen(v)
        S.zahlen = v;
        requestUpdate();
    end

    function onSchema(v)
        S.schema = v;
        if v, drawSchema(); end
        gS.Visible = v;
        al.Visible = ~v;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function T = iterate(a)
        T = zeros(1,N+1); T(1) = S.T0;
        for k = 1:N
            T(k+1) = T(k) + a*(S.Tu - T(k));       % Newtonsches Gesetz der Abkuehlung
        end
    end

    function update()
        S.T = iterate(S.alpha);
        S.TC = zeros(numel(aCmp),N+1);
        for jj = 1:numel(aCmp), S.TC(jj,:) = iterate(aCmp(jj)); end
        % Achsenbereich aus der ganzen Folge (bleibt beim Drehen am Knopf n fest)
        if S.cmp, v = S.TC(:)'; else, v = S.T; end
        lo = min([v S.Tu S.T0]); hi = max([v S.Tu S.T0]);
        d = max(hi - lo, 1); pad = 0.08*d;
        ylim(ax1,[lo-pad hi+pad]);
        set(hTu,'XData',[-0.3 N+0.3],'YData',[S.Tu S.Tu]);
        % T-Achse: wie auf den Folien nur T_0 und T^u, auf Wunsch mit Zahlenwerten
        if S.zahlen
            ax1.YTickMode = 'auto'; ax1.YTickLabelMode = 'auto';
        elseif abs(S.T0 - S.Tu) < 0.03*d
            ax1.YTick = S.Tu; ax1.YTickLabel = {'T^u'};
        elseif S.T0 > S.Tu
            ax1.YTick = [S.Tu S.T0]; ax1.YTickLabel = {'T^u','T_0'};
        else
            ax1.YTick = [S.T0 S.Tu]; ax1.YTickLabel = {'T_0','T^u'};
        end
        % Beschriftungen der Knoepfe und Verhalten
        hLA.Text = sprintf('\\bf \\alpha = %s',fmt(S.alpha));
        hL0.Text = sprintf('\\bf T_0 = %g',S.T0);
        hLU.Text = sprintf('\\bf T^u = %g',S.Tu);
        [txt,ok] = regime(S.alpha);
        if S.cmp
            hReg.Text = 'Vergleich: monotones Abklingen'; hReg.FontColor = colOK;
        else
            hReg.Text = txt;
            if ok, hReg.FontColor = colOK; else, hReg.FontColor = colNO; end
        end
        redraw();
    end

    function [txt,ok] = regime(a)
        q = 1 - a; e = 1e-9;
        if a < e
            txt = 'keine Änderung (\alpha = 0)'; ok = true;
        elseif abs(a - 1) < e
            txt = 'T^u schon nach einem Schritt'; ok = true;
        elseif a < 1
            txt = sprintf('1 - \\alpha = %s: monotones Abklingen',fmt(q)); ok = true;
        elseif abs(a - 2) < e
            txt = '1 - \alpha = -1: periodisch, T_{n+2} = T_n'; ok = false;
        elseif a < 2
            txt = sprintf('1 - \\alpha = %s: gedämpfte Oszillation',fmt(q)); ok = false;
        else
            txt = sprintf('1 - \\alpha = %s: aufschaukelnde Oszillation',fmt(q)); ok = false;
        end
    end

    function redraw()
        n = min(S.n,N); k = 0:n;
        set(hP1,'XData',[n n],'YData',ax1.YLim);
        if S.cmp
            set([hX hF hM1],'XData',NaN,'YData',NaN);
            for jj = 1:numel(aCmp), set(hC(jj),'XData',k,'YData',S.TC(jj,k+1)); end
            hTxt.String = '';
            hVal.Text = sprintf('\\bf n = %d:  %s / %s / %s',n,fmt(S.TC(1,n+1)),fmt(S.TC(2,n+1)),fmt(S.TC(3,n+1)));
        else
            set(hC,'XData',NaN,'YData',NaN);
            set(hX,'XData',k,'YData',S.T(k+1));
            set(hM1,'XData',n,'YData',S.T(n+1));
            hVal.Text = sprintf('\\bf n = %d:   T_n = %s',n,fmt(S.T(n+1)));
            if S.formel
                TF = (S.T0 - S.Tu)*(1 - S.alpha).^k + S.Tu;   % Loesungsformel
                set(hF,'XData',k,'YData',TF);
                hTxt.String = sprintf(['T_n = (T_0 - T^u) (1 - \\alpha)^n + T^u = ' ...
                    '(%g - %g) (%s)^{%d} + %g = %s'],S.T0,S.Tu,fmt(1 - S.alpha),n,S.Tu,fmt(TF(end)));
            else
                set(hF,'XData',NaN,'YData',NaN);
                hTxt.String = '';
            end
        end
        if S.schema, drawSchema(); end             % Pfeilrichtung haengt von T_n ab
        drawnow limitrate
    end

    function drawSchema()
        % Kompartimentschema: Kasten Temperatur, Umgebung (gestrichelt), Waermefluss im Schritt n
        cla(axS);
        xlim(axS,[0 100]); ylim(axS,[0 60]);
        fs = 26; fn = 'Times New Roman'; L = 2; G = [0.88 0.88 0.88];   % Linienstaerke Kasten = Pfeil-Standard; Schrift >= 22 pt (Hoersaal)
        yc = 30;
        n = min(S.n,N);
        if numel(S.T) == N + 1, Tn = S.T(n+1); else, Tn = S.T0; end
        rectangle(axS,'Position',[40 22 20 16],'Curvature',[0.2 0.3], ...
            'FaceColor',G,'EdgeColor','k','LineWidth',L);
        tx(50,22+16*0.66,'Temperatur',fs-1,'FontWeight','bold'); tx(50,22+16*0.30,'\itT_n',fs);
        rectangle(axS,'Position',[4 22 20 16],'Curvature',[0.2 0.3], ...
            'FaceColor',[1 1 1],'EdgeColor','k','LineWidth',L,'LineStyle','--');
        tx(14,32.5,'Umgebung',fs-1,'FontWeight','bold'); tx(14,27,'\itT^u',fs);
        % Aenderung im Schritt n exakt aus der Loesungsformel: T^u - T_n = -(T_0 - T^u)(1 - alpha)^n
        % (die Iteration erreicht T^u numerisch schon nach ~20 Schritten, obwohl T_n ~= T^u bleibt)
        d = -S.alpha*(S.T0 - S.Tu)*(1 - S.alpha)^n;
        if S.alpha == 0
            tx(32,yc,{'\alpha = 0:','kein Wärmeaustausch'},fs-4);
        elseif d > 0                               % T_n < T^u: Waerme fliesst in den Koerper
            arrow([24 yc],[40 yc]);
            tx(32,yc+4.5,'\alpha (\itT^u\rm\bf - \itT_n\rm\bf)',fs-1,'FontWeight','bold');
            tx(32,yc-5,'Wärmeaufnahme',fs-4);
        elseif d < 0                               % T_n > T^u: Waerme fliesst an die Umgebung
            arrow([40 yc],[24 yc]);
            tx(32,yc+4.5,'\alpha (\itT_n\rm\bf - \itT^u\rm\bf)',fs-1,'FontWeight','bold');
            tx(32,yc-5,'Wärmeabgabe',fs-4);
        else
            tx(32,yc,{'Gleichgewicht:','\itT_n\rm\bf = \itT^u'},fs-4);   % alpha = 1 (n >= 1) oder T_0 = T^u
        end
        tx(50,53,'\itT_{n+1}\rm\bf - \itT_n\rm\bf = \alpha (\itT^u\rm\bf - \itT_n\rm\bf)',fs+2);
        tx(50,9,{'Pfeilrichtung im aktuellen Schritt (Knopf \itn\rm\bf):', ...
            sprintf('\\itn\\rm\\bf = %d:   \\itT_n\\rm\\bf = %s,   \\alpha (\\itT^u\\rm\\bf - \\itT_n\\rm\\bf) = %s',n,fmt(Tn),fmtd(d))},fs-4);

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

    function s = fmt(x)
        % Zahl mit hoechstens zwei Nachkommastellen, ohne ueberfluessige Nullen (20.00 -> 20, 0.50 -> 0.5)
        s = sprintf('%.2f',x);
        s = regexprep(s,'0+$',''); s = regexprep(s,'\.$','');
        if strcmp(s,'-0'), s = '0'; end
    end

    function s = fmtd(x)
        % wie fmt, aber sehr kleine Werte ~= 0 als a.b 10^{k} (sonst stuende "0" neben einem Pfeil)
        if x ~= 0 && abs(x) < 0.005
            k = floor(log10(abs(x))); m = x/10^k;
            s = sprintf('%.1f \\cdot 10^{%d}',m,k);
        else
            s = fmt(x);
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
