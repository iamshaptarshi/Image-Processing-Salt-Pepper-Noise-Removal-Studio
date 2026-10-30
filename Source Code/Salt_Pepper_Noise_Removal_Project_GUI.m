function main_project7_gui()
% Project 7 - Salt-and-Pepper Noise Removal Studio
% MATLAB R2014 compatible light-blue sidebar workspace.

bg=[0.94 0.97 1.00];          % cool, very light blue workspace
sidebarBg=[0.84 0.91 0.99];   % blue-tinted left navigation
navy=[0.10 0.20 0.36];
blue=[0.12 0.43 0.78];
teal=blue; % shared accent name used by the processing callbacks
blueDark=[0.12 0.32 0.62];
green=[0.08 0.63 0.48];
white=[0.995 0.998 1.00];
muted=[0.38 0.49 0.63];
card=[0.995 0.998 1.00];
lineBlue=[0.68 0.80 0.94];
pale=[0.89 0.94 0.99];

f=figure('Name','DIP Lab | Noise Removal Studio','NumberTitle','off', ...
    'MenuBar','none','Toolbar','none','Color',bg,'Units','pixels', ...
    'Position',[70 45 1360 800],'Resize','on','WindowStyle','normal', ...
    'DockControls','on','Visible','on');

% Full-height blue sidebar, inspired by the supplied reference layout.
side=uipanel(f,'Units','normalized','Position',[0 0 .210 1], ...
    'BorderType','none','BackgroundColor',sidebarBg);
uicontrol(side,'Style','text','String','DIP LAB  /  PROJECT 07', ...
    'Units','normalized','Position',[.075 .945 .85 .027], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',blue, ...
    'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');
uicontrol(side,'Style','text','String','IMAGE RESTORATION', ...
    'Units','normalized','Position',[.075 .908 .85 .035], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',navy, ...
    'FontSize',16,'FontWeight','bold','HorizontalAlignment','left');
uicontrol(side,'Style','text','String','WORKSPACE', ...
    'Units','normalized','Position',[.075 .855 .85 .025], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',muted, ...
    'FontSize',9,'FontWeight','bold','HorizontalAlignment','left');

% Image selection is the first primary action in the sidebar.
makeFlatButton(side,'Select Image',[.07 .795 .86 .060],blue,white,@selectImage);

uicontrol(side,'Style','text','String','EXPERIMENT SETTINGS', ...
    'Units','normalized','Position',[.075 .735 .85 .028], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',blue, ...
    'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');

uicontrol(side,'Style','text','String','NOISE DENSITY', ...
    'Units','normalized','Position',[.075 .675 .85 .030], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',navy, ...
    'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');
densityValue=uicontrol(side,'Style','text','Tag','densityValue','String','10%', ...
    'Units','normalized','Position',[.075 .615 .85 .055], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',blue, ...
    'FontSize',21,'FontWeight','bold','HorizontalAlignment','center');

% Minimal reference-style track and circular knob (5% to 50%).
sliderAx=axes('Parent',side,'Units','normalized','Position',[.10 .575 .80 .035]);
set(sliderAx,'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[], ...
    'Color',sidebarBg,'XColor',sidebarBg,'YColor',sidebarBg,'Box','off');
set(sliderAx,'Tag','densitySliderTrack','HitTest','on');
set(sliderAx,'ButtonDownFcn',@densityClick);
hold(sliderAx,'on');
line('Parent',sliderAx,'XData',[0 1],'YData',[.5 .5], ...
    'Color',[.66 .76 .88],'LineWidth',5,'HitTest','off');
sliderFill=line('Parent',sliderAx,'XData',[0 1/9],'YData',[.5 .5], ...
    'Color',[.15 .65 .82],'LineWidth',5,'HitTest','off');
sliderKnob=line('Parent',sliderAx,'XData',[1/9 1/9],'YData',[.5 .5], ...
    'LineStyle','none','Marker','o','MarkerSize',12, ...
    'MarkerFaceColor',[.97 .995 1],'MarkerEdgeColor',[.10 .48 .78], ...
    'LineWidth',1.6,'HitTest','off');
hold(sliderAx,'off');
uicontrol(side,'Style','text','String','5%','Units','normalized', ...
    'Position',[.10 .545 .20 .025],'BackgroundColor',sidebarBg, ...
    'ForegroundColor',muted,'FontSize',9,'HorizontalAlignment','left');
uicontrol(side,'Style','text','String','50%','Units','normalized', ...
    'Position',[.70 .545 .20 .025],'BackgroundColor',sidebarBg, ...
    'ForegroundColor',muted,'FontSize',9,'HorizontalAlignment','right');

