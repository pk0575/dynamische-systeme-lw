function heron_newton_app
% HERON_NEWTON_APP  Die Folge vom Kapitelanfang und das Newton-Verfahren
%   (Kapitel I)
%
%   x_{n+1} = (x_n + 2/x_n)/2   (Heron-Verfahren fuer sqrt(2))
%
%   ist das Newton-Verfahren x_{n+1} = x_n - g(x_n)/g'(x_n) fuer
%   g(x) = x^2 - 2. Fuer x_0 > 0 konvergiert die Folge gegen sqrt(2),
%   fuer x_0 < 0 gegen -sqrt(2); fuer x_0 = 0 ist g'(x_0) = 0 und das
%   Verfahren bricht ab.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Startwert x_0
%     - Knopf Schritt n (Folge wird bis n gezeichnet, Start n = 0)
%     - Anzeige von x_n mit 12 Nachkommastellen
%     - Kontrollkaestchen: Newton-Tangenten (Graph von g mit den
%       Tangentenschritten), Fehler |x_n - x*| (logarithmische Achse:
%       Verdopplung der richtigen Ziffern pro Schritt)
%
%   Ersetzt die App-Designer-App app_recursive_sqrt2
%   (Stil wie alcohol_app, genschalter_app, chemostat_hopf_app).
%
%   Fuer MATLAB R2025b.

%% Parameter
N    = 8;                      % Anzahl Schritte
x0Lim = [-3 5];
g    = @(x) x.^2 - 2;
xg   = linspace(x0Lim(1),x0Lim(2),400);

% Stil wie in den Referenz-Apps
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colX  = [0.64 0.08 0.18];      % Folge (dunkelrot, wie bisherige Kapitel-I-Apps)
colG  = [0.000 0.447 0.741];   % Graph von g (blau)

%% Zustand
S.x0 = 0.5; S.n = 0;           % Startwert wie auf der Folie "Beispiel"
S.tang = false; S.err = false;
S.x = [];
S.busy = false; S.pending = false;

