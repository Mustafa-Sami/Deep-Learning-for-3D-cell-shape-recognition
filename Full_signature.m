
function [st, angle, Out_temp, x0, y0] = Full_signature(b, varargin)

[np, nc] = size(b);
if (np < nc | nc ~= 2) 
   error('B must be of size np-by-2.'); 
end

if isequal(b(1, :), b(np, :)) 
   b = b(1:np - 1, :); 
   np = np - 1;
end
    
if nargin == 1
   x0 = round(sum(b(:, 1))/np); 
   y0 = round(sum(b(:, 2))/np); 
elseif nargin == 3 
   x0 = varargin{1};
   y0 = varargin{2};
else 
   error('Incorrect number of inputs.'); 
end
    
b(:, 1) = b(:, 1) - x0;
b(:, 2) = b(:, 2) - y0;

xc = b(:, 2);
yc = -b(:, 1);
[theta, rho] = cart2pol(xc, yc);

theta = theta.*(180/pi);

j = theta == 0; 
theta = theta.*(0.5*abs(1 + sign(theta)))...
        - 0.5*(-1 + sign(theta)).*(360 + theta);
theta(j) = 0; 

temp = theta;
Out_temp = round(temp);

I = find(temp == min(temp));

temp = circshift(temp, [-(I(1) - 1), 0]);

theta = round(theta);

tr = [theta, rho]; 

[w, u, v] = unique(tr(:, 1)); 
tr = tr(u,:); 

if tr(end, 1) == tr(1) + 360
   tr = tr(1:end - 1, :);
end

angle = tr(:, 1);   
angle(end+1) = 360;  

st = tr(:, 2);    
st (end+1) = st(1);

Out_temp = Out_temp;
