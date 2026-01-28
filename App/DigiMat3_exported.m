classdef DigiMat3_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DigiMatUIFigure      matlab.ui.Figure
        FileMenu             matlab.ui.container.Menu
        LoadImageMenu        matlab.ui.container.Menu
        SaveMenu             matlab.ui.container.Menu
        SaveAsMenu           matlab.ui.container.Menu
        NoiseMenu_2          matlab.ui.container.Menu
        UniformMenu_2        matlab.ui.container.Menu
        SaltandPepperMenu_2  matlab.ui.container.Menu
        PointOperatorsMenu   matlab.ui.container.Menu
        InversionMenu        matlab.ui.container.Menu
        BrightnessMenu_2     matlab.ui.container.Menu
        ContrastMenu_3       matlab.ui.container.Menu
        HistEqMenu_2         matlab.ui.container.Menu
        FiltersMenu          matlab.ui.container.Menu
        AverageMenu_2        matlab.ui.container.Menu
        MedianMenu_2         matlab.ui.container.Menu
        SegmentationMenu_2   matlab.ui.container.Menu
        ManualMenu_2         matlab.ui.container.Menu
        SemiAutoMenu_2       matlab.ui.container.Menu
        AutomatedMenu        matlab.ui.container.Menu
        EdgeDetectionMenu_2  matlab.ui.container.Menu
        SobelGradientMenu    matlab.ui.container.Menu
        KirschGradientMenu   matlab.ui.container.Menu
        GeometricMenu_2      matlab.ui.container.Menu
        ZoomMenu_2           matlab.ui.container.Menu
        TranslateMenu_2      matlab.ui.container.Menu
        RotateMenu           matlab.ui.container.Menu
        GridLayout           matlab.ui.container.GridLayout
        LoadInfoLabel        matlab.ui.control.Label
        LoadImageButton      matlab.ui.control.Button
        CopyInfoLabel        matlab.ui.control.Label
        CopyResultButton     matlab.ui.control.Button
        TabGroup             matlab.ui.container.TabGroup
        MessageTab           matlab.ui.container.Tab
        TextArea             matlab.ui.control.TextArea
        UIAxesResult         matlab.ui.control.UIAxes
        UIAxesOriginal       matlab.ui.control.UIAxes
    end


    properties (Access = public)
        Folder % Directorul Imagine primar
        DirFile = '' %Fișierul Imagine
        File % Nume Imagine
        fig
        ax
        img
        Im %Imaginea
        Panel
        Grid_2
        Ax_hist
        Slide_Contrat
        Slide_Stralucire

            ImgOriginal   % store loaded original image
    ImgResult     % store processed image

    end

    methods (Access = public)

        function extractIm(app,src,~)
            data = src.CData;

            app.Im = data;
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Set directories
   appFolder = fileparts(mfilename('fullpath'));   % ...\Application\App
baseFolder = fileparts(appFolder);              % ...\Application

app.DirFile = fullfile(baseFolder, 'Images');
addpath(fullfile(baseFolder, 'Functions'));


  app.ImgOriginal = [];
app.ImgResult   = [];

cla(app.UIAxesOriginal);
title(app.UIAxesOriginal,'Original');

cla(app.UIAxesResult);
title(app.UIAxesResult,'Result (apply an operation)');

% Make axes look like image panels (clean)
set([app.UIAxesOriginal app.UIAxesResult], ...
    'XTick',[], 'YTick',[], 'Box','on', ...
    'Color',[0 0 0], 'XColor','none','YColor','none');

  
