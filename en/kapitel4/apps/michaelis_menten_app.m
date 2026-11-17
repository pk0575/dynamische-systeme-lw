function michaelis_menten_app
% MICHAELIS_MENTEN_APP  Enzymkinetik: volles System und quasistationaere Naeherung
%
%   Reaktionen:  S + E -> SE (k1),  SE -> S + E (k2),  SE -> P + E (k3)
%
%   Volles System (Massenwirkungsgesetz), mit [E] = Etot - [SE]:
%     d[S]/dt  = -k1*Etot*[S] + (k1*[S] + k2)*[SE]
%     d[SE]/dt =  k1*Etot*[S] - (k1*[S] + k2 + k3)*[SE]
%     [P] = S0 - [S] - [SE]
%
%   Quasistationaere Naeherung (d[SE]/dt = 0):
%     d[S]/dt = -kmax*[S]/(k50 + [S]),  kmax = k3*Etot,  k50 = (k2 + k3)/k1
%
%   Einheiten: Konzentrationen in muM, Zeit in s.
%   Startwerte wie in der Vorlesung: k1 = 1, k2 = 1e-4, k3 = 0.1, S0 = 0.5, Etot = 0.2.
%   Fuer Etot << S0 + k50 stimmen beide Loesungen gut ueberein.
%
%   Bedienelemente (Seitenleiste):
%     - Knopf Gesamtenzym Etot (logarithmisch, 0.001 ... 1 muM)
%     - Knopf Startsubstrat S0
%     - Knopf k3 (Umwandlungsrate)
%     - Kontrollkaestchen: Phasenebene ([S],[SE]) anzeigen
%
%   Farben nach claude/farbregeln.md: Loesungen in Rottoenen, Kurve d[SE]/dt = 0 blau.
%   Fuer MATLAB R2025b.

%% Parameter und Stil
k1 = 1; k2 = 1e-4;
fName = 'Times New Roman';
fSize = 24;
lw    = 2.5;
colS  = [0.431 0.039 0.118];   % Substrat (dunkelrot)
colC  = [0.886 0.439 0.486];   % Komplex (hellrot)
colP  = [0.640 0.080 0.180];   % Produkt (rot)
colF  = [0.000 0.447 0.741];   % Funktionsgraph (blau)
options = odeset('RelTol',1e-8,'AbsTol',1e-12);

%% Zustand
S.Etot = 0.2;  S.S0 = 0.5;  S.k3 = 0.1;  S.show = false;

%% GUI
fig = uifigure('Name','Michaelis-Menten-Kinetik – volles System und Näherung', ...
    'Color',[1 1 1],'WindowState','maximized');
gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth = {'1x', 340};
gl.BackgroundColor = [1 1 1];

al = uigridlayout(gl,[1 2]);
al.Layout.Row = 1; al.Layout.Column = 1;
al.ColumnWidth = {'1x', 0};
al.BackgroundColor = [1 1 1];

ax1 = mkAxes(al,1);
xlabel(ax1,'Zeit t (s)'); ylabel(ax1,'Konzentration (\muM)');
hS  = plot(ax1,NaN,NaN,'-','Color',colS,'LineWidth',lw+0.5,'DisplayName','[S] volles System');
hSq = plot(ax1,NaN,NaN,'--','Color',colC,'LineWidth',lw+0.5,'DisplayName','[S] quasistationär');
hC  = plot(ax1,NaN,NaN,'-','Color',colC,'LineWidth',lw,'DisplayName','[SE]');
hP  = plot(ax1,NaN,NaN,'-','Color',colP,'LineWidth',lw,'DisplayName','[P] volles System');
hPq = plot(ax1,NaN,NaN,':','Color',colP,'LineWidth',lw+0.5,'DisplayName','[P] quasistationär');
lg1 = legend(ax1,[hS hSq hC hP hPq]);
set(lg1,'Location','east','FontSize',fSize-8,'FontName',fName);

ax2 = mkAxes(al,2);
xlabel(ax2,'Substrat [S] (\muM)'); ylabel(ax2,'Komplex [SE] (\muM)');
hN  = plot(ax2,NaN,NaN,'-','Color',colF,'LineWidth',lw,'DisplayName','d[SE]/dt = 0');
hT  = plot(ax2,NaN,NaN,'-','Color',colP,'LineWidth',lw+0.5,'DisplayName','Lösung');
hT0 = plot(ax2,NaN,NaN,'o','MarkerSize',10,'MarkerFaceColor',colP,'MarkerEdgeColor',colP,'HandleVisibility','off');
lg2 = legend(ax2,[hN hT]);
set(lg2,'Location','northwest','FontSize',fSize-8,'FontName',fName);
setVis2('off');

% --- Seitenleiste
pl = uigridlayout(gl,[14 1]);
pl.Layout.Row = 1; pl.Layout.Column = 2;
pl.RowHeight = {'1x', 115, 35, 10, 115, 35, 10, 115, 35, 10, 28, 10, 110, '1x'};
pl.RowSpacing = 4;
pl.BackgroundColor = [1 1 1];

