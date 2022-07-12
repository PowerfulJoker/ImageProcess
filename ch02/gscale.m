function g = gscale(f, varargin)
%GSCALE 此函数将输出灰度映射到某个特定的范围
% gscale(f,'full8')
% gscale(f,'full16')
% gscale(f,'minmax',LOW,HIGH)

if isempty(varargin)
    method = 'full8';
else
    method = varargin{1};
end

if strcmp(class(f),'double') && (max(f(:))>1||min(f(:))<0)
    f = mat2gray(f);
end

switch method
    case 'full8'
        g = im2uint8(mat2gray(double(f)));
    case 'full16'
        g = im2uint16(mat2gray(double(f)));
    case 'minmax'
        low  = varargin{2};
        high = varargin{3};
        if low > 1 || low < 0|| high > 1 || high <0
            error('Parameters low and high must be in the range [0,1]');
        end
        if strcmp(class(f),'double')
            low_in = min(f(:));
            high_in = max(f(:));
        elseif strcmp(clss(f),'unit8')
            low_in = double(min(f(:)))./255;
            high_in = double(max(f(:)))./255;
        elseif strcmp(clss(f),'unit16')
            low_in = double(min(f(:)))./65535;
            high_in = double(max(f(:)))./65535;
        end
        g = imadjust(f,[low_in high_in],[low high]);
    otherwise
        error('Unknow method.');
end

end

