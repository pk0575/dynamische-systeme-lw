function malaria_app
% MALARIA_APP  Wachstumsmodell fuer Malaria-Parasiten (erste App der Vorlesung)
%
%   x_n = 8^n,  d.h.  x_{n+1} = 8 x_n,  x_0 = 1,  n = Tage
%   Folie "Malaria-Parasiten": zu Beginn (Tag 0) ist eine Blutzelle von
%   einem Parasiten befallen, x_n = Anzahl der Parasiten nach n Tagen.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Tag n (Folge wird bis n gezeichnet, Start n = 0)
%     - Anzeige von x_n
%     - Kontrollkaestchen: strichliert, Zahlenwerte (x_n an den Markern), Modell (Skizze des Vermehrungszyklus)
%   Die Achsen passen sich an: bis n = 4 genau wie auf Folie malaria_dashed.png
%   (Tage 0-4, y von -200 bis 4700), ab n = 5 wachsen sie mit.
%   Die Skizze zeigt einen Vermehrungszyklus: 1 Parasit in einer Blutzelle
%   -> 8 Tochterparasiten -> die Zelle platzt, 8 Parasiten werden frei.
%
%   Startzustand strichliert; n = 4 -> Folie "Graphische Darstellung" (malaria_dashed.png).
%   Stil wie alcohol_app, genschalter_app, chemostat_hopf_app.
%
%   Fuer MATLAB R2025b.

%% Parameter
N     = 10;                    % Tage (x_10 = 8^10 ~ 1,07 Mrd.)
a     = 8;                     % Nachkommen pro Parasit und Tag (Teil des Modells)
n4    = 4;                     % bis hierher Achsen wie auf Folie malaria_dashed.png

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie die anderen Kapitel-I-Apps)

%% Zustand
S.n = 0;                       % Zeitknopf startet bei 0
S.dash = true;  S.sketch = false;  S.num = false;
S.x = a.^(0:N);                % x_n = 8^n, x_0 = 1

%% GUI
fig = uifigure('Name','Wachstum von Malaria-Parasiten', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 1]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.BackgroundColor = [1 1 1];

% --- Anzahl Parasiten ueber die Tage
ax1 = uiaxes(al);
ax1.FontSize = fSize; ax1.FontWeight = 'bold'; ax1.FontName = fName;
ax1.Color = [1 1 1]; ax1.Box = 'on'; hold(ax1,'on');
ax1.YAxis.Exponent = 0;        % ganze Zahlen, kein x10^k
ax1.YAxis.TickLabelFormat = '%d';
xlabel(ax1,'n (Tage)'); ylabel(ax1,'Anzahl Parasiten x_n');
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);   % aktueller Tag
hX  = plot(ax1,NaN,NaN,'.','MarkerSize',38,'LineWidth',lw,'LineStyle','none','Color',colX);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',16,'MarkerEdgeColor',colX,'LineWidth',2);

% --- Skizze (gleiche Zelle, zunaechst verborgen)
gS = uigridlayout(gl,[1 1]); gS.Layout.Row = 1; gS.Layout.Column = 1;
gS.BackgroundColor = [1 1 1];
axS = uiaxes(gS);
axS.Color = [1 1 1]; hold(axS,'on'); axis(axS,'off');
axS.DataAspectRatio = [1 1 1];
disableDefaultInteractivity(axS); axS.Toolbar.Visible = 'off';
drawSketch();
gS.Visible = 'off';

