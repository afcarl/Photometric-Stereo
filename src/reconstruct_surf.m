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
    % note need to figure out why we need different coordinate system
    vec = squeeze(norm_matrix(map_height+1-i, j, :));
    x = vec(1); y = vec(2); z = vec(3);
    dzdx = -x / z; dzdy = -y / z;
    [slant(i,j), tilt(i,j)] = grad2slanttilt(dzdx,dzdy);
  end
end

depth_map = shapeletsurf(slant, tilt, 6, 3, 2);


end