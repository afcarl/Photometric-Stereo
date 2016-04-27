function opt_norm = graphcut_refine(norm_matrix)

% input:
%   initial estimated norm
%
% output:
%   optimized norm based on defined energy function  
% 
% Algorithm:
%   to minimize E = E_data + E_smoothness
%   where E_data = \sum_{s} norm(|N_s - N_vs|), vs is the nearest vertices
%         E_smoothness = \sum
%
%   note the energy function defined in this implementation is different
%   from which described in original paper


sigma = 0.6;
lambda = 0.5;

[norm_height, norm_width, ~] = size(norm_matrix);

% iteratively subdivde surface 5 times as described in paper
% get only points in half plane (light direction plane)
% after that, only part of the vertices are useful (nearest for some norm)
vertices = icosahedron_sample(5);
vertices = vertices(vertices(:, 3) > 0, :);
norm_vec = reshape(norm_matrix, [], 3);
[nn_index, ~] = knnsearch(vertices, norm_vec);
[unique_ind, ~, ~] = unique(nn_index);
vertices = vertices(unique_ind, :);


E_data = pdist2(vertices, norm_vec);
E_smoothness = lambda * log(1 + pdist2(vertices, vertices) / (2 * sigma * sigma));

% convert data type in energy as integer by divide smallest non-zero number
E_data = int32(E_data * 10000);
E_smoothness = int32(E_smoothness * 10000);

s = size(norm_matrix);
labels = vertices;
L = size(labels,1);

edge_num = 2 * norm_height * norm_width - norm_height - norm_width;
Si = ones(edge_num, 1);
Sj = ones(edge_num, 1);
Sv = ones(edge_num, 1);
% make connection for all horizontal edges
cnt = 0;
for i = 1:norm_height
  for j = 1:norm_width - 1
    cnt = cnt + 1;
    Si(cnt) = (j - 1) * norm_height + i;
    Sj(cnt) = (j - 1) * norm_height + i + norm_height;
  end
end
% make connection for all vertical edges
for i = 1:norm_height - 1
  for j = 1:norm_width
    cnt = cnt + 1;
    Si(cnt) = (j - 1) * norm_height + i;
    Sj(cnt) = (j - 1) * norm_height + i + 1;
  end
end
neighbor_matrix = sparse(Si, Sj, Sv, norm_height*norm_width, norm_height*norm_width);

h = GCO_Create(s(1) * s(2), L);                                                  
GCO_SetDataCost(h, E_data);
GCO_SetSmoothCost(h, E_smoothness);
GCO_SetNeighbors(h, neighbor_matrix);
GCO_Expansion(h);
opt_label = GCO_GetLabeling(h);
GCO_Delete(h);

normsOPT1D = norm_vec(opt_label,:);
opt_norm = zeros(size(norm_matrix));
for j = 1:norm_width
  for i = 1:norm_height
    opt_norm(i,j,:) = normsOPT1D((j-1)*norm_height+i, :);
  end
end
opt_norm = vertices(opt_label, :);
opt_norm = reshape(opt_norm, [norm_height, norm_width, 3]);

normsOPT = opt_norm;
figure, imshow((-1/sqrt(3) * normsOPT(:,:,1) + 1/sqrt(3) * normsOPT(:,:,2) + 1/sqrt(3) * normsOPT(:,:,3)) / 1.1);


end