classdef uwu_player < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        uwuplayer                   matlab.ui.Figure
        TimeEditField               matlab.ui.control.EditField
        DateEditField               matlab.ui.control.EditField
        Panel                       matlab.ui.container.Panel
        Play                        matlab.ui.control.Button
        Stop                        matlab.ui.control.Button
        Pause                       matlab.ui.control.Button
        Resume                      matlab.ui.control.Button
        skipleft                    matlab.ui.control.Button
        skipright                   matlab.ui.control.Button
        VOLUMESliderLabel           matlab.ui.control.Label
        Volume                      matlab.ui.control.Slider
        Value_Volume                matlab.ui.control.EditField
        seekbar                     matlab.ui.control.Slider
        Seekbarddisplay             matlab.ui.control.EditField
        BrowseButton                matlab.ui.control.Button
        FilenameEditFieldLabel      matlab.ui.control.Label
        FilenameEditField           matlab.ui.control.EditField
        ControlPanel                matlab.ui.container.Panel
        TimeDomain                  matlab.ui.control.Button
        FrequenyDomain              matlab.ui.control.Button
        right                       matlab.ui.control.Button
        left                        matlab.ui.control.Button
        F_domain_filter             matlab.ui.control.Button
        Information_audio           matlab.ui.container.Panel
        SamplingFrequencyEditFieldLabel  matlab.ui.control.Label
        SamplingFrequencyEditField  matlab.ui.control.EditField
        RecordedTimeEditFieldLabel  matlab.ui.control.Label
        RecordedTimeEditField       matlab.ui.control.EditField
        Graphs                      matlab.ui.container.Panel
        UIAxes                      matlab.ui.control.UIAxes
        UIAxes_2                    matlab.ui.control.UIAxes
        Equalizer                   matlab.ui.container.Panel
        Label_4                     matlab.ui.control.Label
        Label_3                     matlab.ui.control.Label
        Label_2                     matlab.ui.control.Label
        Label                       matlab.ui.control.Label
        Band05                      matlab.ui.control.Slider
        Band04                      matlab.ui.control.Slider
        Band03                      matlab.ui.control.Slider
        Band02                      matlab.ui.control.Slider
        Band01                      matlab.ui.control.Slider
        Hz1kHzLabel                 matlab.ui.control.Label
        kHz3kHzLabel                matlab.ui.control.Label
        kHz6kHzLabel                matlab.ui.control.Label
        kHz12kHzLabel               matlab.ui.control.Label
        kHz14kHzLabel               matlab.ui.control.Label
        dbLabel                     matlab.ui.control.Label
        dbLabel_2                   matlab.ui.control.Label
        dbLabel_3                   matlab.ui.control.Label
        dbLabel_4                   matlab.ui.control.Label
        dbLabel_5                   matlab.ui.control.Label
        dbLabel_6                   matlab.ui.control.Label
        dbLabel_7                   matlab.ui.control.Label
        dbLabel_8                   matlab.ui.control.Label
        dbLabel_9                   matlab.ui.control.Label
        dbLabel_10                  matlab.ui.control.Label
        B1disp                      matlab.ui.control.EditField
        B2disp                      matlab.ui.control.EditField
        B3disp                      matlab.ui.control.EditField
        B4disp                      matlab.ui.control.EditField
        B5disp                      matlab.ui.control.EditField
        AboutMeButton               matlab.ui.control.Button
        ResetButton                 matlab.ui.control.Button
        Image                       matlab.ui.control.Image
        Button                      matlab.ui.control.Button
    end

    
    properties (Access = private)
        fs % Description
        audio
        fs1
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           app.B1disp.Value=num2str(app.Band01.Value);
           app.B2disp.Value=num2str(app.Band02.Value);
           app.B3disp.Value=num2str(app.Band03.Value);
           app.B4disp.Value=num2str(app.Band04.Value);
           app.B5disp.Value=num2str(app.Band05.Value);
           app.Volume.Value=100;
    
            app.Value_Volume.Value=num2str(100);
           while isvalid(app)
                app.DateEditField.Value=datestr(now, "dd/mm/yy");
                app.TimeEditField.Value=datestr(now, "HH:MM");
                pause(1);
           end
        
        end

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            
            
            [file,path]=uigetfile({'*.mp3';'*.wav';'*.wma';'*.flac'});
            if file==0
                errordlg("No File Selected",'Error!');     
            else
                [app.audio,app.fs]=audioread(strcat(path,file));
                app.FilenameEditField.Value=file;
                app.SamplingFrequencyEditField.Value=num2str(app.fs);
                app.RecordedTimeEditField.Value=datestr(seconds(length(app.audio)/app.fs),'MM:SS');
            end
        end

        % Button pushed function: Stop
        function StopButtonPushed(app, event)
            global player;
            
            
            stop(player);
            app.Seekbarddisplay.Value=datestr(seconds(length(app.audio)/app.fs),"MM:SS");
            app.seekbar.Value=0;
        end

        % Value changing function: Volume
        function VolumeValueChanging(app, event)
            
            
            global player;
            vol=floor(event.Value);
            app.Value_Volume.Value=num2str(vol);
            CS=player.CurrentSample;
            if isplaying(player)
                player=audioplayer(app.audio*vol/100,app.fs);
                play(player,CS);
            end
            
        end

        % Close request function: uwuplayer
        function uwuplayerCloseRequest(app, event)
            user_ans=questdlg("Are you Sure you want to leave me?","Close UwU Player");
            if user_ans == "Yes"
                clear global;
                delete(app);
            end
             
        end

        % Button pushed function: Play
        function PlayPushed(app, event)
            
            
            global player;
            
            app.seekbar.Limits=[0,length(app.audio)/app.fs];
            player=audioplayer(app.audio,app.fs);
            play(player);
            
           for i=length(app.audio)/app.fs:-1:0
               if isplaying(player)
                    app.Seekbarddisplay.Value=datestr(seconds(i),"MM:SS");
                    app.seekbar.Value=(length(app.audio)/app.fs)-i;
                    pause(1);
               else
                   break;
               end
           end

            
            
            
        end

        % Button pushed function: Resume
        function ResumePushed(app, event)
            global player;
            
            
            resume(player);
            for j=app.seekbar.Value:length(app.audio)/app.fs
                if isplaying(player)
                    app.Seekbarddisplay.Value=datestr(seconds(length(app.audio)/app.fs-j),"MM:SS");
                    app.seekbar.Value=j;
                    pause(1);
                else
                    break;
                end
            end
            
        end

        % Button pushed function: Pause
        function PausePushed(app, event)
            
            pause(player);
        end

        % Button pushed function: skipright
        function skiprightButtonPushed(app, event)
            
         global CS;   
            global player;
          
            CS=player.CurrentSample;
            if isplaying(player)
                stop(player);
                play(player,app.fs*5+CS);
                for i=app.seekbar.Value+5:length(app.audio)/app.fs
                    if isplaying(player)
                        app.Seekbarddisplay.Value=datestr((seconds(length(app.audio)/app.fs-i-5)+5),"MM:SS");
                        app.seekbar.Value=i;
                    else
                        break;
                    end
                end
            end
        end

        % Button pushed function: skipleft
        function skipleftButtonPushed(app, event)
            
            global player;
            global CS;
            

            CS=player.CurrentSample;
            if isplaying(player)
                stop(player);
                play(player,CS-app.fs*5);
                for i=app.seekbar.Value-5:length(app.audio)/app.fs
                    if isplaying(player)
                        app.Seekbarddisplay.Value=datestr((seconds(length(app.audio)/app.fs-i+5)-5),"MM:SS");
                        app.seekbar.Value=i;
                        pause(1);
                    else
                        break;
                    end
                end
            end
        end

        % Button pushed function: TimeDomain
        function TimeDomainPushed(app, event)
        
        rt=length(app.audio)/app.fs;
        t=0:1/app.fs:rt-1/app.fs;
        plot(app.UIAxes,t,app.audio);
        end

        % Button pushed function: FrequenyDomain
        function FrequenyDomainPushed(app, event)
            
            
            
            global magF1;
            global f1;


            f1=linspace(0,app.fs/2,length(app.audio)/2);
            magF1=abs(fft(app.audio)*2/length(app.audio));
            stem(app.UIAxes_2,f1,magF1(1:length(magF1)/2));
            
        end

        % Button pushed function: left
        function leftPushed(app, event)
            
            
            rt=length(app.audio)/app.fs;
            t=0:1/app.fs:rt-1/app.fs;
            plot(app.UIAxes,t,app.audio(:,1));
        end

        % Button pushed function: right
        function rightPushed(app, event)
            
            
            rt=length(app.audio)/app.fs;
            t=0:1/app.fs:rt-1/app.fs;
            plot(app.UIAxes,t,app.audio(:,2));
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)

           app.FilenameEditField.Value=" ";
           app.seekbar.Value=0;
           app.Seekbarddisplay.Value=" ";
           app.SamplingFrequencyEditField.Value=" ";
           app.RecordedTimeEditField.Value=" ";
           app.Band02.Value=0;
           app.Band01.Value=0;
           app.Band03.Value=0;
           app.Band04.Value=0;
           app.Band05.Value=0;
           app.B1disp.Value=num2str(app.Band01.Value);
           app.B2disp.Value=num2str(app.Band02.Value);
           app.B3disp.Value=num2str(app.Band03.Value);
           app.B4disp.Value=num2str(app.Band04.Value);
           app.B5disp.Value=num2str(app.Band05.Value);
           cla(app.UIAxes)
           cla(app.UIAxes_2)
           clearvars
           clear global          
        end

        % Button pushed function: AboutMeButton
        function AboutMeButtonPushed(app, event)
            [icondata,iconmap]=imread('icon.png');