uicontrol(side,'Style','text','String','FILTER ALGORITHM', ...
    'Units','normalized','Position',[.075 .475 .85 .030], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',navy, ...
    'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');
uicontrol(side,'Style','popupmenu','Tag','filter','String', ...
    {'Mean','Median','Gaussian','Adaptive Median'},'Value',4, ...
    'Units','normalized','Position',[.075 .425 .85 .052], ...
    'FontSize',10,'BackgroundColor',white,'ForegroundColor',navy);

makeFlatButton(side,'Process Image',[.07 .325 .86 .065],green,white,@processImage);
makeFlatButton(side,'Save Restored Image',[.07 .235 .86 .065],blueDark,white,@saveOutput);
makeFlatButton(side,'Reset / New Image',[.07 .145 .86 .065],[.25 .52 .78],white,@resetApp);

uicontrol(side,'Style','text','String','PROJECT 07  -  DIGITAL IMAGE PROCESSING', ...
    'Units','normalized','Position',[.075 .055 .85 .035], ...
    'BackgroundColor',sidebarBg,'ForegroundColor',muted, ...
    'FontSize',8,'HorizontalAlignment','left');

% Main workspace header.
uicontrol(f,'Style','text','String','Noise Removal Studio', ...
    'Units','normalized','Position',[.235 .905 .73 .055], ...
    'BackgroundColor',bg,'ForegroundColor',navy,'FontSize',25, ...
    'FontWeight','bold','HorizontalAlignment','left');
uicontrol(f,'Style','text','String', ...
    'Restore details. Compare algorithms. Measure image quality.', ...
    'Units','normalized','Position',[.238 .872 .72 .026], ...
    'BackgroundColor',bg,'ForegroundColor',muted,'FontSize',10, ...
    'HorizontalAlignment','left');

% Three equal, aligned image preview cards.
cardY=.405; cardH=.365; cardW=.240; gap=.012; left=.235;
p1=makeCard(f,'01  ORIGINAL IMAGE',left,cardY,cardW,cardH,blue,card);
p2=makeCard(f,'02  NOISY INPUT',left+cardW+gap,cardY,cardW,cardH,blue,card);
p3=makeCard(f,'03  RESTORED OUTPUT',left+2*(cardW+gap),cardY,cardW,cardH,blue,card);

ax1=axes('Parent',p1,'Units','normalized','Position',[.030 .155 .94 .68]);
ax2=axes('Parent',p2,'Units','normalized','Position',[.030 .155 .94 .68]);
ax3=axes('Parent',p3,'Units','normalized','Position',[.030 .155 .94 .68]);
set([ax1 ax2 ax3],'Color',card,'XColor',card,'YColor',card);
axis(ax1,'off'); axis(ax2,'off'); axis(ax3,'off');
title(ax1,'Select an image','Color',blue,'FontSize',10);
title(ax2,'Noise preview','Color',blue,'FontSize',10);
title(ax3,'Restoration preview','Color',blue,'FontSize',10);

% Compact quality report with status retained inside the same panel.
pm=uipanel(f,'Title','  QUALITY REPORT  ','FontWeight','bold', ...
    'ForegroundColor',blue,'BackgroundColor',card,'BorderType','line', ...
    'HighlightColor',lineBlue,'ShadowColor',[.82 .88 .95], ...
    'Units','normalized','Position',[.235 .105 .745 .205]);
metrics=uicontrol(pm,'Style','text','Tag','metrics','String', ...
    'Select an image to begin the experiment.', ...
    'Units','normalized','Position',[.025 .48 .95 .42], ...
    'BackgroundColor',card,'ForegroundColor',navy,'FontSize',11, ...
    'HorizontalAlignment','left');
uicontrol(pm,'Style','text','String','STATUS', ...
    'Units','normalized','Position',[.025 .08 .075 .25], ...
    'BackgroundColor',card,'ForegroundColor',blue, ...
    'FontSize',9,'FontWeight','bold','HorizontalAlignment','left');
uicontrol(pm,'Style','text','Tag','status', ...
    'String','Ready - select an image from the left sidebar.', ...
    'Units','normalized','Position',[.105 .08 .86 .25], ...
    'BackgroundColor',card,'ForegroundColor',navy,'FontSize',10, ...
    'HorizontalAlignment','left');

