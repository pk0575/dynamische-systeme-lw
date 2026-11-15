%% 
function fisch_app
% FISCH_APP  Wachstum eines Fisches - explizit gegebene Folge (Kapitel I, Folien 4/5)
%
%   x_n = 60 n / (n + 2)  (Laenge in cm, auf 1 Nachkommastelle gerundet),  n = Jahre,  n >= 0
%   Folie 4 "Folgen": Beispiel einer explizit (durch eine Formel) definierten Folge,
%   Folie 5 "Graphische Darstellung" (fisch_dashed.png, n = 0..10).
%
%   Bedienelemente (Seitenleiste):
%     - Knopf n (Jahre), Start n = 0, rastet auf ganze Jahre
%     - Anzeige von x_n (gerundet) und der Formel
%     - Kontrollkaestchen: strichliert, Zahlenwerte (x_n an den Markern),
%       Grenze 60 cm (gestrichelte Linie: der Fisch kommt 60 cm immer naeher, erreicht sie aber nie)
%   Die Achsen passen sich an: bis n = 10 genau wie auf Folie fisch_dashed.png, ab n = 11 wachsen sie mit.
%
%   Gegenstueck zu malaria_app (unbegrenztes Wachstum, rekursiv definiert).
%   Stil wie malaria_app / alcohol_app, genschalter_app, chemostat_hopf_app.
%
%   Fuer MATLAB R2025b.

%% Parameter
N     = 30;                    % maximales Alter (Jahre) am Knopf
L     = 60;                    % Grenzlaenge (cm)
n10   = 10;                    % bis hierher Achsen wie auf Folie fisch_dashed.png

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie die anderen Kapitel-I-Apps)

%% Zustand
S.n = 0;                       % Zeitknopf startet bei 0
S.dash = true;  S.num = false;  S.lim = false;
k = 0:N;
S.x = round(L*k./(k + 2),1);   % x_n = 60 n/(n+2), auf 1 Nachkommastelle gerundet (wie Folie)

%% GUI
fig = uifigure('Name','Wachstum eines Fisches', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 1]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.BackgroundColor = [1 1 1];

% --- Laenge ueber die Jahre
ax1 = uiaxes(al);
ax1.FontSize = fSize; ax1.FontWeight = 'bold'; ax1.FontName = fName;
ax1.Color = [1 1 1]; ax1.Box = 'on'; hold(ax1,'on');
xlabel(ax1,'n (Jahre)'); ylabel(ax1,['Fischl' char(228) 'nge x_n (cm)']);   % char(228) = ae-Umlaut
hL  = plot(ax1,NaN,NaN,'--','Color',[0 0 0],'LineWidth',1.5);          % Grenze 60 cm
hTL = text(ax1,NaN,NaN,'60 cm','FontName',fName,'FontSize',fSize-2,'FontWeight','bold', ...
    'HorizontalAlignment','right','VerticalAlignment','bottom');
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);         % aktuelles Jahr
hX  = plot(ax1,NaN,NaN,'.','MarkerSize',38,'LineWidth',lw,'LineStyle','none','Color',colX);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',16,'MarkerEdgeColor',colX,'LineWidth',2);

% --- Seitenleiste
pl = uigridlayout(gl,[11 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Rand | Knopf | Titel | Abstand | Wert x_n | Formel | Abstand | strichliert | Zahlenwerte | Grenze | Rand
pl.RowHeight = {'1x', 220, 35, 30, 50, 80, 30, 34, 34, 34, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kN = uiknob(pl,'continuous','Limits',[0 N],'Value',S.n, ...
    'MajorTicks',0:5:N,'MinorTicks',0:N,'FontName',fName,'FontSize',20,'FontWeight','bold');
kN.Layout.Row = 2;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);       % Rastung: einrasten beim Loslassen
mkLabel(3,'n (Jahre)');

hVal = uilabel(pl,'Text','','FontName',fName,'FontSize',22,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hVal.Layout.Row = 5;
hFor = uilabel(pl,'Text','$\displaystyle \bf x_n = \frac{60\,n}{n+2}$', ...   % Formel als Bruch (LaTeX)
    'FontSize',24,'HorizontalAlignment','center','Interpreter','latex');
hFor.Layout.Row = 6;

cbD = mkCheck(8,'strichliert',S.dash);
cbD.ValueChangedFcn = @(src,~) onDash(src.Value);
cbZ = mkCheck(9,'Zahlenwerte',S.num);
cbZ.ValueChangedFcn = @(src,~) onNum(src.Value);
cbG = mkCheck(10,'Grenze 60 cm',S.lim);
cbG.ValueChangedFcn = @(src,~) onLim(src.Value);

redraw();

%% ---------------- Callbacks ----------------
    function onStep(v)
        nNew = round(v);                        % zeitdiskret: nur ganze Schritte
        if nNew == S.n, return, end             % nur bei Schrittwechsel neu zeichnen
        S.n = nNew;
        redraw();
    end

    function onSnap(src)
        src.Value = round(src.Value);           % Knopf auf ganzes Jahr einrasten lassen
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

    function onLim(v)
        S.lim = v;
        redraw();
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        n = S.n; kk = 0:n; x = S.x;
        set(hX,'XData',kk,'YData',x(kk+1));
        if S.dash, hX.LineStyle = '--'; else, hX.LineStyle = 'none'; end
        set(hM1,'XData',n,'YData',x(n+1));
        % Achsen: bis n = 10 wie Folie fisch_dashed.png, danach mitwachsend
        nAx = max(n,n10);
        xlim(ax1,[-0.5 nAx+0.5]);
        if nAx <= 12, st = 1; elseif nAx <= 24, st = 2; else, st = 5; end   % n-Achse wie alle Folienbilder
        ax1.XTick = 0:st:nAx;
        ylim(ax1,[-3 66]); ax1.YTick = 0:10:60;
        % Grenze 60 cm
        if S.lim
            set(hL,'XData',ax1.XLim,'YData',[L L]);
            set(hTL,'Position',[ax1.XLim(2)-0.3, L+0.5, 0]);
        else
            set(hL,'XData',NaN,'YData',NaN); set(hTL,'Position',[NaN NaN 0]);
        end
        set(hP1,'XData',[n n],'YData',ax1.YLim);           % senkrechter Strich am aktuellen Jahr
        hVal.Text = sprintf('\\bf x_{%d} = %s cm',n,fmt1(x(n+1)));
        % Zahlenwerte an den Markern (Groesse und Farbe wie Folie 12)
        delete(findobj(ax1,'Tag','Zahlenwert'));
        if S.num, placeNumbers(ax1,kk,x(kk+1),colX,fSize); end
        drawnow limitrate
    end

    function placeNumbers(ax,k,y,col,fs)
        % Zahlenwerte an den Markern wie auf Folie 12 (Kapitel I): Groesse wie die Achsenbeschriftung, rot;
        % ueber dem Marker, bei steilem Anstieg links oberhalb (wie Folie), ganz oben links daneben
        pn_yl = ax.YLim; pn_r = diff(pn_yl); pn_dy = 0.03*pn_r;
        pn_h = gobjects(1,numel(k));
        for pn_j = 1:numel(k)
            if pn_j < numel(k), pn_s = y(pn_j+1) - y(pn_j); elseif pn_j > 1, pn_s = y(pn_j) - y(pn_j-1); else, pn_s = 0; end
            pn_t = fmt1(y(pn_j));
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

    function t = fmt1(v)
        % eine Nachkommastelle wie auf Folie 4, aber x_0 = 0 ohne Nachkommastelle
        if v == 0, t = '0'; else, t = sprintf('%.1f',v); end
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