% Optional message
    if isprop(app,'TextArea') && ~isempty(app.TextArea)
    app.TextArea.Value = {
    'HOW TO USE THE APP'
    '-------------------------'
    'Step 1: Load an image (File → Load Image)'
    'Step 2: Choose an operation from the top menus (Noise / Filters / etc.)'
    'Step 3: The result will appear on the right'
};


    end

        end

        % Menu selected function: LoadImageMenu
        function LoadImageMenuSelected(app, event)
        
   try
        % Select image
        [file, folder] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp', 'Image Files'}, ...
                                  'Select an image', app.DirFile);
        if isequal(file,0)
            if isprop(app,'TextArea'); app.TextArea.Value = 'User selected Cancel'; end
            return;
        end

        fullpath = fullfile(folder, file);

        % Read image
        Img = imread(fullpath);

        % Convert to grayscale if needed (keeping your logic)
        if ndims(Img) > 2
            Img = rgb2gray(Img);
        end

        % If image is low-bit / small range, stretch to 0-255 (keeping your logic)
        if max(Img(:)) <= 16
            Img = uint8(255 * normalize(double(Img), 'range', [0, 1]));
        end

        % Store in app memory
        app.ImgOriginal = Img;
        app.ImgResult   = [];

        % Display in axes
        imshow(app.ImgOriginal, 'Parent', app.UIAxesOriginal);
        title(app.UIAxesOriginal, 'Original');

        cla(app.UIAxesResult);
        title(app.UIAxesResult, 'Result (apply an operation)');

        % Optional status
        if isprop(app,'TextArea')
            app.TextArea.Value = ['Loaded: ' file];
        end

    catch ME
        if isprop(app,'TextArea')
            app.TextArea.Value = getReport(ME);
        else
            uialert(app.UIFigure, ME.message, 'Load Error');
        end
    end
        end

        % Menu selected function: SaveAsMenu
        function SaveAsMenuSelected(app, event)
                try
        if isempty(app.ImgResult)
            uialert(app.DigiMatUIFigure,'Nothing to save. Apply an operation first.','No Image');
            return;
        end

        % Use Images folder as default location
        if isfolder(app.DirFile)
            startingpath = app.DirFile;
        else
            startingpath = fileparts(app.DirFile);
        end

        [baseFileName, newFolder] = uiputfile( ...
            {'*.png','PNG (*.png)'; '*.jpg','JPG (*.jpg)'; '*.bmp','BMP (*.bmp)'}, ...
            'Save result as', fullfile(startingpath, 'result.png'));

        if isequal(baseFileName,0)
            return;
        end

        fullFileName = fullfile(newFolder, baseFileName);
        imwrite(app.ImgResult, fullFileName);

        app.TextArea.Value = ['Saved: ' fullFileName];

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: SaveMenu
        function SaveMenuSelected(app, event)
            try
        if isempty(app.ImgResult)
            uialert(app.DigiMatUIFigure,'Nothing to save. Apply an operation first.','No Image');
            return;
        end

        % Save next to the loaded image if possible
        if ~isempty(app.File) && ~isempty(app.Folder)
            outName = ['out_' char(app.File)];
            fullFileName = fullfile(app.Folder, outName);
        else
            % fallback to Images folder
            fullFileName = fullfile(app.DirFile, 'out_result.png');
        end

        imwrite(app.ImgResult, fullFileName);
        app.TextArea.Value = ['Saved: ' fullFileName];

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: InversionMenu
        function InversionMenuSelected(app, event)
           try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure, 'Load an image first (File → Load Image).', 'No Image');
            return;
        end

        ImFin = InversionFunc(ImgIn);   % <-- use ImgIn, not app.Im

        app.ImgResult = ImFin;

        imshow(ImFin, 'Parent', app.UIAxesResult);  % <-- show inside app
        title(app.UIAxesResult, 'Inversion');

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: BrightnessMenu_2
        function BrightnessMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg('Enter Brightness Value (e.g. -50 to +50):','Input',[1,35],{'25'});
        if isempty(answ); return; end
        a = str2double(answ{1});
        if isnan(a)
            uialert(app.DigiMatUIFigure,'Brightness must be a number.','Invalid Input');
            return;
        end

        out = BrightnessFunc(ImgIn, a);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Brightness (a=%g)', a));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: ContrastMenu_3
        function ContrastMenu_2Selected(app, event)
             try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg('Enter Contrast Factor (e.g. 0.5, 1, 1.5, 2):','Input',[1,35],{'1.2'});
        if isempty(answ); return; end
        a = str2double(answ{1});
        if isnan(a)
            uialert(app.DigiMatUIFigure,'Contrast must be a number.','Invalid Input');
            return;
        end

        out = ContrastFunc(ImgIn, a);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Contrast (a=%g)', a));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: HistEqMenu_2
        function HistEqMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure, 'Load an image first (File → Load Image).', 'No Image');
            return;
        end

        ImFin = HistEqFunc(ImgIn);

        app.ImgResult = ImFin;

        imshow(ImFin, 'Parent', app.UIAxesResult);
        title(app.UIAxesResult, 'Histogram Equalization');

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: UniformMenu_2
        function UniformMenuSelected(app, event)
           try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg({'Enter Percentage (0-100):','Enter Amplitude (e.g. 0.2 or 20):'}, ...
                        'Input',[1,35],{'20','0.2'});
        if isempty(answ); return; end

        perc = str2double(answ{1});
        amp  = str2double(answ{2});

        if isnan(perc) || perc < 0 || perc > 100
            uialert(app.DigiMatUIFigure,'Percentage must be between 0 and 100.','Invalid Input');
            return;
        end
        if isnan(amp) || amp < 0
            uialert(app.DigiMatUIFigure,'Amplitude must be a positive number.','Invalid Input');
            return;
        end

        out = UniformNoiseFunc(ImgIn, perc, amp);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Uniform Noise (%.0f%%, amp=%g)', perc, amp));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: SaltandPepperMenu_2
        function SaltandPepperMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg('Enter Percentage (0-100):','Input',[1,35],{'25'});
        if isempty(answ); return; end
        perc = str2double(answ{1});

        if isnan(perc) || perc < 0 || perc > 100
            uialert(app.DigiMatUIFigure,'Percentage must be between 0 and 100.','Invalid Input');
            return;
        end

        out = SaltAndPaperFunc(ImgIn, perc);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Salt & Pepper (%.0f%%)', perc));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: AverageMenu_2
        function AverageMenuSelected(app, event)
          try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure, 'Load an image first (File → Load Image).', 'No Image');
            return;
        end

        answ = inputdlg('Enter Window size (odd: 3,5,7...):', 'Input', [1,35], {'3'});
        if isempty(answ); return; end
        ws = str2double(answ{1});

        if isnan(ws) || ws < 1 || mod(ws,2) == 0
            uialert(app.DigiMatUIFigure, 'Window size must be an odd integer (3,5,7...).', 'Invalid Input');
            return;
        end

        ImFin = AverageFunc(ImgIn, ws);

        app.ImgResult = ImFin;

        imshow(ImFin, 'Parent', app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Average Filter (ws=%d)', ws));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: MedianMenu_2
        function MedianMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure, 'Load an image first (File → Load Image).', 'No Image');
            return;
        end

        answ = inputdlg('Enter Window size (odd: 3,5,7...):', 'Input', [1,35], {'3'});
        if isempty(answ); return; end
        ws = str2double(answ{1});

        if isnan(ws) || ws < 1 || mod(ws,2) == 0
            uialert(app.DigiMatUIFigure, 'Window size must be an odd integer (3,5,7...).', 'Invalid Input');
            return;
        end

        ImFin = MedianFunc(ImgIn, ws);

        app.ImgResult = ImFin;

        imshow(ImFin, 'Parent', app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Median Filter (ws=%d)', ws));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: ManualMenu_2
        function ManualMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg('E+nter Threshold (0-255):','Input',[1,35],{'50'});
        if isempty(answ); return; end
        th = str2double(answ{1});

        if isnan(th) || th < 0 || th > 255
            uialert(app.DigiMatUIFigure,'Threshold must be between 0 and 255.','Invalid Input');
            return;
        end

        out = ManualSFunc(ImgIn, th);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Manual Segmentation (th=%g)', th));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: SemiAutoMenu_2
        function SemiAutoMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg('Enter Percentage (0-100):','Input',[1,35],{'20'});
        if isempty(answ); return; end
        perc = str2double(answ{1});

        if isnan(perc) || perc < 0 || perc > 100
            uialert(app.DigiMatUIFigure,'Percentage must be between 0 and 100.','Invalid Input');
            return;
        end

        out = SemiAutoSFunc(ImgIn, perc);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Semi-Auto Segmentation (%.0f%%)', perc));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: AutomatedMenu
        function AutomaticMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        out = AutomaticSFunc(ImgIn);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, 'Automatic Segmentation');

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: SobelGradientMenu
        function SobelMenuSelected(app, event)
           try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure, 'Load an image first (File → Load Image).', 'No Image');
            return;
        end

        ImFin = SobelFunc(ImgIn);

        app.ImgResult = ImFin;

        imshow(ImFin, 'Parent', app.UIAxesResult);
        title(app.UIAxesResult, 'Sobel Gradient');

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: KirschGradientMenu
        function KirschMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        out = KirschFunc(ImgIn);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, 'Kirsch Gradient');

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: ZoomMenu_2
        function ZoomMenuSelected(app, event)
           try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg('Enter zoom factor (e.g. 0.5, 1.5, 2):','Input',[1,35],{'2'});
        if isempty(answ); return; end
        a = str2double(answ{1});

        if isnan(a) || a <= 0
            uialert(app.DigiMatUIFigure,'Zoom factor must be > 0.','Invalid Input');
            return;
        end

        out = ZoomFunc(ImgIn, a);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Zoom (a=%g)', a));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: TranslateMenu_2
        function TranslateMenuSelected(app, event)
           try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg({'Enter x shift (a):','Enter y shift (b):'}, ...
                        'Input',[1,35],{'20','20'});
        if isempty(answ); return; end

        a = round(str2double(answ{1}));
        b = round(str2double(answ{2}));


        if isnan(a) || isnan(b)
            uialert(app.DigiMatUIFigure,'Shift values must be numbers.','Invalid Input');
            return;
        end

        out = TranslateFunc(ImgIn, a, b);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Translate (a=%g, b=%g)', a, b));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Menu selected function: RotateMenu
        function RotateMenuSelected(app, event)
            try
        ImgIn = app.ImgOriginal;
        if isempty(ImgIn)
            uialert(app.DigiMatUIFigure,'Load an image first (File → Load Image).','No Image');
            return;
        end

        answ = inputdlg({'Enter x center (a):','Enter y center (b):','Enter angle (deg):'}, ...
                        'Input',[1,35],{'100','100','45'});
        if isempty(answ); return; end

        a = str2double(answ{1});
        b = str2double(answ{2});
        angle = str2double(answ{3});

        if isnan(a) || isnan(b) || isnan(angle)
            uialert(app.DigiMatUIFigure,'a, b, angle must be numbers.','Invalid Input');
            return;
        end

        out = RotateFunc(ImgIn, a, b, angle);

        app.ImgResult = out;
        imshow(out,'Parent',app.UIAxesResult);
        title(app.UIAxesResult, sprintf('Rotate (a=%g, b=%g, angle=%g)', a, b, angle));

    catch ME
        app.TextArea.Value = getReport(ME);
    end
        end

        % Button pushed function: CopyResultButton
        function CopyResultButtonPushed(app, event)
           try
        if isempty(app.ImgResult)
            uialert(app.DigiMatUIFigure,'No result to copy yet. Apply an operation first.','No Result');
            return;
        end

        % Copy result -> original (now future operations use this)
        app.ImgOriginal = app.ImgResult;

        % Update Original axes
        imshow(app.ImgOriginal, 'Parent', app.UIAxesOriginal);
        title(app.UIAxesOriginal, 'Original (Copied from Result)');

        % Optional log
        if isprop(app,'TextArea')
            app.TextArea.Value = "Copied Result → Original. Next operations will use this new original.";
        end

    catch ME
        if isprop(app,'TextArea')
            app.TextArea.Value = getReport(ME);
        else
            uialert(app.DigiMatUIFigure, ME.message, 'Copy Error');
        end
    end 
        end

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
                LoadImageMenuSelected(app, event);

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DigiMatUIFigure and hide until all components are created
            app.DigiMatUIFigure = uifigure('Visible', 'off');
            app.DigiMatUIFigure.Position = [100 100 1108 720];
            app.DigiMatUIFigure.Name = 'DigiMat';
            app.DigiMatUIFigure.HandleVisibility = 'on';

            % Create FileMenu
            app.FileMenu = uimenu(app.DigiMatUIFigure);
            app.FileMenu.ForegroundColor = [0 0 1];
            app.FileMenu.Text = 'File';

            % Create LoadImageMenu
            app.LoadImageMenu = uimenu(app.FileMenu);
            app.LoadImageMenu.MenuSelectedFcn = createCallbackFcn(app, @LoadImageMenuSelected, true);
            app.LoadImageMenu.Text = 'Load Image';

            % Create SaveMenu
            app.SaveMenu = uimenu(app.FileMenu);
            app.SaveMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveMenuSelected, true);
            app.SaveMenu.Text = 'Save';

            % Create SaveAsMenu
            app.SaveAsMenu = uimenu(app.FileMenu);
            app.SaveAsMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveAsMenuSelected, true);
            app.SaveAsMenu.Text = 'Save As';

            % Create NoiseMenu_2
            app.NoiseMenu_2 = uimenu(app.DigiMatUIFigure);
            app.NoiseMenu_2.Text = 'Noise';

            % Create UniformMenu_2
            app.UniformMenu_2 = uimenu(app.NoiseMenu_2);
            app.UniformMenu_2.MenuSelectedFcn = createCallbackFcn(app, @UniformMenuSelected, true);
            app.UniformMenu_2.Text = 'Uniform';

            % Create SaltandPepperMenu_2
            app.SaltandPepperMenu_2 = uimenu(app.NoiseMenu_2);
            app.SaltandPepperMenu_2.MenuSelectedFcn = createCallbackFcn(app, @SaltandPepperMenuSelected, true);
            app.SaltandPepperMenu_2.Text = 'Salt and Pepper';

            % Create PointOperatorsMenu
            app.PointOperatorsMenu = uimenu(app.DigiMatUIFigure);
            app.PointOperatorsMenu.Text = 'Point Operators';

            % Create InversionMenu
            app.InversionMenu = uimenu(app.PointOperatorsMenu);
            app.InversionMenu.MenuSelectedFcn = createCallbackFcn(app, @InversionMenuSelected, true);
            app.InversionMenu.Text = 'Inversion';

            % Create BrightnessMenu_2
            app.BrightnessMenu_2 = uimenu(app.PointOperatorsMenu);
            app.BrightnessMenu_2.MenuSelectedFcn = createCallbackFcn(app, @BrightnessMenuSelected, true);
            app.BrightnessMenu_2.Text = 'Brightness';

            % Create ContrastMenu_3
            app.ContrastMenu_3 = uimenu(app.PointOperatorsMenu);
            app.ContrastMenu_3.MenuSelectedFcn = createCallbackFcn(app, @ContrastMenu_2Selected, true);
            app.ContrastMenu_3.Text = 'Contrast';

            % Create HistEqMenu_2
            app.HistEqMenu_2 = uimenu(app.PointOperatorsMenu);
            app.HistEqMenu_2.MenuSelectedFcn = createCallbackFcn(app, @HistEqMenuSelected, true);
            app.HistEqMenu_2.Text = 'Hist. Eq.';

            % Create FiltersMenu
            app.FiltersMenu = uimenu(app.DigiMatUIFigure);
            app.FiltersMenu.Text = 'Filters';

            % Create AverageMenu_2
            app.AverageMenu_2 = uimenu(app.FiltersMenu);
            app.AverageMenu_2.MenuSelectedFcn = createCallbackFcn(app, @AverageMenuSelected, true);
            app.AverageMenu_2.Text = 'Average';

            % Create MedianMenu_2
            app.MedianMenu_2 = uimenu(app.FiltersMenu);
            app.MedianMenu_2.MenuSelectedFcn = createCallbackFcn(app, @MedianMenuSelected, true);
            app.MedianMenu_2.Text = 'Median';

            % Create SegmentationMenu_2
            app.SegmentationMenu_2 = uimenu(app.DigiMatUIFigure);
            app.SegmentationMenu_2.Text = 'Segmentation';

            % Create ManualMenu_2
            app.ManualMenu_2 = uimenu(app.SegmentationMenu_2);
            app.ManualMenu_2.MenuSelectedFcn = createCallbackFcn(app, @ManualMenuSelected, true);
            app.ManualMenu_2.Text = 'Manual';

            % Create SemiAutoMenu_2
            app.SemiAutoMenu_2 = uimenu(app.SegmentationMenu_2);
            app.SemiAutoMenu_2.MenuSelectedFcn = createCallbackFcn(app, @SemiAutoMenuSelected, true);
            app.SemiAutoMenu_2.Text = 'Semi-Auto';

            % Create AutomatedMenu
            app.AutomatedMenu = uimenu(app.SegmentationMenu_2);
            app.AutomatedMenu.MenuSelectedFcn = createCallbackFcn(app, @AutomaticMenuSelected, true);
            app.AutomatedMenu.Text = 'Automated';

            % Create EdgeDetectionMenu_2
            app.EdgeDetectionMenu_2 = uimenu(app.DigiMatUIFigure);
            app.EdgeDetectionMenu_2.Text = 'Edge Detection';

            % Create SobelGradientMenu
            app.SobelGradientMenu = uimenu(app.EdgeDetectionMenu_2);
            app.SobelGradientMenu.MenuSelectedFcn = createCallbackFcn(app, @SobelMenuSelected, true);
            app.SobelGradientMenu.Text = 'Sobel Gradient';

            % Create KirschGradientMenu
            app.KirschGradientMenu = uimenu(app.EdgeDetectionMenu_2);
            app.KirschGradientMenu.MenuSelectedFcn = createCallbackFcn(app, @KirschMenuSelected, true);
            app.KirschGradientMenu.Text = 'Kirsch Gradient';

            % Create GeometricMenu_2
            app.GeometricMenu_2 = uimenu(app.DigiMatUIFigure);
            app.GeometricMenu_2.Text = 'Geometric';

            % Create ZoomMenu_2
            app.ZoomMenu_2 = uimenu(app.GeometricMenu_2);
            app.ZoomMenu_2.MenuSelectedFcn = createCallbackFcn(app, @ZoomMenuSelected, true);
            app.ZoomMenu_2.Text = 'Zoom';

            % Create TranslateMenu_2
            app.TranslateMenu_2 = uimenu(app.GeometricMenu_2);
            app.TranslateMenu_2.MenuSelectedFcn = createCallbackFcn(app, @TranslateMenuSelected, true);
            app.TranslateMenu_2.Text = 'Translate';

            % Create RotateMenu
            app.RotateMenu = uimenu(app.GeometricMenu_2);
            app.RotateMenu.MenuSelectedFcn = createCallbackFcn(app, @RotateMenuSelected, true);
            app.RotateMenu.Text = 'Rotate';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.DigiMatUIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxesOriginal
            app.UIAxesOriginal = uiaxes(app.GridLayout);
            title(app.UIAxesOriginal, 'Title')
            xlabel(app.UIAxesOriginal, 'X')
            ylabel(app.UIAxesOriginal, 'Y')
            zlabel(app.UIAxesOriginal, 'Z')
            app.UIAxesOriginal.Layout.Row = [2 7];
            app.UIAxesOriginal.Layout.Column = [1 2];

            % Create UIAxesResult
            app.UIAxesResult = uiaxes(app.GridLayout);
            title(app.UIAxesResult, 'Title')
            xlabel(app.UIAxesResult, 'X')
            ylabel(app.UIAxesResult, 'Y')
            zlabel(app.UIAxesResult, 'Z')
            app.UIAxesResult.Layout.Row = [2 7];
            app.UIAxesResult.Layout.Column = [3 4];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = [10 11];
            app.TabGroup.Layout.Column = [1 5];

            % Create MessageTab
            app.MessageTab = uitab(app.TabGroup);
            app.MessageTab.Title = 'Message';

            % Create TextArea
            app.TextArea = uitextarea(app.MessageTab);
            app.TextArea.Position = [1 -71 1088 153];

            % Create CopyResultButton
            app.CopyResultButton = uibutton(app.GridLayout, 'push');
            app.CopyResultButton.ButtonPushedFcn = createCallbackFcn(app, @CopyResultButtonPushed, true);
            app.CopyResultButton.BackgroundColor = [0.902 0.902 0.902];
            app.CopyResultButton.Layout.Row = 8;
            app.CopyResultButton.Layout.Column = [3 4];
            app.CopyResultButton.Text = 'Copy Result to Image';

            % Create CopyInfoLabel
            app.CopyInfoLabel = uilabel(app.GridLayout);
            app.CopyInfoLabel.HorizontalAlignment = 'center';
            app.CopyInfoLabel.FontWeight = 'bold';
            app.CopyInfoLabel.Layout.Row = 9;
            app.CopyInfoLabel.Layout.Column = [3 4];
            app.CopyInfoLabel.Text = {'              Press above button to use the Resultant Image for Next Operation'; ''};

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.GridLayout, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.BackgroundColor = [0.8 0.8 0.8];
            app.LoadImageButton.Layout.Row = 8;
            app.LoadImageButton.Layout.Column = [1 2];
            app.LoadImageButton.Text = 'Load New Image';

            % Create LoadInfoLabel
            app.LoadInfoLabel = uilabel(app.GridLayout);
            app.LoadInfoLabel.FontWeight = 'bold';
            app.LoadInfoLabel.Layout.Row = 9;
            app.LoadInfoLabel.Layout.Column = [1 2];
            app.LoadInfoLabel.Text = '                                              Press to load a new image';

            % Show the figure after all components are created
            app.DigiMatUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DigiMat3_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DigiMatUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DigiMatUIFigure)
        end
    end
end