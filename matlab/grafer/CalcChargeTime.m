function CalcChargeTime 
figure('Position',[10,10,800,500]);  
  
    ladekapasitet=50;
    function set250 (x,y)
        ladekapasitet=250;
        calculate;
    end
    function set150 (x,y)
        ladekapasitet=150;
        calculate;
    end
    function set50 (x,y)
        ladekapasitet= 50;
        calculate;
    end
    uicontrol('Style','pushbutton',...
        'String','50kw','Position',[35,10,90,25],...
        'Callback',@set50); 
    uicontrol('Style','pushbutton',...
        'String','150kw','Position',[135,10,90,25],...
        'Callback',@set150);   
    uicontrol('Style','pushbutton',...
        'String','250kw','Position',[235,10,90,25],...
        'Callback',@set250);   
    x=[70,140,210];
    bar(x,[0,0,0])
        title('CalcChargeTime');
    xlabel('Batterikapasitet (kwh)');
    ylabel('Ladetid (timer)');
    ylim([0,4.5])
   
    function calculate ()
    y=x./ladekapasitet;
    bar(x,y);
    title('CalcChargeTime');
    xlabel('Batterikapasitet (kwh)');
    ylabel('Ladetid (timer)');
    ylim([0,4.5])
    end
uicontrol('Style','pushbutton',...
        'String','zoom inn','Position',[600,10,90,25],...
        'Callback',@zoominn); 
    uicontrol('Style','pushbutton',...
        'String','zoom ut','Position',[700,10,90,25],...
        'Callback',@zoomut); 
    function zoominn (x,y)
        camzoom(1.25)
    end
    function zoomut (x,y)
        camzoom(0.75)
    end
        
        
end