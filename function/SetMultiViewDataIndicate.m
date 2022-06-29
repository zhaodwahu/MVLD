function [MultiViewDataIndication] = SetMultiViewDataIndicate(dataType)
% set which types of features are used in multi-view multi-label learning
% DenseHue	1
% DenseHueV3H1	2
% DenseSift	3
% DenseSiftV3H1	4
% Gist	5
% HarrisHue	6
% HarrisHueV3H1	7
% HarrisSift	8
% HarrisSiftV3H1	9
% Hsv	10
% HsvV3H1	11
% Lab	12
% LabV3H1	13
% Rgb	14
% RgbV3H1	15
% Tags	16
%----------------------------------------------
% HUE, SIFT, GIST, HSV, RGB, and LAB
%----------------------------------------------
    MultiViewDataIndication.totalNumViews = 6;
    if dataType==1 % pascal
        MultiViewDataIndication.DenseHue      = 0;%  DenseHue DenseSift Gist Hsv Lab  Rgb
        MultiViewDataIndication.DenseHueV3H1  = 0;
        MultiViewDataIndication.DenseSift     = 1;%%
        MultiViewDataIndication.DenseSiftV3H1 = 0;
        MultiViewDataIndication.Gist          = 1;%%
        MultiViewDataIndication.HarrisHue     = 0;
        MultiViewDataIndication.HarrisHueV3H1 = 0;
        MultiViewDataIndication.HarrisSift    = 1;%%
        MultiViewDataIndication.HarrisSiftV3H1= 0;
        MultiViewDataIndication.Hsv           = 1;%%
        MultiViewDataIndication.HsvV3H1       = 0;
        MultiViewDataIndication.Lab           = 0;%
        MultiViewDataIndication.LabV3H1       = 0;
        MultiViewDataIndication.Rgb           = 1;%%
        MultiViewDataIndication.RgbV3H1       = 0;
        MultiViewDataIndication.tags          = 1;%%  
    elseif dataType==2 %
        MultiViewDataIndication.DenseHue      = 0;%  DenseHue DenseSift Gist Hsv Lab  Rgb
        MultiViewDataIndication.DenseHueV3H1  = 1;
        MultiViewDataIndication.DenseSift     = 0;%
        MultiViewDataIndication.DenseSiftV3H1 = 1;
        MultiViewDataIndication.Gist          = 1;%
        MultiViewDataIndication.HarrisHue     = 0;
        MultiViewDataIndication.HarrisHueV3H1 = 0;
        MultiViewDataIndication.HarrisSift    = 1;%%
        MultiViewDataIndication.HarrisSiftV3H1= 0;
        MultiViewDataIndication.Hsv           = 1;%
        MultiViewDataIndication.HsvV3H1       = 0;
        MultiViewDataIndication.Lab           = 0;%
        MultiViewDataIndication.LabV3H1       = 0;
        MultiViewDataIndication.Rgb           = 0;%
        MultiViewDataIndication.RgbV3H1       = 1;
        MultiViewDataIndication.tags          = 0;%%  
    end

    s = struct2cell(MultiViewDataIndication);
    l = size(s,1);
    sum = 0;
    for i =2:l
        sum = sum + s{i,1};
    end
    if sum > MultiViewDataIndication.totalNumViews
        error('Error settings of Multi view data, totalNumViews and settings are not matched, please check it again.');
    end
end
