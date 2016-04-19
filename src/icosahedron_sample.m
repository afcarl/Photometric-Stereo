function output = icosahedron_sample()
% This function construct subdivided surface of icosahedron
% t, a, b, c, d are defind as described in paper (based on golden ratio)

t = (1+sqrt(5)) / 2;
a = sqrt(t) / 5^(1/4);
b = 1 / (sqrt(t) * 5^(1/4));
c = a + 2 * b;
d = a + b;

vertices = [
   0,  a,  b;
   0,  a, -b;
   0, -a,  b;
   0, -a, -b;
   b,  0,  a;
  -b,  0,  a;
   b,  0, -a;
  -b,  0, -a;
   a, -b,  0;
   a,  b,  0;
  -a, -b,  0;
  -a,  b,  0;
  ];

surface_midpoints = [
   d,  d,  d;
   d, -d,  d;
   d,  d, -d;
   d, -d, -d;
  -d,  d,  d;
  -d, -d,  d;
  -d,  d, -d;
  -d, -d, -d;
   0,  a,  c;
   0,  a, -c;
   0, -a,  c;
   0, -a, -c;
   c,  0,  a;
  -c,  0,  a;
   c,  0, -a;
  -c,  0, -a;
   a,  c,  0;
   a, -c,  0;
  -a,  c,  0;
  -a, -c,  0;
] / 3;

subdivide = @(center_point, p1, p2, p3) [
  (center_point + p1) / 2;
  (center_point + p2) / 2;
  (center_point + p3) / 2;
  p2 + p3 / 2;
  p1 + p2 / 2;
  p1 + p3 / 2;
  ];

for iter = 1:5
  num_surface = size(surface_midpoints, 1);
  interpolate_buffer = [];
  for m = 1:num_surface
    d = (vertices(:, 1) - surface_midpoints(m, 1)).^2 + ...
      (vertices(:, 2) - surface_midpoints(m, 2)).^2 + ...
      (vertices(:, 3) - surface_midpoints(m, 3)).^2;
    [~, order] = sort(d);
    
    center_point = surface_midpoints(m, :);
    p1 = vertices(order(1), :);
    p2 = vertices(order(2), :);
    p3 = vertices(order(3), :);
    
    output = subdivide(center_point, p1, p2, p3);
    point_norm = repmat(sum(output.^2, 2), 1, 3);
    interpolate_buffer = [interpolate_buffer ;output ./ point_norm;];
  end
  % reconstruct vertices
  interpolate_buffer = unique(interpolate_buffer, 'rows');
  vertices = [vertices; interpolate_buffer];
  % reconstruct surface midpoints
end

end