kE = uiknob(pl,'continuous','Limits',[-3 0],'Value',log10(S.Etot), ...
    'MajorTicks',-3:0,'MajorTickLabels',{'0.001','0.01','0.1','1'}, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
kE.Layout.Row = 2;
kE.ValueChangingFcn = @(~,evt) onPar('Etot',10^evt.Value);
kE.ValueChangedFcn  = @(src,~) onPar('Etot',10^src.Value);
lE = mkLabel(3,'');

kS = uiknob(pl,'continuous','Limits',[0.05 2],'Value',S.S0, ...
    'MajorTicks',[0.05 0.5 1 1.5 2],'FontName',fName,'FontSize',16,'FontWeight','bold');
kS.Layout.Row = 5;
kS.ValueChangingFcn = @(~,evt) onPar('S0',evt.Value);
kS.ValueChangedFcn  = @(src,~) onPar('S0',src.Value);
lS = mkLabel(6,'');

kK = uiknob(pl,'continuous','Limits',[0.01 1],'Value',S.k3, ...
    'MajorTicks',[0.01 0.25 0.5 0.75 1],'FontName',fName,'FontSize',16,'FontWeight','bold');
kK.Layout.Row = 8;
kK.ValueChangingFcn = @(~,evt) onPar('k3',evt.Value);
kK.ValueChangedFcn  = @(src,~) onPar('k3',src.Value);
lK = mkLabel(9,'');

cg = uigridlayout(pl,[1 3]);
cg.Layout.Row = 11; cg.ColumnWidth = {'1x','fit','1x'};
cg.Padding = [0 0 0 0]; cg.BackgroundColor = [1 1 1];
cb = uicheckbox(cg,'Text','Phasenebene anzeigen','Value',S.show, ...
    'FontName',fName,'FontSize',16,'FontWeight','bold');
cb.Layout.Column = 2;
cb.ValueChangedFcn = @(src,~) onShow(src.Value);

lInfo = uilabel(pl,'Text','','FontName',fName,'FontSize',18, ...
    'FontWeight','bold','HorizontalAlignment','center','WordWrap','on');
lInfo.Layout.Row = 13;

update();

%% ---------------- Callbacks ----------------
    function onPar(name,v)
        S.(name) = v;
        update();
    end

    function onShow(v)
        S.show = v;
        if v
            al.ColumnWidth = {'1x','1x'}; setVis2('on');
        else
            al.ColumnWidth = {'1x', 0}; setVis2('off');
        end
    end

    function setVis2(st)
        ax2.Visible = st; hN.Visible = st; hT.Visible = st; hT0.Visible = st; lg2.Visible = st;
    end

%% ---------------- Rechnen / Zeichnen ----------------
    function update()
        Et = S.Etot; s0 = S.S0; k3 = S.k3;
        kmax = k3*Et; k50 = (k2 + k3)/k1;
        lE.Text = sprintf('Gesamtenzym = %.3g \x03BCM',Et);
        lS.Text = sprintf('Startsubstrat = %.2f \x03BCM',s0);
        lK.Text = sprintf('k3 = %.2f pro s',k3);
        % Zeitskala: etwa Zeit fuer den Abbau mit Maximalrate plus Abklingen
        Tend = 1.5*(s0 + 3*k50)/kmax;
        tt = linspace(0,Tend,1500)';
        f = @(t,z) [-k1*Et*z(1) + (k1*z(1) + k2)*z(2); ...
                     k1*Et*z(1) - (k1*z(1) + k2 + k3)*z(2)];
        [~,y]  = ode15s(f,tt,[s0; 0],options);
        [~,yq] = ode15s(@(t,s) -kmax*s/(k50 + s),tt,s0,options);
        Sv = y(:,1); Cv = y(:,2); Pv = s0 - Sv - Cv; Pq = s0 - yq;
        set(hS,'XData',tt,'YData',Sv);  set(hSq,'XData',tt,'YData',yq);
        set(hC,'XData',tt,'YData',Cv);  set(hP,'XData',tt,'YData',Pv);
        set(hPq,'XData',tt,'YData',Pq);
        xlim(ax1,[0 Tend]); ylim(ax1,[0 1.1*s0]);
        Sg = linspace(0,1.05*s0,300);
        set(hN,'XData',Sg,'YData',Et*Sg./(k50 + Sg));
        set(hT,'XData',Sv,'YData',Cv); set(hT0,'XData',s0,'YData',0);
        xlim(ax2,[0 1.05*s0]); ylim(ax2,[0 1.1*max([Cv; Et*s0/(k50 + s0)])]);
        lInfo.Text = sprintf('kmax = %.3g \x03BCM/s\nk50 = %.3g \x03BCM\nmax. Abweichung [S]: %.3g \x03BCM', ...
            kmax,k50,max(abs(Sv - yq)));
        drawnow limitrate
    end

    function ax = mkAxes(parent,col)
        ax = uiaxes(parent);
        ax.Layout.Row = 1; ax.Layout.Column = col;
        ax.FontSize = fSize; ax.FontWeight = 'bold'; ax.FontName = fName;
        ax.Color = [1 1 1]; ax.Box = 'on';
        hold(ax,'on')
    end

    function h = mkLabel(row,txt)
        h = uilabel(pl,'Text',txt,'FontName',fName,'FontSize',20, ...
            'FontWeight','bold','HorizontalAlignment','center');
        h.Layout.Row = row; h.Layout.Column = 1;
    end
end