% --- Seitenleiste
pl = uigridlayout(gl,[10 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Rand | Knopf | Titel | Abstand | Wert x_n | Abstand | strichliert | Zahlenwerte | Skizze | Rand
pl.RowHeight = {'1x', 220, 35, 40, 50, 40, 34, 34, 34, '1x'};   % oben/unten gleich ('1x'), Knopf groesser
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kN = uiknob(pl,'continuous','Limits',[0 N],'Value',S.n, ...
    'MajorTicks',0:N,'MinorTicks',[],'FontName',fName,'FontSize',20,'FontWeight','bold');   % groessere Beschriftung (erste App)
kN.Layout.Row = 2;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);       % Rastung: einrasten beim Loslassen
mkLabel(3,'n (Tage)');

hVal = uilabel(pl,'Text','','FontName',fName,'FontSize',22,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hVal.Layout.Row = 5;

cbD = mkCheck(7,'strichliert',S.dash);
cbD.ValueChangedFcn = @(src,~) onDash(src.Value);
cbZ = mkCheck(8,'Zahlenwerte',S.num);
cbZ.ValueChangedFcn = @(src,~) onNum(src.Value);
cbS = mkCheck(9,'Modell',S.sketch);
cbS.ValueChangedFcn = @(src,~) onSketch(src.Value);

redraw();

%% ---------------- Callbacks ----------------
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

    function onDash(v)
        S.dash = v;
        redraw();
    end

    function onNum(v)
        S.num = v;
        redraw();
    end

    function onSketch(v)
        % Skizze statt des Diagramms zeigen
        S.sketch = v;
        gS.Visible = v;
        al.Visible = ~v;
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        n = S.n; k = 0:n; x = S.x;
        set(hX,'XData',k,'YData',x(k+1));
        if S.dash, hX.LineStyle = '--'; else, hX.LineStyle = 'none'; end
        set(hM1,'XData',n,'YData',x(n+1));
        % Achsen: bis n = 4 wie Folie malaria_dashed.png, danach mitwachsend
        nAx = max(n,n4);
        xlim(ax1,[-0.5 nAx+0.5]); ax1.XTick = 0:nAx;
        if nAx == n4
            ylim(ax1,[-200 4700]); ax1.YTick = 0:1000:4000;
        else
            top = x(nAx+1);
            ylim(ax1,[-0.06*top, 1.06*top]); ax1.YTickMode = 'auto';
        end
        set(hP1,'XData',[n n],'YData',ax1.YLim);         % senkrechter Strich am aktuellen Tag
        hVal.Text = sprintf('\\bf x_{%d} = %.0f',n,x(n+1));   % ohne Tausenderpunkte (wie Folie)
        % Zahlenwerte an den Markern (Groesse und Farbe wie Folie 12)
        delete(findobj(ax1,'Tag','Zahlenwert'));
        if S.num, placeNumbers(ax1,k,x(k+1),colX,fSize); end
        drawnow limitrate
    end

    function drawSketch()
        % Vermehrungszyklus in der roten Blutzelle (schematisch)
        cla(axS);
        xlim(axS,[0 120]); ylim(axS,[0 62]);
        fn = 'Times New Roman'; fs = 24;
        cCell = [0.97 0.74 0.74]; eCell = [0.70 0.15 0.15];
        cIn   = [0.99 0.86 0.86];
        cPar  = [0.42 0.12 0.55];                  % Parasit (violett)
        R = 12; r = 1.8; yc = 34;

        % 1) eine Blutzelle mit einem Parasiten
        bcell(18,yc);
        circ(18,yc,r,cPar,cPar,'-');

        arrow([33 yc],[44 yc]);

        % 2) der Parasit vermehrt sich in der Zelle: 8 Tochterparasiten
        bcell(60,yc);
        th = (0:a-1)*2*pi/a;
        for j = 1:a
            circ(60+6.2*cos(th(j)), yc+6.2*sin(th(j)), r, cPar, cPar, '-');
        end

        arrow([75 yc],[86 yc]);

        % 3) die Zelle platzt, 8 Parasiten werden frei
        circ(102,yc,R,'none',eCell,'--');
        for j = 1:a
            c = [102 yc] + 9.5*[cos(th(j)+0.2) sin(th(j)+0.2)];
            circ(c(1),c(2),r,cPar,cPar,'-');
            q = [102 yc] + 15.5*[cos(th(j)+0.2) sin(th(j)+0.2)];
            arrowThin(c + 2.3*[cos(th(j)+0.2) sin(th(j)+0.2)], q);
        end

        % Beschriftung (wie Folie "Malaria-Modell", ohne Tag n / Tag n+1)
        tx(18,9,{'ein Parasit','in einer Blutzelle'},fs);
        tx(60,9,{'teilt sich in','8 Tochterparasiten'},fs);
        tx(102,9,{'Zelle platzt,','8 Parasiten werden frei'},fs);
        tx(60,57,'aus einem Parasiten werden in einem Tag 8 Parasiten:   \itx_{n+1}\rm\bf = 8 \itx_n',fs+2);

        function bcell(cx,cy)
            circ(cx,cy,R,cCell,eCell,'-');
            circ(cx,cy,0.45*R,cIn,'none','-');     % Delle der Blutzelle
        end
        function circ(cx,cy,rr,fc,ec,ls)
            rectangle(axS,'Position',[cx-rr cy-rr 2*rr 2*rr],'Curvature',[1 1], ...
                'FaceColor',fc,'EdgeColor',ec,'LineStyle',ls,'LineWidth',2);
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
        function arrowThin(p,q)
            u = (q - p)/norm(q - p); l = 1.4; w = 0.7; nv = [-u(2) u(1)];
            plot(axS,[p(1) q(1)-l*u(1)],[p(2) q(2)-l*u(2)],'-','Color',cPar,'LineWidth',1.5);
            patch(axS,[q(1), q(1)-l*u(1)+w*nv(1), q(1)-l*u(1)-w*nv(1)], ...
                      [q(2), q(2)-l*u(2)+w*nv(2), q(2)-l*u(2)-w*nv(2)],cPar,'EdgeColor',cPar);
        end
        function tx(x,y,s,f)
            text(axS,x,y,s,'FontName',fn,'FontSize',f,'FontWeight','bold','HorizontalAlignment','center', ...
                'Interpreter','tex');
        end
    end

    function placeNumbers(ax,k,y,col,fs)
        % Zahlenwerte an den Markern wie auf Folie 12 (Kapitel I): Groesse wie die Achsenbeschriftung, rot;
        % ueber dem Marker, bei steilem Anstieg links oberhalb (wie Folie), ganz oben links daneben
        pn_yl = ax.YLim; pn_r = diff(pn_yl); pn_dy = 0.03*pn_r;
        pn_h = gobjects(1,numel(k));
        for pn_j = 1:numel(k)
            if pn_j < numel(k), pn_s = y(pn_j+1) - y(pn_j); elseif pn_j > 1, pn_s = y(pn_j) - y(pn_j-1); else, pn_s = 0; end
            pn_t = sprintf('%.0f',y(pn_j));
            if y(pn_j) + pn_dy + 0.07*pn_r > pn_yl(2)          % oberster Punkt: links daneben
                pn_h(pn_j) = text(ax,k(pn_j)-0.2,y(pn_j),pn_t,'HorizontalAlignment','right','VerticalAlignment','middle');
            elseif pn_s > 0.08*pn_r                             % steiler Anstieg: links oberhalb
                pn_h(pn_j) = text(ax,k(pn_j)+0.1,y(pn_j)+pn_dy,pn_t,'HorizontalAlignment','right','VerticalAlignment','bottom');
            else                                                % sonst mittig darueber
                pn_h(pn_j) = text(ax,k(pn_j),y(pn_j)+pn_dy,pn_t,'HorizontalAlignment','center','VerticalAlignment','bottom');
            end
        end
        set(pn_h,'FontName',fName,'FontSize',fs,'FontWeight','bold','Color',col,'Interpreter','none','Tag','Zahlenwert');
    end

    function h = mkLabel(row,txt)
        h = uilabel(pl,'Text',['\bf ' txt],'FontName',fName,'FontSize',20, ...
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
            'FontName',fName,'FontSize',20,'FontWeight','bold');
        cbx.Layout.Column = 2;
    end
end
