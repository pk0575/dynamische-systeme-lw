function fibonacci_app
% FIBONACCI_APP  Fibonacci-Folge (Kapitel I, Folie "Loesungsformel" nach den Hasenpaaren)
%
%   x_{n+1} = x_n + x_{n-1},  n >= 1,  x_0 = x_1 = 1
%   x_n = Anzahl der Hasenpaare nach n Monaten (Folie "Anzahl x_n der Hasenpaare nach n Monaten").
%   Zeigt das Wachstum ueber Monat 5 (Folie "Visualisierung der Fibonacci-Folge") hinaus,
%   u. a. x_12 = 233 wie auf der Folie "Loesungsformel".
%
%   Hasenbild (14.11.2026): neben dem Diagramm die Hasenpaare bis Monat n (n <= 5), Farbbild
%   nach Romain, Wikimedia Commons, CC BY-SA 4.0 (Beschriftung uebersetzt, Monate ab 0);
%   Bilddateien fibonacci_hasen_0.png ... fibonacci_hasen_5.png im Ordner der App.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Monat n mit Rastung (zeitdiskret, 1 ... 15, Start n = 1: beide Startwerte sichtbar)
%     - Anzeige von x_n
%     - Kontrollkaestchen Zahlenwerte (x_n an den Markern, wie Folie 12)
%     - Kontrollkaestchen Hasenpaare (Bild ein/aus)
%   Folge strichliert verbunden; Achsen wie Folie fibonacci_neu.png (Monate 0-5), danach mitwachsend.
%
%   Stil wie malaria_app (Kapitel I).
%   Fuer MATLAB R2025b.

%% Parameter
N     = 15;                    % Monate
n5    = 5;                     % bis hierher Achsen wie auf der Folie

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie die anderen Kapitel-I-Apps)

%% Folge
X = zeros(1,N+1); X(1) = 1; X(2) = 1;          % X(k+1) = x_k
for kk = 2:N
    X(kk+1) = X(kk) + X(kk-1);                  % x_{n+1} = x_n + x_{n-1}
end

%% Zustand
S.n = 1;                       % Start bei n = 1 (Startwerte x_0, x_1)
S.num = false;                 % Zahlenwerte an den Markern
S.bild = true;                 % Hasenbild anzeigen
appDir = fileparts(mfilename('fullpath'));

%% GUI
fig = uifigure('Name','Fibonacci-Folge', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {'1x','1x'};
al.BackgroundColor = [1 1 1];

% --- Anzahl Paare ueber die Monate
ax1 = uiaxes(al);
ax1.FontSize = fSize; ax1.FontWeight = 'bold'; ax1.FontName = fName;
ax1.Color = [1 1 1]; ax1.Box = 'on'; hold(ax1,'on');
xlabel(ax1,'n (Monate)'); ylabel(ax1,'Anzahl Hasenpaare x_n');
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);   % aktueller Monat
hX  = plot(ax1,NaN,NaN,'.--','MarkerSize',38,'LineWidth',lw,'Color',colX);
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',16,'MarkerEdgeColor',colX,'LineWidth',2);
ax1.Layout.Row = 1; ax1.Layout.Column = 1;

% --- Hasenpaare als Bild (bis Monat n, ab n = 5 vollstaendig)
bl = uigridlayout(al,[2 1]);
bl.Layout.Row = 1; bl.Layout.Column = 2;
bl.RowHeight = {'1x', 22};
bl.BackgroundColor = [1 1 1];
imgH = uiimage(bl,'ScaleMethod','fit');
imgH.Layout.Row = 1;
hCred = uilabel(bl,'Text','Bild: Romain, Wikimedia Commons, CC BY-SA 4.0, verändert', ...
    'FontName',fName,'FontSize',12,'HorizontalAlignment','center');
hCred.Layout.Row = 2;

