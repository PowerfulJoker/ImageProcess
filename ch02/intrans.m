function g = intrans(f,method,varargin)
% 灰度转换
% method: 'neg', 'log','gamma','stretch','specified'
% 'neg' 图像反转 s = L-1-r 
% 'log' 对数变换 s = c*log(1+r)
% 'gamma' 伽马变换 s = c*e^gamma
% 'stretch' , 对比度拉伸变换，s = 1./ (1+(m./f).^E)


narginchk(2, 4);
if strcmp(method, 'log')
    g = logTransform(f,varargin);
    return; 
end

if isfloat(f) && (max(f(:)) > 1 || min(f(:)) < 0)
    f = mat2gray(f);
end
[f, revertclass] = tofloat(f);

switch method
    case 'neg'
        g = imcomplement(f);
    case 'gamma'
        g = gammaTransform(f,varargin{:});
    case 'stretch'
        g = stretchTransform(f,varargin{:});
    case 'specified'
        g = specifiedTransform(f, varargin{:});
    otherwise
        error('Unknow enhancement method');
end

g = revertclass(g);

%--------------------------gamma-------------------------------%
function g = gammaTransform(f,gamma)
    g = imadjust(f,[ ],[ ],gamma);
end

%---------------------------stretch------------------------------%
function g = stretchTransform(f, varargin)
    if isempty(varargin)
        m = mean2(f);
        E = 4.0;
    elseif length(varargin)==2
        m = varargin{1};
        E = varargin{2};
    else
        error('Incorret number of inputs for the stretch method.');
    end
    g = 1./ ((1+m./f).^E);
end

%---------------------------specified-----------------------------%
function g = specifiedTransform(f, txfun)
    txfun = txfun(:);
    if any(txfun > 1)  || any(txfun <= 0 ) 
        error('All elements of txfun must be in the range [0 1].')
    end
    T = txfun;
    X = linspace(0,1,numel(T))';
    g = interp1(X,T,f);
end


%------------------------------------------------------------------%
% 计算C*log(1+F)
function g = logTransform(f, varargin)
    [f, revertclass] = float(f);
    if numel(varargin) >=2
        if  strcmp(varargin{2}, 'uint8')
            revertclass = @im2uint8;
        elseif strcmp(varargin{16},'uint16')
            revertclass = @im2uint16;
        else
            error('Unsupported CLASS option for "log" method');
        end
    end
    if numel(varargin) < 1
        C = 1;
    else
        C = varargin{1};
    end
    g = C*(log(1+f));
    g = revertclass(g);
end

end