D.original=[]; D.noisy=[]; D.restored=[]; D.filename=''; D.density=10;
D.densityValue=densityValue; D.sliderAxes=sliderAx;
D.sliderFill=sliderFill; D.sliderKnob=sliderKnob;
D.axes=[ax1 ax2 ax3]; D.metrics=metrics; D.outputPanel=p3;
D.loaderPanel=[]; D.loaderFill=[]; D.loaderPercent=[]; D.loaderLabel=[]; D.loaderAxes=[];
guidata(f,D);

    function densityClick(src,~)
        fig=ancestor(src,'figure');
        setDensityFromPointer(fig);
        set(fig,'WindowButtonMotionFcn',@densityDrag, ...
            'WindowButtonUpFcn',@densityRelease);
    end

    function densityDrag(fig,~)
        if ishandle(fig), setDensityFromPointer(fig); end
    end

    function densityRelease(fig,~)
        if ishandle(fig)
            set(fig,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
        end
    end

    function setDensityFromPointer(fig)
        D=guidata(fig); ax=D.sliderAxes;
        cp=get(ax,'CurrentPoint');
        x=max(0,min(1,cp(1,1)));
        value=5+round(x*45);
        value=max(5,min(50,value));
        x=(value-5)/45;
        D.density=value;
        set(D.densityValue,'String',sprintf('%d%%',value));
        set(D.sliderFill,'XData',[0 x],'YData',[.5 .5]);
        set(D.sliderKnob,'XData',x,'YData',.5);
        guidata(fig,D);
        drawnow;
    end

    function selectImage(src,~)
        fig=ancestor(src,'figure'); D=guidata(fig);
        [file,path]=uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff','Image files'}, ...
            'Select a clean reference image');
        if isequal(file,0), setStatus(fig,'Image selection cancelled.'); return; end
        try
            im=imread(fullfile(path,file));
            if ndims(im)==3 && size(im,3)>3, im=im(:,:,1:3); end
            D.original=im2double(im); D.noisy=[]; D.restored=[]; D.filename=file;
            guidata(fig,D);
            cla(D.axes(1)); axes(D.axes(1)); imshow(D.original,[]);
            title(D.axes(1),'Original image','Color',teal,'FontSize',10);
            cla(D.axes(2)); axes(D.axes(2)); axis off;
            title(D.axes(2),'Noise preview','Color',teal,'FontSize',10);
            cla(D.axes(3)); axes(D.axes(3)); axis off;
            title(D.axes(3),'Restoration preview','Color',teal,'FontSize',10);
            set(D.metrics,'String',['Loaded image: ' file]);
            setStatus(fig,'Image loaded. Choose noise density and filter, then click Process Image.');
        catch ME
            errordlg(['Could not load image: ' ME.message],'Image Error');
        end
    end

    function resetApp(src,~)
        fig=ancestor(src,'figure'); D=guidata(fig);
        D.original=[]; D.noisy=[]; D.restored=[]; D.filename=''; D.density=10;
        if ~isempty(D.loaderPanel) && ishandle(D.loaderPanel), delete(D.loaderPanel); end
        % Also remove any orphaned overlay left by an interrupted callback.
        orphan=findobj(fig,'Tag','processingOverlay');
        if ~isempty(orphan), delete(orphan); end
        D.loaderPanel=[]; D.loaderFill=[]; D.loaderPercent=[]; D.loaderLabel=[]; D.loaderAxes=[];
        for ii=1:3
            cla(D.axes(ii)); axis(D.axes(ii),'off');
        end
        title(D.axes(1),'Select an image below','Color',teal,'FontSize',10);
        title(D.axes(2),'Noise preview','Color',teal,'FontSize',10);
        title(D.axes(3),'Restoration preview','Color',teal,'FontSize',10);
        set(D.densityValue,'String','10%');
        set(D.sliderFill,'XData',[0 1/9],'YData',[.5 .5]);
        set(D.sliderKnob,'XData',1/9,'YData',.5);
        set(D.metrics,'String','Select an image to begin the experiment.');
        guidata(fig,D); set(fig,'Pointer','arrow');
        setStatus(fig,'Reset complete - select a new image.');
    end

    function processImage(src,~)
        fig=ancestor(src,'figure'); D=guidata(fig);
        if isempty(D.original), errordlg('Select an image in the Original Image panel first.','No image selected'); return; end
        densities=[.05 .10 .20 .30 .40 .50];
        density=D.density/100;
        names=get(findobj(fig,'Tag','filter'),'String');
        method=names{get(findobj(fig,'Tag','filter'),'Value')};
        set(fig,'Pointer','watch');
        setStatus(fig,'Generating noisy image...');
        try
            showLoader(fig,0,'Preparing image'); drawnow;
        catch loaderError
            set(fig,'Pointer','arrow');
            setStatus(fig,['Could not create progress indicator: ' loaderError.message]);
            errordlg(['Progress indicator error: ' loaderError.message],'GUI Error');
            return;
        end
        try
            % Fast vectorized noise generation. Avoid imnoise startup overhead and randperm
            % over every pixel; this creates a random mask in one array operation.
            noisyImage=add_salt_pepper_fast(D.original,density);
            % Merge into current guidata so loader handles are not overwritten by stale D.
            D=guidata(fig);
            D.noisy=noisyImage;
            guidata(fig,D);
            axes(D.axes(2)); imshow(D.noisy,[]);
            title(D.axes(2),sprintf('Noise density %.0f%%',density*100),'Color',teal,'FontSize',10);
            updateLoader(fig,.05,['Applying ' method ' filter']);
            setStatus(fig,['Applying ' method ' filter...']); drawnow;
            t=tic;
            cb=@(fraction) updateLoader(fig,.05+.90*fraction,[method ' filter']);
            switch method
                case 'Mean'
                    D.restored=mean_filter_custom(D.noisy,3);
                    updateLoader(fig,.95,'Finalizing result');
                case 'Median'
                    D.restored=median_filter_custom(D.noisy,3,cb);
                case 'Gaussian'
                    D.restored=gaussian_filter_custom(D.noisy,3,.8);
                    updateLoader(fig,.95,'Finalizing result');
                case 'Adaptive Median'
                    D.restored=adaptive_median_filter_custom(D.noisy,3,7,cb);
            end
            elapsed=toc(t);
            mse=calculate_mse(D.original,D.restored);
            psnr=calculate_psnr(mse);
            ssim=calculate_ssim_global(D.original,D.restored);
            % Preserve loader handles stored by showLoader/updateLoader.
            Dlatest=guidata(fig);
            Dlatest.noisy=D.noisy;
            Dlatest.restored=D.restored;
            guidata(fig,Dlatest);
            D=guidata(fig);
            % Delete the whole overlay panel, not just its child graphics.
            hideLoader(fig);
            cla(D.axes(3)); axes(D.axes(3)); imshow(D.restored,[]);
            title(D.axes(3),[method ' result'],'Color',teal,'FontSize',10);
            set(D.metrics,'String',sprintf( ...
                'Filter: %s     |     Noise: %.0f%%     |     MSE: %.6f     |     PSNR: %.2f dB     |     SSIM: %.4f     |     Time: %.2f s', ...
                method,density*100,mse,psnr,ssim,elapsed));
            set(fig,'Pointer','arrow');
            setStatus(fig,'Processing complete. Save the restored image or compare another filter.');
            drawnow;
        catch ME
            hideLoader(fig); set(fig,'Pointer','arrow');
            setStatus(fig,'Processing failed. See the error dialog.');
            errordlg(['Processing error: ' ME.message],'Processing Error');
        end
    end

    function saveOutput(src,~)
        fig=ancestor(src,'figure'); D=guidata(fig);
        if isempty(D.restored), errordlg('Process an image before saving.','No output'); return; end
        [file,path]=uiputfile({'*.png','PNG image';'*.jpg','JPEG image'}, ...
            'Save restored image','restored_image.png');
        if isequal(file,0), return; end
        try
            imwrite(D.restored,fullfile(path,file));
            setStatus(fig,['Saved restored image: ' fullfile(path,file)]);
        catch ME
            errordlg(['Could not save output: ' ME.message],'Save Error');
        end
    end
