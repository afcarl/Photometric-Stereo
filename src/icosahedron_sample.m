function vertices = icosahedron_sample(iter_times)
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

for iter = 1:iter_times
  num_surface = size(surface_midpoints, 1);
  vertices_buffer = [];
  surface_buffer = [];
  for m = 1:num_surface
    % for each surface midpoint, we find 3 nearest neighbors
    % which construct one triangle
    d = (vertices(:, 1) - surface_midpoints(m, 1)).^2 + ...
      (vertices(:, 2) - surface_midpoints(m, 2)).^2 + ...
      (vertices(:, 3) - surface_midpoints(m, 3)).^2;
    [~, order] = sort(d);
    
    p1 = vertices(order(1), :);
    p2 = vertices(order(2), :);
    p3 = vertices(order(3), :);
    
    [output1, output2] = subdivide(p1, p2, p3);
    output1 = output1 ./ repmat(sqrt(sum(output1.^2, 2)), 1, 3);
    output2 = output2 ./ repmat(sqrt(sum(output2.^2, 2)), 1, 3);
    vertices_buffer = [vertices_buffer ; output1];
    surface_buffer = [surface_buffer ; output2];
  end
  % reconstruct vertices
  vertices = unique([vertices_buffer; vertices], 'rows');
  surface_midpoints = unique(surface_buffer, 'rows');
end

end

function [new_vertices, new_midpoints] = subdivide(p1, p2, p3)

new_vertices = [
  (p2 + p3) / 2;
  (p1 + p2) / 2;
  (p1 + p3) / 2;
  ];

n1 = (p1 + (p1 + p2) / 2 + (p1 + p3) / 2) / 3;
n2 = (p2 + (p1 + p2) / 2 + (p2 + p3) / 2) / 3;
n3 = (p3 + (p1 + p3) / 2 + (p2 + p3) / 2) / 3;
n4 = ((p1 + p2) / 2 + (p2 + p3) / 2 + (p1 + p3) / 2) / 3;

new_midpoints = [n1;n2;n3;n4];

end
