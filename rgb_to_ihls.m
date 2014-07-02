%maps image from rgb colorspace to ihls colorspace
%based on pseudocode from https://sites.google.com/site/mcvibot2011sep/Modules/IHLSNHS/low-level-design
function M = rgb_to_ihls( rgbimg)

  [rows cols channels] = size(rgbimg);

  R = double(rgbimg(:,:,1));
  G = double(rgbimg(:,:,2));
  B = double(rgbimg(:,:,3));
  
  %functions to get max value and min value masks, comparing index-wise values from 3 matrices
  has_max = @(test,comp1,comp2)(and((test >= comp1),(test >= comp2) ));
  has_min = @(test,comp1,comp2)(and((test <= comp1),(test <= comp2) ));
  
  %combine maximum and minimum values index-wise, ie. RES(i,j)=max(R(i,j), G(i,j), B(i,j))
  max_vals = @(r,g,b)(has_max(r,g,b).*r+has_max(g,r,b).*g+has_max(b,g,r).*b);
  min_vals = @(r,g,b)(has_min(r,g,b).*r+has_min(g,r,b).*g+has_min(b,g,r).*b);
  
  s = @(r,g,b)(max_vals(r,g,b) - min_vals(r,g,b));
  l = @(r,g,b)(0.212.*r+0.715*g+0.072.*b);
  theta = @(r,g,b)(acos((r - 0.5 .* g - 0.5 .* b) ./ sqrt(r .* r + g .* g + b .* b - r .* g - r .* b - g .* b)));
  
  test = B <= G;
  test2 = B > G;
  
  thetas = theta(R,G,B);
  
  H = (test.*thetas) + (test2.*(360 - thetas));
  L = l(R,G,B);
  S = s(R,G,B);
  
  
  M = zeros(rows, cols, channels);

  M(:,:,1)=H(:,:);
  M(:,:,2)=L(:,:);
  M(:,:,3)=S(:,:);


end
