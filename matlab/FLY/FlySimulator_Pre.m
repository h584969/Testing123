
%{ 
LES DETTE !!!!!

WASDQE (lowercase) for steering. V to switch to 1st person view. More below.

Combine stuff from all the previous examples to make:
1. Import a plane as a patch object.
2. Translate/rotate this through space as per user input. User changes
heading, constant velocity dynamics. Use ws,ad, qe for pitch,roll,yaw
3. Put in horizon and ground with textures. If the plane COM tries to
penetrate, simply project it back up.
4. Have camera follow the plane in 2 ways, press v to switch between.

Matt Sheen, mws262@cornell.edu
%}
% RK: SPEED is P and M
function FlySimulator9
%% Intro stuff
close all
fig = figure;

% Init Stuff
FRAMES=10; % 
fig.UserData.firstPerson = true; %do we start in 1st person view, or not?
vel = 0; %Velocity
kwt = 0; % 
posStart=[0,0,0];

[es,fs] = audioread('engine.wav');
pe = audioplayer(es,fs);
EngineSound();

hold on
fig.Position = [100 100 700 600]; % Size of program

%Disable axis viewing, don't allow axes to clip the plane
fig.Children.Visible = 'off';
fig.Children.Clipping = 'off';
fig.Children.Projection = 'perspective';


%% Add Control panels
uicontrol('Style','pushbutton',...
                 'String','Reset','Position',[10,75,70,25],...
                 'Callback',@slow_Reset);  
             
inst = uipanel('Title','Instruments','FontSize',12,...
     'BackgroundColor','cyan',...
     'Position',[.3 .01 .4 .15]);
 
fuel = uipanel('Title','Fuel','FontSize',12,...
             'BackgroundColor','cyan',...
             'Position',[.75 .01 .2 .15]);
fuel.Title = "Battery: ";

ikwh = uicontrol(fuel,'Style','text','FontSize',12,...
    'BackgroundColor','cyan',...
    'Position',[3,3,140,30]);
 
ispeed = uicontrol(inst,'Style','text','FontSize',12,...
    'BackgroundColor','cyan',...
    'Position',[3,3,120,30]);

iheight = uicontrol(inst,'Style','text','FontSize',12,...
    'BackgroundColor','cyan',...
    'Position',[3,30,120,30]);

% Reset the plane with data
function slow_Reset(~, ~)
    pos = posStart;
    InitPlane();
end
    

%% Add the plane - Fancy planes folder
vert=0;
InitPlane();

function InitPlane()
%     fv = stlread('cessna.stl');
    fv = stlread('a10.stl'); % If enable - remove Cessna Only lines below   
    vert = 0;
    delete(findobj('type', 'patch'));
    p1 = patch(fv,'FaceColor', 'green', ...
     'EdgeColor', 'none', ...
     'FaceLighting',    'gouraud',     ...
     'AmbientStrength', 0.35);
%     rotate(p1,[0 0 1],180) % Cessna onlyvv
%     p1.Vertices = p1.Vertices *5; % Cessna only
    vert = p1.Vertices;
    
    vel = 99; %Velocity
    kwt = 264; % 
    posStart = [10000, 56000, 5500];
end

%% Add the sky as a giant sphere (fly inside...)
[skyX,skyY,skyZ] = sphere(60);
sky = surf(500000*skyX, 500000*skyY, 500000*skyZ, 'LineStyle','none');
sky.FaceColor = 'cyan';
light('Position',[0 0 500000],'Style','local')

%% Add the ground + textures - Fancy environments folder Ex
textureLand = imread('desert.jpg');
textureSea = imread('sea.jpg');
textureForrest = imread('forrest.jpg');

%% A ISLAND without grass
[x,y,z] = peaks(100);
x = x * 3000+20000;
y = y * 6000-4000;
z = z * 1200 - 100;
ss=surf(x,y,z, ...
       'LineStyle','none','AmbientStrength',0.7);
ss.FaceColor = 'texturemap';
ss.CData = textureLand;

%% Define a forrest island
ground2 = 6000*membrane(1,60) -1000;
groundSurf2 = surf(linspace(-30000,10000,size(ground2,1)), ...
        linspace(-20000,30000,size(ground2,2)), ground2, ...
        'LineStyle','none','AmbientStrength',0.7,   ...
        'DiffuseStrength',0.8,'SpecularStrength',0, ...
        'SpecularExponent',10,'SpecularColorReflectance',1);
groundSurf2.FaceColor = 'texturemap';
groundSurf2.CData = textureForrest;

%% En hval
[bx,by,bz] = sphere(100); %hvakroppen
ground3surf = surf(5000*bx+10000,10000*by+50000,5000*bz);
ground3surf.EdgeColor = 'none';
ground3surf.FaceColor = 'blue';
[e1x,ey1,ez1] = sphere(50); %kule for øye
eye1surf = surf(500*e1x+14000,500*ey1+46000,500*ez1+2000); %øye1
eye1surf.EdgeColor = 'none';
eye1surf.FaceColor = 'white';
eye2surf = surf(500*e1x+5600,500*ey1+46000,500*ez1+2000); %øye2
eye2surf.EdgeColor = 'none';
eye2surf.FaceColor = 'white';
%flystripen som skal ligge oppå hvalen :D
rxp = 10000;
ryp = 50000;
rzp = 5000;
runway = surf(linspace(-1000,1000,10)+rxp,linspace(-6000,6000,10)+ryp,0*ones(10)+rzp);

runway.FaceColor = 'black';




%% add flat ground (Ocean) going off to (basically) infinity.
fx = 1000;
fy = 1000;
flatground = surf(linspace(-500000,500000,fx), ... 
                    linspace(-500000,500000,fy),...
                    0*ones(fx));