msgbox({'Im Toheed from electronics department, owner of UwU_player.';
    'UwU_player is made by Toheed as a problem based learning task in his digital signal processing lab. This app plays app.audio and and plots the app.audio being played in time and frequency domain. It has an app.audioequalizer with 5 bands implemented using fir window'
' ';' ';' ';'Email: 20-enc-46@students.uettaxila.edu.pk'},....    
'About Me','custom',....
    icondata,iconmap);
        end

        % Value changed function: Band01
        function filter1(app, event)
        


global player;

global audio_filtered;
app.B1disp.Value=num2str(event.Value);

% Define the filter parameters
N    = 90;       % Order
Fc1  = 500;      % First Cutoff Frequency
Fc2  = 1100;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hann(N+1);

% Calculate the gain factor based on the slider value
gain_dB = event.Value;
gain_factor = 10^(gain_dB/20); % convert dB to linear scale

% Calculate the filter coefficients using the FIR1 function and apply the gain factor
b = gain_factor * fir1(N, [Fc1 Fc2]/(app.fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% Apply the filter with variable gain to an input signal 'app.audio'
F1 = filter(Hd, app.audio);

audio_filtered = F1 + app.audio;

% Update the app.audio player with the filtered signal
CS = player.CurrentSample;
if isplaying(player)
    player = audioplayer(audio_filtered, app.fs);
    play(player, CS);
end


        end

        % Value changed function: Band02
        function filter2(app, event)
 

global player;
global F2;
global audio_filtered;
app.B2disp.Value=num2str(event.Value);

% Define the filter parameters
N    = 90;       % Order
Fc1  = 900;      % First Cutoff Frequency
Fc2  = 2900;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hann(N+1);


% Calculate the gain factor based on the slider value
gain_dB = event.Value;
gain_factor = 10^(gain_dB/20); % convert dB to linear scale

% Calculate the filter coefficients using the FIR1 function and apply the gain factor
b = gain_factor * fir1(N, [Fc1 Fc2]/(app.fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% Apply the filter with variable gain to an input signal 'app.audio'
F2 = filter(Hd, app.audio);
audio_filtered = F2 + app.audio;

CS = player.CurrentSample;
if isplaying(player)
    player = audioplayer(audio_filtered, app.fs);
    play(player, CS);
end

            
        end

        % Value changed function: Band03
        function filter3(app, event)


global player;
global audio_filtered;
global  F3 ;
app.B3disp.Value=num2str(event.Value);

% Define the filter parameters
N    = 90;       % Order
Fc1  = 2900;      % First Cutoff Frequency
Fc2  = 5900;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hann(N+1);

% Calculate the gain factor based on the slider value
gain_dB = event.Value;
gain_factor = 10^(gain_dB/20); % convert dB to linear scale

% Calculate the filter coefficients using the FIR1 function and apply the gain factor
b = gain_factor * fir1(N, [Fc1 Fc2]/(app.fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% Apply the filter with variable gain to an input signal 'app.audio'
F3 = filter(Hd, app.audio);
audio_filtered = F3 + app.audio;

CS = player.CurrentSample;
if isplaying(player)
    player = audioplayer(audio_filtered, app.fs);
    play(player, CS);
end
   
        end

        % Value changed function: Band04
        function filter4(app, event)
 

global player;
global F4;
global audio_filtered;
app.B4disp.Value=num2str(event.Value);

% Define the filter parameters
N    = 90;       % Order
Fc1  = 5900;      % First Cutoff Frequency
Fc2  = 11900;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hann(N+1);


% Calculate the gain factor based on the slider value
gain_dB = event.Value;
gain_factor = 10^(gain_dB/20); % convert dB to linear scale

% Calculate the filter coefficients using the FIR1 function and apply the gain factor
b = gain_factor * fir1(N, [Fc1 Fc2]/(app.fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% Apply the filter with variable gain to an input signal 'app.audio'
F4 = filter(Hd, app.audio);
audio_filtered = F4 + app.audio;


CS = player.CurrentSample;
if isplaying(player)
    player = audioplayer(audio_filtered, app.fs);
    play(player, CS);
end
      
        end

        % Value changed function: Band05
        function filter5(app, event)


global player;
global  F5;
global audio_filtered;
app.B5disp.Value=num2str(event.Value);

% Define the filter parameters
N    = 50;       % Order
Fc1  = 11900;      % First Cutoff Frequency
Fc2  = 13900;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hann(N+1);


% Calculate the gain factor based on the slider value
gain_dB = event.Value;
gain_factor = 10^(gain_dB/20); % convert dB to linear scale

% Calculate the filter coefficients using the FIR1 function and apply the gain factor
b = gain_factor * fir1(N, [Fc1 Fc2]/(app.fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% Apply the filter with variable gain to an input signal 'app.audio'
F5 = filter(Hd, app.audio);
audio_filtered = F5 + app.audio;

CS = player.CurrentSample;
if isplaying(player)
    player = audioplayer(audio_filtered, app.fs);
    play(player, CS);
end
  
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            
            global player1
            

                [app.audio1,app.fs1]=app.audioread('uwu.mp3');
                player1=audioplayer(app.audio1,app.fs1);
                play(player1);
%             end
            
        end

        % Button pushed function: F_domain_filter
        function F_domain_filterButtonPushed(app, event)
         
            
            global audio_filtered
            global magF2;
            global f2;
            

            f2=linspace(0,app.fs/2,length(audio_filtered)/2);
            magF2=abs(fft(audio_filtered)*2/length(audio_filtered));
            stem(app.UIAxes_2,f2,magF2(1:length(magF2)/2));
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create uwuplayer and hide until all components are created
            app.uwuplayer = uifigure('Visible', 'off');
            app.uwuplayer.Color = [1 1 1];
            app.uwuplayer.Position = [100 100 1521 794];
            app.uwuplayer.Name = 'uwu_player';
            app.uwuplayer.CloseRequestFcn = createCallbackFcn(app, @uwuplayerCloseRequest, true);
            app.uwuplayer.WindowState = 'maximized';

            % Create TimeEditField
            app.TimeEditField = uieditfield(app.uwuplayer, 'text');
            app.TimeEditField.HorizontalAlignment = 'center';
            app.TimeEditField.FontSize = 14;
            app.TimeEditField.FontColor = [1 0.0745 0.651];
            app.TimeEditField.Position = [19 739 100 22];

            % Create DateEditField
            app.DateEditField = uieditfield(app.uwuplayer, 'text');
            app.DateEditField.HorizontalAlignment = 'center';
            app.DateEditField.FontSize = 14;
            app.DateEditField.FontColor = [1 0.0745 0.651];
            app.DateEditField.Position = [121 739 100 22];

            % Create Panel
            app.Panel = uipanel(app.uwuplayer);
            app.Panel.ForegroundColor = [1 1 1];
            app.Panel.BorderType = 'none';
            app.Panel.TitlePosition = 'centertop';
            app.Panel.BackgroundColor = [1 0.0745 0.651];
            app.Panel.FontName = 'Times New Roman';
            app.Panel.FontWeight = 'bold';
            app.Panel.FontSize = 16;
            app.Panel.Position = [18 407 833 108];

            % Create Play
            app.Play = uibutton(app.Panel, 'push');
            app.Play.ButtonPushedFcn = createCallbackFcn(app, @PlayPushed, true);
            app.Play.FontWeight = 'bold';
            app.Play.Position = [337 55 91 40];
            app.Play.Text = 'PLAY';

            % Create Stop
            app.Stop = uibutton(app.Panel, 'push');
            app.Stop.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.Stop.FontWeight = 'bold';
            app.Stop.Position = [656 52 91 40];
            app.Stop.Text = 'STOP';

            % Create Pause
            app.Pause = uibutton(app.Panel, 'push');
            app.Pause.ButtonPushedFcn = createCallbackFcn(app, @PausePushed, true);
            app.Pause.FontWeight = 'bold';
            app.Pause.Position = [439 55 91 40];
            app.Pause.Text = 'PAUSE';

            % Create Resume
            app.Resume = uibutton(app.Panel, 'push');
            app.Resume.ButtonPushedFcn = createCallbackFcn(app, @ResumePushed, true);
            app.Resume.FontWeight = 'bold';
            app.Resume.Position = [547 54 91 40];
            app.Resume.Text = 'RESUME';

            % Create skipleft
            app.skipleft = uibutton(app.Panel, 'push');
            app.skipleft.ButtonPushedFcn = createCallbackFcn(app, @skipleftButtonPushed, true);
            app.skipleft.FontWeight = 'bold';
            app.skipleft.Tooltip = {'Move 5 sec backward'};
            app.skipleft.Position = [224 54 49 40];
            app.skipleft.Text = '<<';

            % Create skipright
            app.skipright = uibutton(app.Panel, 'push');
            app.skipright.ButtonPushedFcn = createCallbackFcn(app, @skiprightButtonPushed, true);
            app.skipright.FontWeight = 'bold';
            app.skipright.Tooltip = {'Move 5sec forward'};
            app.skipright.Position = [767 53 45 40];
            app.skipright.Text = '>>';

            % Create VOLUMESliderLabel
            app.VOLUMESliderLabel = uilabel(app.Panel);
            app.VOLUMESliderLabel.HorizontalAlignment = 'right';
            app.VOLUMESliderLabel.FontColor = [1 1 1];
            app.VOLUMESliderLabel.Position = [30 18 56 22];
            app.VOLUMESliderLabel.Text = 'VOLUME';

            % Create Volume
            app.Volume = uislider(app.Panel);
            app.Volume.MajorTicks = [];
            app.Volume.ValueChangingFcn = createCallbackFcn(app, @VolumeValueChanging, true);
            app.Volume.MinorTicks = [];
            app.Volume.Position = [34 44 123 3];

            % Create Value_Volume
            app.Value_Volume = uieditfield(app.Panel, 'text');
            app.Value_Volume.Editable = 'off';
            app.Value_Volume.HorizontalAlignment = 'center';
            app.Value_Volume.FontColor = [1 1 1];
            app.Value_Volume.Position = [168 34 35 22];

            % Create seekbar
            app.seekbar = uislider(app.Panel);
            app.seekbar.MajorTicks = [];
            app.seekbar.MinorTicks = [];
            app.seekbar.FontColor = [1 1 1];
            app.seekbar.Position = [229 43 577 3];

            % Create Seekbarddisplay
            app.Seekbarddisplay = uieditfield(app.Panel, 'text');
            app.Seekbarddisplay.Editable = 'off';
            app.Seekbarddisplay.HorizontalAlignment = 'center';
            app.Seekbarddisplay.FontColor = [1 1 1];
            app.Seekbarddisplay.Position = [490 13 56 22];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.uwuplayer, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.FontWeight = 'bold';
            app.BrowseButton.Position = [1271 729 91 40];
            app.BrowseButton.Text = 'Browse';

            % Create FilenameEditFieldLabel
            app.FilenameEditFieldLabel = uilabel(app.uwuplayer);
            app.FilenameEditFieldLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FilenameEditFieldLabel.HorizontalAlignment = 'right';
            app.FilenameEditFieldLabel.FontSize = 14;
            app.FilenameEditFieldLabel.Position = [981 738 63 22];
            app.FilenameEditFieldLabel.Text = 'Filename';

            % Create FilenameEditField
            app.FilenameEditField = uieditfield(app.uwuplayer, 'text');
            app.FilenameEditField.FontSize = 14;
            app.FilenameEditField.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FilenameEditField.Position = [1059 738 205 22];

            % Create ControlPanel
            app.ControlPanel = uipanel(app.uwuplayer);
            app.ControlPanel.ForegroundColor = [1 1 1];
            app.ControlPanel.TitlePosition = 'centertop';
            app.ControlPanel.Title = 'Control Panel';
            app.ControlPanel.BackgroundColor = [1 0.0745 0.651];
            app.ControlPanel.FontName = 'Times New Roman';
            app.ControlPanel.FontSize = 16;
            app.ControlPanel.Position = [635 12 218 205];

            % Create TimeDomain
            app.TimeDomain = uibutton(app.ControlPanel, 'push');
            app.TimeDomain.ButtonPushedFcn = createCallbackFcn(app, @TimeDomainPushed, true);
            app.TimeDomain.FontWeight = 'bold';
            app.TimeDomain.FontColor = [1 0.0745 0.651];
            app.TimeDomain.Position = [15 134 196 40];
            app.TimeDomain.Text = 'Time Domain';

            % Create FrequenyDomain
            app.FrequenyDomain = uibutton(app.ControlPanel, 'push');
            app.FrequenyDomain.ButtonPushedFcn = createCallbackFcn(app, @FrequenyDomainPushed, true);
            app.FrequenyDomain.FontWeight = 'bold';
            app.FrequenyDomain.FontColor = [1 0.0745 0.651];
            app.FrequenyDomain.Position = [5 84 115 40];
            app.FrequenyDomain.Text = {'F.domain'; '(normal)'};

            % Create right
            app.right = uibutton(app.ControlPanel, 'push');
            app.right.ButtonPushedFcn = createCallbackFcn(app, @rightPushed, true);
            app.right.FontWeight = 'bold';
            app.right.FontColor = [1 0.0745 0.651];
            app.right.Position = [117 28 94 40];
            app.right.Text = 'RIGHT';

            % Create left
            app.left = uibutton(app.ControlPanel, 'push');
            app.left.ButtonPushedFcn = createCallbackFcn(app, @leftPushed, true);
            app.left.FontWeight = 'bold';
            app.left.FontColor = [1 0.0745 0.651];
            app.left.Position = [15 28 95 40];
            app.left.Text = 'LEFT ';

            % Create F_domain_filter
            app.F_domain_filter = uibutton(app.ControlPanel, 'push');
            app.F_domain_filter.ButtonPushedFcn = createCallbackFcn(app, @F_domain_filterButtonPushed, true);
            app.F_domain_filter.FontWeight = 'bold';
            app.F_domain_filter.FontColor = [1 0.0745 0.651];
            app.F_domain_filter.Position = [116 84 96 40];
            app.F_domain_filter.Text = {'F.domain'; '(filtered)'};

            % Create Information_audio
            app.Information_audio = uipanel(app.uwuplayer);
            app.Information_audio.ForegroundColor = [1 1 1];
            app.Information_audio.TitlePosition = 'centertop';
            app.Information_audio.Title = 'Audio Information';
            app.Information_audio.BackgroundColor = [1 0.0745 0.651];
            app.Information_audio.FontName = 'Times New Roman';
            app.Information_audio.FontSize = 16;
            app.Information_audio.Position = [636 231 217 164];

            % Create SamplingFrequencyEditFieldLabel
            app.SamplingFrequencyEditFieldLabel = uilabel(app.Information_audio);
            app.SamplingFrequencyEditFieldLabel.BackgroundColor = [1 0 1];
            app.SamplingFrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.SamplingFrequencyEditFieldLabel.FontColor = [1 1 1];
            app.SamplingFrequencyEditFieldLabel.Position = [12 105 116 22];
            app.SamplingFrequencyEditFieldLabel.Text = 'Sampling Frequency';

            % Create SamplingFrequencyEditField
            app.SamplingFrequencyEditField = uieditfield(app.Information_audio, 'text');
            app.SamplingFrequencyEditField.HorizontalAlignment = 'center';
            app.SamplingFrequencyEditField.BackgroundColor = [1 0 1];
            app.SamplingFrequencyEditField.Position = [135 105 75 22];

            % Create RecordedTimeEditFieldLabel
            app.RecordedTimeEditFieldLabel = uilabel(app.Information_audio);
            app.RecordedTimeEditFieldLabel.BackgroundColor = [1 0 1];
            app.RecordedTimeEditFieldLabel.HorizontalAlignment = 'center';
            app.RecordedTimeEditFieldLabel.FontColor = [1 1 1];
            app.RecordedTimeEditFieldLabel.Position = [12 69 87 22];
            app.RecordedTimeEditFieldLabel.Text = 'Recorded Time';

            % Create RecordedTimeEditField
            app.RecordedTimeEditField = uieditfield(app.Information_audio, 'text');
            app.RecordedTimeEditField.HorizontalAlignment = 'center';
            app.RecordedTimeEditField.FontColor = [1 1 1];
            app.RecordedTimeEditField.BackgroundColor = [1 0 1];
            app.RecordedTimeEditField.Position = [134 69 75 22];

            % Create Graphs
            app.Graphs = uipanel(app.uwuplayer);
            app.Graphs.ForegroundColor = [1 1 1];
            app.Graphs.BorderType = 'none';
            app.Graphs.TitlePosition = 'centertop';
            app.Graphs.Title = 'Audio Graph';
            app.Graphs.BackgroundColor = [1 0.0745 0.651];
            app.Graphs.FontName = 'Times New Roman';
            app.Graphs.FontSize = 16;
            app.Graphs.Position = [861 11 661 677];

            % Create UIAxes
            app.UIAxes = uiaxes(app.Graphs);
            title(app.UIAxes, 'Time Domain ')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.FontSize = 14;
            app.UIAxes.GridColor = [0 0 0];
            app.UIAxes.XColor = [1 1 1];
            app.UIAxes.YColor = [1 1 1];
            app.UIAxes.Position = [27 354 613 290];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.Graphs);
            title(app.UIAxes_2, 'Frequency Domain')
            xlabel(app.UIAxes_2, 'Frequency')
            ylabel(app.UIAxes_2, 'Magnitude')
            app.UIAxes_2.FontSize = 14;
            app.UIAxes_2.XLim = [0 22050];
            app.UIAxes_2.GridColor = [0.15 0.15 0.15];
            app.UIAxes_2.XColor = [1 1 1];
            app.UIAxes_2.YColor = [1 1 1];
            app.UIAxes_2.Position = [24 21 613 296];

            % Create Equalizer
            app.Equalizer = uipanel(app.uwuplayer);
            app.Equalizer.ForegroundColor = [1 1 1];
            app.Equalizer.BorderType = 'none';
            app.Equalizer.TitlePosition = 'centertop';
            app.Equalizer.BackgroundColor = [1 0.0745 0.651];
            app.Equalizer.FontName = 'Times New Roman';
            app.Equalizer.FontSize = 16;
            app.Equalizer.Position = [20 11 606 384];

            % Create Label_4
            app.Label_4 = uilabel(app.Equalizer);
            app.Label_4.HorizontalAlignment = 'right';
            app.Label_4.FontWeight = 'bold';
            app.Label_4.Position = [174 76 25 22];
            app.Label_4.Text = '';

            % Create Label_3
            app.Label_3 = uilabel(app.Equalizer);
            app.Label_3.HorizontalAlignment = 'right';
            app.Label_3.FontWeight = 'bold';
            app.Label_3.Position = [336 112 25 22];
            app.Label_3.Text = '';

            % Create Label_2
            app.Label_2 = uilabel(app.Equalizer);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [450 116 25 22];
            app.Label_2.Text = '';

            % Create Label
            app.Label = uilabel(app.Equalizer);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontWeight = 'bold';
            app.Label.Position = [568 114 25 22];
            app.Label.Text = '';

            % Create Band05
            app.Band05 = uislider(app.Equalizer);
            app.Band05.Limits = [-20 20];
            app.Band05.MajorTicks = [-20 -16 -12 -8 -4 0 4 8 12 16 20];
            app.Band05.MajorTickLabels = {'-20', '-16', '-12', '-8', '-4', '0', '4', '8', '12', '16', '20'};
            app.Band05.Orientation = 'vertical';
            app.Band05.ValueChangedFcn = createCallbackFcn(app, @filter5, true);
            app.Band05.MinorTicks = [-20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
            app.Band05.FontWeight = 'bold';
            app.Band05.Position = [496 130 3 220];

            % Create Band04
            app.Band04 = uislider(app.Equalizer);
            app.Band04.Limits = [-20 20];
            app.Band04.Orientation = 'vertical';
            app.Band04.ValueChangedFcn = createCallbackFcn(app, @filter4, true);
            app.Band04.MinorTicks = [-20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
            app.Band04.FontWeight = 'bold';
            app.Band04.Position = [394 132 3 216];

            % Create Band03
            app.Band03 = uislider(app.Equalizer);
            app.Band03.Limits = [-20 20];
            app.Band03.Orientation = 'vertical';
            app.Band03.ValueChangedFcn = createCallbackFcn(app, @filter3, true);
            app.Band03.MinorTicks = [-20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
            app.Band03.FontWeight = 'bold';
            app.Band03.Position = [280 128 3 220];

            % Create Band02
            app.Band02 = uislider(app.Equalizer);
            app.Band02.Limits = [-20 20];
            app.Band02.Orientation = 'vertical';
            app.Band02.ValueChangedFcn = createCallbackFcn(app, @filter2, true);
            app.Band02.MinorTicks = [-20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
            app.Band02.FontWeight = 'bold';
            app.Band02.Position = [144 128 3 220];

            % Create Band01
            app.Band01 = uislider(app.Equalizer);
            app.Band01.Limits = [-20 20];
            app.Band01.Orientation = 'vertical';
            app.Band01.ValueChangedFcn = createCallbackFcn(app, @filter1, true);
            app.Band01.MinorTicks = [-20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
            app.Band01.FontWeight = 'bold';
            app.Band01.Position = [30 132 3 220];

            % Create Hz1kHzLabel
            app.Hz1kHzLabel = uilabel(app.Equalizer);
            app.Hz1kHzLabel.FontColor = [1 1 1];
            app.Hz1kHzLabel.Position = [8 41 72 22];
            app.Hz1kHzLabel.Text = '600Hz-1kHz';

            % Create kHz3kHzLabel
            app.kHz3kHzLabel = uilabel(app.Equalizer);
            app.kHz3kHzLabel.FontColor = [1 1 1];
            app.kHz3kHzLabel.Position = [123 41 64 22];
            app.kHz3kHzLabel.Text = '1kHz-3kHz';

            % Create kHz6kHzLabel
            app.kHz6kHzLabel = uilabel(app.Equalizer);
            app.kHz6kHzLabel.FontColor = [1 1 1];
            app.kHz6kHzLabel.Position = [262 41 64 22];
            app.kHz6kHzLabel.Text = '3kHz-6kHz';

            % Create kHz12kHzLabel
            app.kHz12kHzLabel = uilabel(app.Equalizer);
            app.kHz12kHzLabel.FontColor = [1 1 1];
            app.kHz12kHzLabel.Position = [373 41 71 22];
            app.kHz12kHzLabel.Text = '6kHz-12kHz';

            % Create kHz14kHzLabel
            app.kHz14kHzLabel = uilabel(app.Equalizer);
            app.kHz14kHzLabel.FontColor = [1 1 1];
            app.kHz14kHzLabel.Position = [479 41 78 22];
            app.kHz14kHzLabel.Text = '12kHz-14kHz';

            % Create dbLabel
            app.dbLabel = uilabel(app.Equalizer);
            app.dbLabel.FontColor = [1 1 1];
            app.dbLabel.Position = [25 96 36 22];
            app.dbLabel.Text = '-20db';

            % Create dbLabel_2
            app.dbLabel_2 = uilabel(app.Equalizer);
            app.dbLabel_2.FontColor = [1 1 1];
            app.dbLabel_2.Position = [24 354 39 22];
            app.dbLabel_2.Text = '+20db';

            % Create dbLabel_3
            app.dbLabel_3 = uilabel(app.Equalizer);
            app.dbLabel_3.FontColor = [1 1 1];
            app.dbLabel_3.Position = [140 92 36 22];
            app.dbLabel_3.Text = '-20db';

            % Create dbLabel_4
            app.dbLabel_4 = uilabel(app.Equalizer);
            app.dbLabel_4.FontColor = [1 1 1];
            app.dbLabel_4.Position = [135 354 39 22];
            app.dbLabel_4.Text = '+20db';

            % Create dbLabel_5
            app.dbLabel_5 = uilabel(app.Equalizer);
            app.dbLabel_5.FontColor = [1 1 1];
            app.dbLabel_5.Position = [275 95 36 22];
            app.dbLabel_5.Text = '-20db';

            % Create dbLabel_6
            app.dbLabel_6 = uilabel(app.Equalizer);
            app.dbLabel_6.FontColor = [1 1 1];
            app.dbLabel_6.Position = [273 354 39 22];
            app.dbLabel_6.Text = '+20db';

            % Create dbLabel_7
            app.dbLabel_7 = uilabel(app.Equalizer);
            app.dbLabel_7.FontColor = [1 1 1];
            app.dbLabel_7.Position = [479 91 36 22];
            app.dbLabel_7.Text = '-20db';

            % Create dbLabel_8
            app.dbLabel_8 = uilabel(app.Equalizer);
            app.dbLabel_8.FontColor = [1 1 1];
            app.dbLabel_8.Position = [389 354 39 22];
            app.dbLabel_8.Text = '+20db';

            % Create dbLabel_9
            app.dbLabel_9 = uilabel(app.Equalizer);
            app.dbLabel_9.FontColor = [1 1 1];
            app.dbLabel_9.Position = [394 96 36 22];
            app.dbLabel_9.Text = '-20db';

            % Create dbLabel_10
            app.dbLabel_10 = uilabel(app.Equalizer);
            app.dbLabel_10.FontColor = [1 1 1];
            app.dbLabel_10.Position = [479 354 39 22];
            app.dbLabel_10.Text = '+20db';

            % Create B1disp
            app.B1disp = uieditfield(app.Equalizer, 'text');
            app.B1disp.Position = [24 63 37 22];

            % Create B2disp
            app.B2disp = uieditfield(app.Equalizer, 'text');
            app.B2disp.Position = [136 64 37 21];

            % Create B3disp
            app.B3disp = uieditfield(app.Equalizer, 'text');
            app.B3disp.Position = [275 63 37 22];

            % Create B4disp
            app.B4disp = uieditfield(app.Equalizer, 'text');
            app.B4disp.Position = [389 63 37 22];

            % Create B5disp
            app.B5disp = uieditfield(app.Equalizer, 'text');
            app.B5disp.Position = [491 63 37 22];

            % Create AboutMeButton
            app.AboutMeButton = uibutton(app.uwuplayer, 'push');
            app.AboutMeButton.ButtonPushedFcn = createCallbackFcn(app, @AboutMeButtonPushed, true);
            app.AboutMeButton.Icon = 'icon.png';
            app.AboutMeButton.FontName = 'Times New Roman';
            app.AboutMeButton.Position = [1387 729 112 40];
            app.AboutMeButton.Text = 'About Me';

            % Create ResetButton
            app.ResetButton = uibutton(app.uwuplayer, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [861 729 112 40];
            app.ResetButton.Text = 'Reset';

            % Create Image
            app.Image = uiimage(app.uwuplayer);
            app.Image.Position = [142 524 540 206];
            app.Image.ImageSource = 'download.png';

            % Create Button
            app.Button = uibutton(app.uwuplayer, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.BackgroundColor = [1 1 1];
            app.Button.FontColor = [1 1 1];
            app.Button.Position = [142 687 44 43];
            app.Button.Text = '';

            % Show the figure after all components are created
            app.uwuplayer.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = player

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.uwuplayer)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.uwuplayer)
        end
    end
end