end

function h=makeFlatButton(parent,label,pos,fillColor,textColor,callback)
% A flat, borderless color surface with a clickable label.
h=axes('Parent',parent,'Units','normalized','Position',pos, ...
    'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[], ...
    'Color',fillColor,'XColor',fillColor,'YColor',fillColor, ...
    'Box','off','Tag',['flatButton_' regexprep(label,'\W','')], ...
    'ButtonDownFcn',callback);
set(h,'HitTest','on');
% Rounded-rectangle face; native MATLAB R2014 graphics only.
r=.10; n=8;
ang=[linspace(-pi/2,0,n),linspace(0,pi/2,n), ...
     linspace(pi/2,pi,n),linspace(pi,3*pi/2,n)];
cx=[1-r 1-r r r]; cy=[r 1-r 1-r r];
xx=[]; yy=[];
for k=1:4
    xx=[xx cx(k)+r*cos(ang((k-1)*n+1:k*n))]; %#ok<AGROW>
    yy=[yy cy(k)+r*sin(ang((k-1)*n+1:k*n))]; %#ok<AGROW>
end
patch('Parent',h,'XData',xx,'YData',yy, ...
    'FaceColor',fillColor,'EdgeColor','none','HitTest','off');
text('Parent',h,'Position',[.5 .5 0],'String',label, ...
    'Color',textColor,'FontSize',10,'FontWeight','bold', ...
    'HorizontalAlignment','center','VerticalAlignment','middle', ...
    'Interpreter','none','HitTest','off');