flatground.FaceColor = 'texturemap';
flatground.CData = textureSea;
flatground.EdgeColor = 'none';
flatground.AlphaData = 0.8;

    fargen = 0;
    function byttfarge(~, ~)
        fargen = fargen + 1;
        if fargen == 2
            fargen = 0;
            flatground.CData = textureLand;
        else
            flatground.CData = textureSea;
        end
    end
    uicontrol('style','PushButton','Position',[100,100,100,35], 'String','Bytt landskap','Callback',@byttfarge)


camlight('headlight');

camva(40); %view angle

%% Set keyboard callbacks and flags for movement.
set(fig,'WindowKeyPressFcn',@KeyPress,'WindowKeyReleaseFcn', @KeyRelease);
fig.UserData.e = false;
fig.UserData.q = false;
fig.UserData.a = false;
fig.UserData.d = false;
fig.UserData.w = false;
fig.UserData.s = false;

forwardVec = [1 0 0]'; %Vector of the plane's forward direction in plane frame
rot = eye(3,3); %Initial plane rotation
rot = rot*fcn(-pi/2,0,0); %rotere flyet 90 grader for å matche flybane på hval
pos = posStart; %Initial plane position

hold off
axis([-10000 10000 -10000 10000 -10000 10000])

%% Animation loop:
tic
told = 0;
while(ishandle(fig))
    tnew = toc;

    %Check for user inputs:
    if fig.UserData.e
      rot = rot*fcn(-0.05,0,0);
    end
    if fig.UserData.q
      rot = rot*fcn(0.05,0,0);
    end
    if fig.UserData.s
      rot = rot*fcn(0,-0.05,0);
    end
    if fig.UserData.w
      rot = rot*fcn(0,0.05,0);
    end
    if fig.UserData.a
      rot = rot*fcn(0,0,-0.05);
    end
    if fig.UserData.d
      rot = rot*fcn(0,0,0.05);
    end
  
    %Update plane's center position.
    z = pos(3);
    pos = vel*(rot*forwardVec*(tnew-told))' + pos;
    
    %If empty battery - let the plane fall
    if (kwt < 0 || vel < 100) % No more kwh or not fast enough
        pos(3) = z - 100;
    end
    
    %Update the plane's vertices using the new position and rotation
    p1.Vertices = (rot*vert')' + repmat(pos,[size(vert,1),1]); 
    
    %Crash test 
    z = pos(3);
    if  z < 0 || ... % Sea
        z < GetZ(ss,pos) || ...
        z < GetZ(groundSurf2,pos)
        Crash();
        return;
    end    
   
    %Camera updates:
    if fig.UserData.firstPerson %First person view -- follow the plane from slightly behind.
        camupvec = rot*[0 0 1]';
        camup(camupvec);
        x = 1000;
        campos(pos' - x*rot*[1 0 -0.15]');
        camtarget(pos' + 100*rot*[1 0 0]');    
    else %Follow the plane from a fixed angle
        campos(pos + [-1000,500,100]);%3000*abs(pos-campos)/norm(pos-campos));
        camtarget(pos);
    end   
  
    told = tnew;
    pause(1/FRAMES);
      
    if (isvalid(fig)==false) % Plot Speed and Position
        continue;
    end
    
    if (pos(3) < 100)
        fig.Name = "FOR LAV!!!!";
    else
        fig.Name = "  X=" + int2str(pos(1)) + "  Y=" + int2str(pos(2));
    end
    % Check when fuel is empty
    if (kwt < 0 || vel < 100)
        EngineStop();
    else
        kwt = kwt - (0.003 + vel*vel/10000000 + forwardVec(3)*vel*vel/100);
    end
    ikwh.String = "KWh : " + int2str(kwt);
    ispeed.String = "Speed " + int2str(vel);
    iheight.String = "Height " + int2str( pos(3));            
end

%% Trap keys
function KeyPress(varargin)
     key = varargin{2}.Key;
     SetUserData(key, true);
     if strcmp(key,'v')
         fig.UserData.firstPerson = ~fig.UserData.firstPerson;
     elseif strcmp(key,'p') % Speed up
         vel = vel * 1.05;
     elseif strcmp(key,'m') % Slow down
         vel = vel * 0.95;
     end
     if (vel > 1500) 
         vel = 1500; 
     end
end

function KeyRelease(varargin)
     key = varargin{2}.Key;
     SetUserData(key, false);
end
%%
function SetUserData(key, f)
     if strcmp(key,'e') 
         fig.UserData.e = f;
     elseif strcmp(key,'q')
         fig.UserData.q = f;
     elseif strcmp(key,'a')
         fig.UserData.a = f;
     elseif strcmp(key,'d')
         fig.UserData.d = f;
     elseif strcmp(key,'w')
         fig.UserData.w = f;
     elseif strcmp(key,'s')
         fig.UserData.s = f;
     end
end

%% Make Engine Sound
function EngineSound()
    xs = es(fs*10:end);
    f = fs*vel/1000;
    if isplaying(pe)
        stop(pe);        
    end
    play(pe);
end
%% Engine Stop Stound
function EngineStop()
    stop(pe);
end    
%% Crash Sound
function Crash()
     [xs,f] = audioread('crash_sound.wav');
    pe = audioplayer(xs,f);
    play(pe);   
end

%% Rotation Matrix
function M = fcn(yaw,pitch,roll)
    % Rotate a graphics object along Z-Y-X axes in the earth frane 
    m1 = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
    m2 = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
    m3 = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
    M = m3*m2*m1;
end
%% Get the Z of the surface given a position
function z0 = GetZ(s, pos)
    z0 = interp2(s.XData,s.YData,s.ZData,pos(1),pos(2) );
end

end