%% GUI
fig = uifigure('Name','Heron-Folge und Newton-Verfahren', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[2 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x','1x'};
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- Folge x_n ueber n
ax1 = mkAxes(al,[1 2],1);
xlabel(ax1,'n'); ylabel(ax1,'x_n');
xlim(ax1,[-0.1 N+0.1]); ylim(ax1,[-3 5]); ax1.XTick = 0:N;
hRp = plot(ax1,[0 N],sqrt(2)*[1 1],'--','Color',[0 0 0],'LineWidth',1.5, ...
    'DisplayName','+\surd2');                                % Grenzwert fuer x_0 > 0
hRm = plot(ax1,[0 N],-sqrt(2)*[1 1],'-.','Color',[0 0 0],'LineWidth',1.5, ...
    'DisplayName','−\surd2');                           % Grenzwert fuer x_0 < 0
hX  = plot(ax1,NaN,NaN,'.','MarkerSize',38,'LineWidth',lw,'LineStyle','--','Color',colX, ...
    'HandleVisibility','off');
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1,'HandleVisibility','off');
hM1 = plot(ax1,NaN,NaN,'o','MarkerSize',16,'MarkerEdgeColor',colX,'LineWidth',2,'HandleVisibility','off');
lg1 = legend(ax1,[hRp hRm]);
set(lg1,'Location','northeast','FontSize',fSize-6,'FontName',fName);

% --- Newton-Tangenten am Graphen von g
ax2 = mkAxes(al,1,2);
xlabel(ax2,'x'); ylabel(ax2,'g(x) = x^2 - 2');
xlim(ax2,x0Lim); ylim(ax2,[-3 12]);
yline(ax2,0,'-','Color',[0 0 0],'LineWidth',1);
hG  = plot(ax2,xg,g(xg),'-','Color',colG,'LineWidth',lw);
hT  = plot(ax2,NaN,NaN,'-','Color',colX,'LineWidth',lw);          % Tangentenstuecke
hV  = plot(ax2,NaN,NaN,':','Color',[0.3 0.3 0.3],'LineWidth',1.5); % senkrecht zum Graphen
hT0 = plot(ax2,NaN,NaN,'.','MarkerSize',30,'Color',colX);           % x_k auf der x-Achse

% --- Fehler |x_n - x*| (logarithmisch)
ax3 = mkAxes(al,2,2);
xlabel(ax3,'n'); ylabel(ax3,'|x_n - x^*|');
ax3.YScale = 'log';
xlim(ax3,[-0.1 N+0.1]); ylim(ax3,[1e-16 10]); ax3.XTick = 0:N;
ax3.YTick = 10.^(-16:4:0);
hE  = plot(ax3,NaN,NaN,'.','MarkerSize',30,'LineWidth',lw,'LineStyle','--','Color',colX);

% --- Seitenleiste
pl = uigridlayout(gl,[12 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Knopf | Titel | Abstand | Knopf | Titel | Abstand | Wert x_n | Abstand | 2 Kaestchen
pl.RowHeight = {'1x', 130, 35, 10, 130, 35, 20, 60, 20, 28, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

k0 = uiknob(pl,'continuous','Limits',x0Lim,'Value',S.x0, ...
    'MajorTicks',x0Lim(1):1:x0Lim(2),'FontName',fName,'FontSize',16,'FontWeight','bold');
k0.Layout.Row = 2;
k0.ValueChangingFcn = @(~,evt) onX0(evt.Value);
k0.ValueChangedFcn  = @(src,~) onX0(src.Value);
mkLabel(pl,3,'Startwert x_0');

kN = uiknob(pl,'continuous','Limits',[0 N],'Value',S.n, ...
    'MajorTicks',0:N,'MinorTicks',[],'FontName',fName,'FontSize',16,'FontWeight','bold');
kN.Layout.Row = 5;
kN.ValueChangingFcn = @(~,evt) onStep(evt.Value);
kN.ValueChangedFcn  = @(src,~) onSnap(src);       % Rastung: einrasten beim Loslassen
mkLabel(pl,6,'Schritt n');

hVal = uilabel(pl,'Text','','FontName',fName,'FontSize',20,'FontWeight','bold', ...
    'HorizontalAlignment','center','Interpreter','tex','WordWrap','on');
hVal.Layout.Row = 8;

cbT = mkCheck(10,'Newton-Tangenten',S.tang);
cbT.ValueChangedFcn = @(src,~) onView('tang',src.Value);
cbE = mkCheck(11,'Fehler |xₙ − x*|',S.err);
cbE.ValueChangedFcn = @(src,~) onView('err',src.Value);

layoutRight();
update();

%% ---------------- Callbacks ----------------
    function onX0(v)
        S.x0 = v;
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

    function onView(name,v)
        S.(name) = v;
        layoutRight();
    end

    function layoutRight()
        % rechte Spalte: Tangenten und/oder Fehler
        axs = {ax2, ax3};
        on  = [S.tang, S.err];
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
        setVis(findall(ax2)', S.tang);
        setVis(findall(ax3)', S.err);
    end

    function setVis(h,v)
        st = 'off'; if v, st = 'on'; end
        set(h,'Visible',st);
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        x = nan(1,N+1); x(1) = S.x0;
        for k = 1:N
            if x(k) == 0, break, end               % g'(x) = 0: Verfahren bricht ab
            x(k+1) = (x(k) + 2/x(k))/2;            % = x - g(x)/g'(x)
        end
        S.x = x;
        redraw();
    end

    function redraw()
        n = S.n; k = 0:n;
        x = S.x;
        set(hX,'XData',k,'YData',x(k+1));
        set(hM1,'XData',n,'YData',x(n+1));
        set(hP1,'XData',[n n],'YData',ax1.YLim);
        % Wert x_n
        if isnan(x(n+1))
            hVal.Text = '\bf g''(x) = 0: Verfahren bricht ab';
        else
            hVal.Text = sprintf('\\bf x_{%d} = %.12f',n,x(n+1));
        end
        % Tangentenschritte: (x_k, g(x_k)) -> (x_{k+1}, 0), dann senkrecht zu g(x_{k+1})
        tx = []; ty = []; vx = []; vy = [];
        for j = 1:n
            if isnan(x(j+1)), break, end
            tx = [tx, x(j), x(j+1), NaN];          %#ok<AGROW>
            ty = [ty, g(x(j)), 0, NaN];            %#ok<AGROW>
            vx = [vx, x(j+1), x(j+1), NaN];        %#ok<AGROW>
            vy = [vy, 0, g(x(j+1)), NaN];          %#ok<AGROW>
        end
        vx0 = [x(1), x(1), NaN]; vy0 = [0, g(x(1)), NaN];   % Start: senkrecht von x_0 zum Graphen
        set(hT,'XData',tx,'YData',ty);
        set(hV,'XData',[vx0 vx],'YData',[vy0 vy]);
        set(hT0,'XData',x(k+1),'YData',zeros(size(k)));
        % Fehler zur Grenze x* = sign(x_0) sqrt(2); exakt 0 wird nicht gezeichnet
        e = abs(x(k+1) - sign(S.x0)*sqrt(2));
        e(e == 0) = NaN;
        set(hE,'XData',k,'YData',e);
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

    function h = mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',['\bf ' txt],'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center','Interpreter','tex');
        h.Layout.Row = row; h.Layout.Column = 1;
    end

    function cbx = mkCheck(row,txt,val)
        g0 = uigridlayout(pl,[1 3]);         % zentriert
        g0.Layout.Row = row;
        g0.ColumnWidth = {'1x','fit','1x'};
        g0.Padding = [0 0 0 0];
        g0.BackgroundColor = [1 1 1];
        cbx = uicheckbox(g0,'Text',txt,'Value',val, ...
            'FontName',fName,'FontSize',16,'FontWeight','bold');
        cbx.Layout.Column = 2;
    end
end