end

function p=makeCard(parent,label,x,y,w,h,fg,bg)
p=uipanel(parent,'Title',['  ' label '  '],'FontWeight','bold', ...
    'FontSize',10,'ForegroundColor',fg,'BackgroundColor',bg, ...
    'BorderType','line','HighlightColor',[.68 .80 .94], ...
    'ShadowColor',[.84 .90 .97],'Units','normalized', ...
    'Position',[x y w h]);
end

function setStatus(fig,message)
h=findobj(fig,'Tag','status');
if ~isempty(h), set(h,'String',message); end
drawnow;
end

function showLoader(fig,fraction,label)
% Helper functions at the end of this file do not share main function scope.
teal = [0.12 0.43 0.78];
navy = [0.10 0.20 0.36];
white = [0.995 0.998 1.00];
D=guidata(fig);
if ~isempty(D.loaderPanel) && ishandle(D.loaderPanel), delete(D.loaderPanel); end
% Overlay exactly over the restored image card; deleting this panel removes
% every progress-bar element in one operation.
D.loaderPanel=uipanel(D.outputPanel,'Units','normalized', ...
    'Position',[.025 .04 .95 .91],'BorderType','line', ...
    'BackgroundColor',white,'ForegroundColor',[.68 .80 .94], ...
    'Tag','processingOverlay');
uicontrol(D.loaderPanel,'Style','text','String','PROCESSING IMAGE', ...
    'Units','normalized','Position',[.10 .72 .80 .10], ...
    'BackgroundColor',white,'ForegroundColor',[.36 .47 .61], ...
    'FontSize',9,'FontWeight','bold');
D.loaderLabel=uicontrol(D.loaderPanel,'Style','text','String',label, ...
    'Units','normalized','Position',[.08 .60 .84 .10], ...
    'BackgroundColor',white,'ForegroundColor',[.10 .20 .36], ...
    'FontSize',10);
% Horizontal track and fill, percentage printed inside the bar.
D.loaderAxes=axes('Parent',D.loaderPanel,'Units','normalized','Position',[.10 .40 .80 .16], ...
    'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[],'Box','on', ...
    'Color',[.91 .95 .99],'XColor',[.78 .85 .93],'YColor',[.78 .85 .93], ...
    'Tag','loaderAxes');
hold(D.loaderAxes,'on');
D.loaderFill=patch('Parent',D.loaderAxes,'XData',[0 0 0 0], ...
    'YData',[0 0 1 1],'FaceColor',[.12 .43 .78],'EdgeColor','none','Tag','loaderFill');
D.loaderPercent=text('Parent',D.loaderAxes,'Position',[.5 .5 0], ...
    'String',sprintf('%d%%',round(100*fraction)),'Color',[1 1 1], ...
    'FontSize',11,'FontWeight','bold','HorizontalAlignment','center', ...
    'VerticalAlignment','middle','Clipping','on');
hold(D.loaderAxes,'off');
guidata(fig,D); updateLoader(fig,fraction,label);
end

function updateLoader(fig,fraction,label)
if ~ishandle(fig), return; end
D=guidata(fig);
if isempty(D.loaderPanel) || ~ishandle(D.loaderPanel), return; end
fraction=max(0,min(1,fraction));
if ~isempty(D.loaderFill) && ishandle(D.loaderFill)
    set(D.loaderFill,'XData',[0 fraction fraction 0],'YData',[0 0 1 1]);
end
if ~isempty(D.loaderPercent) && ishandle(D.loaderPercent)
    set(D.loaderPercent,'String',sprintf('%d%%',round(100*fraction)));
end
if ~isempty(D.loaderLabel) && ishandle(D.loaderLabel)
    set(D.loaderLabel,'String',label);
end
guidata(fig,D); drawnow;
end

function hideLoader(fig)
if ~ishandle(fig), return; end
D=guidata(fig);
if isfield(D,'loaderPanel') && ~isempty(D.loaderPanel) && ishandle(D.loaderPanel)
    delete(D.loaderPanel);
end
% Remove any orphaned overlay if guidata was overwritten by an older state.
orphan=findobj(fig,'Tag','processingOverlay');
if ~isempty(orphan), delete(orphan); end
D.loaderPanel=[]; D.loaderFill=[]; D.loaderPercent=[]; D.loaderLabel=[]; D.loaderAxes=[];
guidata(fig,D); drawnow;
end
