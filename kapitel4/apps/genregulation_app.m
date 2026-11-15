function genregulation_app
% GENREGULATION_APP  Hopf-Bifurkation im genetischen Oszillator von
%   Smolen et al. (Beispiel "Oscillatory Gene Expression" in Garfinkel,
%   Shevtsov & Guo, Modeling Life; Abb. 15 in Garfinkel et al., UCLA-Paper)
%
%   A: Transkriptionsfaktor (Aktivator), aktiviert sein eigenes Gen (Staerke k)
%   R: Repressor, wird von A aktiviert und hemmt die Aktivierung
%
%   A' = k*A^2/(A^2 + 10*(1 + R/0.2)) - A + 0.4
%   R' = 0.3*A^2/(A^2 + 10*(1 + R/0.2)) - 0.2*R
%
%   Original: Smolen, Baxter & Byrne, Am J Physiol Cell Physiol 274:C531
%   (1998), Gl. 2-3 und Abb. 3: k = k1,f (max. Syntheserate von TF-A),
%   r1,bas = 0.4, k1,d = 1, K1,d = K2,d = 10, k2,f = 0.3, k2,d = 0.2,
%   KR,d = 0.2 (im Buch steht in b faelschlich R/0.5).
%   Einheiten: Zeit in min, Raten in 1/min; Konzentrationen sind
%   dimensionslos ("effective concentrations of TFs ... in the nucleus are
%   generally not known"). Paper: Oszillationen fuer 9.9 < k1,f < 10.8 /min.
%
%   Gleichgewicht stabil fuer k < ca. 9.95 und k > ca. 10.85, dazwischen
%   instabil mit stabilem Grenzzyklus (Periode ca. 40 min). Kontrollwerte aus
%   dem Buch: k = 9.5 -> (A,R) = (1, 0.1), lambda = -0.06 +- 0.17i;
%             k = 10.5 -> (A,R) = (2.5, 0.3), lambda = +0.024 +- 0.16i.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Rueckkopplungsstaerke k
%     - Knopf Zeit
%     - Kontrollkaestchen: Phasenebene (A,R) mit Nullklinen
%     - Kontrollkaestchen: Bifurkationsdiagramm (A ueber k)
%
%   Fuer MATLAB R2025b.

%% Parameter
y0 = [3; 0.3];
Tend = 400;
kLim = [9 12];
kGrid = (kLim(1):0.02:kLim(2))';
aMax = 6; rMax = 0.7;              % Achsengrenzen
options = odeset('RelTol',1e-7,'AbsTol',1e-9);

% Stil wie in main_bioreactor.m
fName = 'Times New Roman';
fSize = 24;
lw    = 2;
colA  = [0.000 0.447 0.741];   % Aktivator (blau)
colR  = [0.850 0.150 0.150];   % Repressor (rot)
colN  = [0.466 0.674 0.188];   % Nullklinen (gruen)

%% Zustand
S.k = 9.5; S.t = 0;         % Zeitknopf startet bei 0
S.phase = false; S.bif = false;
S.tt = linspace(0,Tend,4001)'; S.Y = zeros(4001,2);
S.busy = false; S.pending = false;
S.bifData = [];

%% GUI
fig = uifigure('Name','Genregulation – Hopf-Bifurkation', ...
    'Color',[1 1 1],'WindowState','maximized');

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[2 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.RowHeight = {'1x','1x'};
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

% --- Zeitverlauf
ax1 = mkAxes(al,1,1);
xlabel(ax1,'Zeit t (min)');
ylabel(ax1,'Aktivator [TF-A]');
xlim(ax1,[0 Tend]); ylim(ax1,[0 aMax]);
hA  = plot(ax1,NaN,NaN,'-','Color',colA,'LineWidth',lw+1);
hP1 = plot(ax1,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hMA = plot(ax1,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colA,'MarkerEdgeColor',colA);

ax0 = mkAxes(al,2,1);
xlabel(ax0,'Zeit t (min)');
ylabel(ax0,'Repressor [TF-R]');
xlim(ax0,[0 Tend]); ylim(ax0,[0 rMax]);
hR  = plot(ax0,NaN,NaN,'-','Color',colR,'LineWidth',lw+1);
hP0 = plot(ax0,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1);
hMR = plot(ax0,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colR,'MarkerEdgeColor',colR);

% --- Phasenebene
ax2 = mkAxes(al,1,2);
xlabel(ax2,'Aktivator [TF-A]');
ylabel(ax2,'Repressor [TF-R]');
xlim(ax2,[0 aMax]); ylim(ax2,[0 rMax]);
Ag = linspace(0.01,aMax,600)';
hNA = plot(ax2,NaN,NaN,'-','Color',colN,'LineWidth',lw,'DisplayName','A'' = 0');
hNR = plot(ax2,NaN,NaN,'--','Color',colN,'LineWidth',lw,'DisplayName','R'' = 0');
hTr = plot(ax2,NaN,NaN,'-','Color',colA,'LineWidth',lw,'HandleVisibility','off');
hEq = plot(ax2,NaN,NaN,'o','MarkerSize',12,'MarkerEdgeColor',[0 0 0],'LineWidth',2,'DisplayName','Gleichgewicht');
hM2 = plot(ax2,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colA,'MarkerEdgeColor',colA,'HandleVisibility','off');
lg2 = legend(ax2,[hNA hNR hEq]);
set(lg2,'Location','northwest','FontSize',fSize-8,'FontName',fName);

% --- Bifurkationsdiagramm
ax3 = mkAxes(al,2,2);
xlabel(ax3,'max. Syntheserate k (1/min)');
ylabel(ax3,'Aktivator [TF-A]');
xlim(ax3,kLim); ylim(ax3,[0 aMax]);
hBs = plot(ax3,NaN,NaN,'-','Color',[0 0 0],'LineWidth',lw+1,'DisplayName','stabil');
hBu = plot(ax3,NaN,NaN,'--','Color',[0 0 0],'LineWidth',lw,'DisplayName','instabil');
hBc = plot(ax3,NaN,NaN,'.','Color',colA,'MarkerSize',12,'DisplayName','Grenzzyklus (Min./Max.)');
hBd = plot(ax3,NaN,NaN,':','Color',[0.4 0.4 0.4],'LineWidth',1.5,'HandleVisibility','off');
hB3 = plot(ax3,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colA,'MarkerEdgeColor',colA,'HandleVisibility','off');
lg3 = legend(ax3,[hBs hBu hBc]);
set(lg3,'Location','northwest','FontSize',fSize-8,'FontName',fName);

layoutRight();

% --- Seitenleiste
pl = uigridlayout(gl,[10 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
% Zeilen: Element | Titel | Abstand ...   ('1x' oben/unten = vertikal mittig)
pl.RowHeight = {'1x', 130, 35, 10, 130, 35, 10, 28, 28, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kK = uiknob(pl,'continuous','Limits',kLim,'Value',S.k, ...
    'MajorTicks',kLim(1):0.5:kLim(2),'FontName',fName,'FontSize',16,'FontWeight','bold');
kK.Layout.Row = 2;
kK.ValueChangingFcn = @(~,evt) onK(evt.Value);
kK.ValueChangedFcn  = @(src,~) onK(src.Value);
mkLabel(pl,3,'max. Syntheserate k (1/min)');

kT = uiknob(pl,'continuous','Limits',[0 Tend],'Value',S.t, ...
    'MajorTicks',0:100:Tend,'FontName',fName,'FontSize',16,'FontWeight','bold');
kT.Layout.Row = 5;
kT.ValueChangingFcn = @(~,evt) onTime(evt.Value);
kT.ValueChangedFcn  = @(src,~) onTime(src.Value);
mkLabel(pl,6,'Zeit t (min)');

cb1 = mkCheck(8,'Phasenebene',S.phase);
cb1.ValueChangedFcn = @(src,~) onPhase(src.Value);
cb2 = mkCheck(9,'Bifurkationsdiagramm',S.bif);
cb2.ValueChangedFcn = @(src,~) onBif(src.Value);

update();

%% ---------------- Callbacks ----------------
    function onK(v)
        S.k = v;
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

    function onPhase(v)
        S.phase = v;
        layoutRight();
    end

    function onBif(v)
        S.bif = v;
        if v && isempty(S.bifData), computeBif(); end
        layoutRight();
        redraw();
    end

    function layoutRight()
        % rechte Spalte nur zeigen, wenn mindestens ein Zusatzdiagramm aktiv ist
        if S.phase || S.bif
            al.ColumnWidth = {'1x','1x'};
        else
            al.ColumnWidth = {'1x', 0};
        end
        if S.phase && S.bif
            al.RowHeight = {'1x','1x'};
            ax2.Layout.Row = 1; ax3.Layout.Row = 2;
        elseif S.phase
            ax2.Layout.Row = [1 2];
        elseif S.bif
            ax3.Layout.Row = [1 2];
        end
        setVis([ax2 hNA hNR hTr hEq hM2 lg2], S.phase);
        setVis([ax3 hBs hBu hBc hBd hB3 lg3], S.bif);
    end

    function setVis(h,v)
        st = 'off'; if v, st = 'on'; end
        set(h,'Visible',st);
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function dy = rhs(y,k)
        A = y(1); R = y(2);
        b = 1/(A^2 + 10*(1 + R/0.2));
        dy = [k*A^2*b - A + 0.4;
              0.3*A^2*b - 0.2*R];
    end

    function [Ae,stab,Re] = equilibrium(k)
        % Aus A' = 0 und R' = 0 folgt A^2*b = (A - 0.4)/k = 0.2*R/0.3,
        % also R = 1.5*(A - 0.4)/k; eingesetzt bleibt eine Gleichung fuer A.
        Rof = @(A) 1.5*(A - 0.4)/k;
        g = @(A) k*A.^2./(A.^2 + 10*(1 + Rof(A)/0.2)) - A + 0.4;
        Ae = fzero(g,[0.4+1e-9 k+0.4]);
        Re = Rof(Ae);
        % Jacobi-Matrix wie im Buch (mit b = 1/(A^2 + 10(1 + R/0.2)))
        b = 1/(Ae^2 + 10*(1 + Re/0.2));
        J = [-2*k*Ae^3*b^2 + 2*k*Ae*b - 1,   -50*Ae^2*k*b^2;
              0.6*Ae*b - 0.6*Ae^3*b^2,       -15*Ae^2*b^2 - 0.2];
        stab = all(real(eig(J)) < 0);
    end

    function update()
        [~,Y] = ode45(@(t,y) rhs(y,S.k),S.tt,y0,options);
        S.Y = Y;
        % Nullklinen (nach R aufgeloest)
        %   A' = 0:  A^2 + 10(1+R/0.2) = k A^2/(A - 0.4)
        %   R' = 0:  A^2 + 10(1+R/0.2) = 1.5 A^2/R  -> quadratisch in R
        RnA = 0.2*((S.k*Ag.^2./(Ag - 0.4) - Ag.^2)/10 - 1);
        RnA(Ag <= 0.4) = NaN;
        p2 = 50; p1 = Ag.^2 + 10;                   % 50 R^2 + (A^2+10) R - 1.5 A^2 = 0
        RnR = (-p1 + sqrt(p1.^2 + 4*p2*1.5*Ag.^2))/(2*p2);
        set(hNA,'XData',Ag,'YData',RnA);
        set(hNR,'XData',Ag,'YData',RnR);
        [Ae,stab,Re] = equilibrium(S.k);
        if stab, fc = [0 0 0]; else, fc = [1 1 1]; end
        set(hEq,'XData',Ae,'YData',Re,'MarkerFaceColor',fc);
        redraw();
    end

    function computeBif()
        % Gleichgewichtszweig und Min/Max des Grenzzyklus (einmalig)
        fig.Pointer = 'watch'; drawnow
        n = numel(kGrid);
        Ae = zeros(n,1); st = false(n,1); cx = []; cy = [];
        for j = 1:n
            [Ae(j),st(j)] = equilibrium(kGrid(j));
            if ~st(j)
                [~,Y] = ode45(@(t,y) rhs(y,kGrid(j)),[0 (1000:0.2:1200)],y0,options);
                a = Y(2:end,1);
                cx = [cx; kGrid(j); kGrid(j)];   %#ok<AGROW>
                cy = [cy; min(a); max(a)];       %#ok<AGROW>
            end
        end
        As = Ae; As(~st) = NaN;
        Au = Ae; Au(st)  = NaN;
        % Zweige an den Hopf-Punkten lueckenlos verbinden
        for j = 2:n
            if st(j) ~= st(j-1), Au(j-1) = Ae(j-1); Au(j) = Ae(j); end
        end
        set(hBs,'XData',kGrid,'YData',As);
        set(hBu,'XData',kGrid,'YData',Au);
        set(hBc,'XData',cx,'YData',cy);
        S.bifData = true;
        fig.Pointer = 'arrow';
    end

    function redraw()
        idx = S.tt <= S.t + 1e-9;
        set(hA,'XData',S.tt(idx),'YData',S.Y(idx,1));
        set(hR,'XData',S.tt(idx),'YData',S.Y(idx,2));
        set(hP0,'XData',[S.t S.t],'YData',[0 rMax]);
        At = interp1(S.tt,S.Y(:,1),S.t);  Rt = interp1(S.tt,S.Y(:,2),S.t);
        set(hMA,'XData',S.t,'YData',At);
        set(hMR,'XData',S.t,'YData',Rt);
        set(hP1,'XData',[S.t S.t],'YData',[0 aMax]);
        set(hTr,'XData',S.Y(idx,1),'YData',S.Y(idx,2));
        set(hM2,'XData',At,'YData',Rt);
        set(hBd,'XData',[S.k S.k],'YData',[0 aMax]);
        set(hB3,'XData',S.k,'YData',At);
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

    function mkLabel(parent,row,txt)
        h = uilabel(parent,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
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
