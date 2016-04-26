function depth_map = reconstruct_surf(norm_matrix)

% input:
%   normals of all pixels in a image
%   (height x width x 3)
% output:
%   depth of all pixels

map_height = size(norm_matrix, 1);
map_width = size(norm_matrix, 2);
slant = zeros(map_height, map_width);
tilt = zeros(map_height, map_width);

for i = 1:map_height
  for j = 1:map_width
    x = norm_matrix(i, j, 1);
    y = norm_matrix(i, j, 2);
    z = norm_matrix(i, j, 3);
    dzdx = -x / z; dzdy = -y / z;
    [a,b] = grad2slanttilt(dzdx, dzdy);
    slant(i,j) = a;
    tilt(i, j) = b;
  end
end

depth_map = shapeletsurf(slant, tilt, 6, 3, 2);


end