% --- Seitenleiste
pl = uigridlayout(gl,[9 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Rand | Knopf | Titel | Abstand | Wert x_n | Abstand | Zahlenwerte | Hasenpaare | Rand
pl.RowHeight = {'1x', 220, 35, 40, 50, 40, 34, 34, '1x'};   % oben/unten gleich ('1x')
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

% Zeitknopf mit Rastung: Teilstriche nur bei ganzen Monaten 1 ... N (kein n = 0);
% beim Drehen springt die Darstellung von Monat zu Monat (live), beim
% Loslassen rastet der Knopf auf den naechsten ganzen Monat ein
kN = uiknob(pl,'continuous','Limits',[1 N],'Value',S.n, ...
    'MajorTicks',1:N,'MinorTicks',[], ...
    'FontName',fName,'FontSize',20,'FontWeight','bold');
kN.Layout.Row = 2;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);
mkLabel(3,'n (Monate)');

hVal = uilabel(pl,'Text','','FontName',fName,'FontSize',22,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex');
hVal.Layout.Row = 5;

cbZ = mkCheck(7,'Zahlenwerte',S.num);
cbZ.ValueChangedFcn = @(src,~) onNum(src.Value);
cbH = mkCheck(8,'Hasenpaare',S.bild);
cbH.ValueChangedFcn = @(src,~) onBild(src.Value);

redraw();

%% ---------------- Callbacks ----------------
    function onStep(v)
        nNew = max(1,round(v));                 % nur ganze Monate, n = 0 nicht anwaehlbar
        if nNew == S.n, return, end             % nur bei Monatswechsel neu zeichnen
        S.n = nNew;
        redraw();
    end

    function onSnap(src)
        src.Value = max(1,round(src.Value));    % Knopf auf den ganzen Monat einrasten lassen
        onStep(src.Value);
    end

    function onNum(v)
        S.num = v;
        redraw();
    end

    function onBild(v)
        S.bild = v;
        redraw();
    end

%% ---------------- Zeichnen ----------------
    function redraw()
        n = S.n; k = 0:n;
        set(hX,'XData',k,'YData',X(k+1));
        set(hM1,'XData',n,'YData',X(n+1));
        % Achsen: bis n = 5 wie auf der Folie, danach mitwachsend
        nAx = max(n,n5);
        top = X(nAx+1);
        xlim(ax1,[-0.5 nAx+0.5]); ax1.XTick = 0:nAx;
        ylim(ax1,[0, 1.125*top]);
        if nAx == n5, ax1.YTick = [1 3 5 8]; else, ax1.YTickMode = 'auto'; end
        set(hP1,'XData',[n n],'YData',ax1.YLim);
        hVal.Text = sprintf('\\bf x_{%d} = %d',n,X(n+1));
        % Zahlenwerte an den Markern (Groesse und Farbe wie Folie 12)
        delete(findobj(ax1,'Tag','Zahlenwert'));
        if S.num, placeNumbers(ax1,k,X(k+1),colX,fSize); end
        % Hasenbild: Zeilen bis Monat n (ab n = 5 das ganze Bild)
        if S.bild
            al.ColumnWidth = {'1x','1x'};
            f = fullfile(appDir,sprintf('fibonacci_hasen_%d.png',min(n,5)));
            if isfile(f), imgH.ImageSource = f; end
            bl.Visible = 'on';
        else
            al.ColumnWidth = {'1x',0};
            bl.Visible = 'off';
        end
        drawnow limitrate
    end

%% ---------------- Hilfsfunktionen ----------------
    function h = mkLabel(row,txtL)
        h = uilabel(pl,'Text',['\bf ' txtL],'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
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

    function cbx = mkCheck(row,txtC,val)
        g = uigridlayout(pl,[1 3]);          % zentriert
        g.Layout.Row = row;
        g.ColumnWidth = {'1x','fit','1x'};
        g.Padding = [0 0 0 0];
        g.BackgroundColor = [1 1 1];
        cbx = uicheckbox(g,'Text',txtC,'Value',val, ...
            'FontName',fName,'FontSize',20,'FontWeight','bold');
        cbx.Layout.Column = 2;
    end
end
