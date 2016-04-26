function [opt, image_buffer] = process_data(opt)
% This function perform uniformly sampling data in terms of light direction

% iteratively subdivde surface 4 (default) times
vertices = icosahedron_sample(4);
% get only points in half plane (light direction plane)
vertices = vertices(vertices(:, 3) >= 0, :);

% Algorithm:
% for each one vertex, seek the nearest light direction
% for that direction, interpolate images

% first figure out for each image, which vertex is its nearest neighbour
[nn_index, ~] = knnsearch(vertices, opt.light_vec);
[unique_ind, ~, reverse_ind] = unique(nn_index);
% Note: in theory, if light direction are the same, we don't need to
% interpolate them again, however, due to practical error, even when
% light direction are the same, the images are different
direction_num = size(unique_ind, 1);
% process one image to get image height and width
I = imread(strcat(opt.data_path, opt.image_names{1}));
warning('This loop way are too slow, try to figure out how to vectorize it');

weight_sum = zeros(direction_num, 1);
image_buffer = zeros([size(I), direction_num]);
for i = 1:opt.image_num
  tic_toc_print('Interpolate images %d / %d\n', i, opt.image_num);
  I = double(imread(strcat(opt.data_path, opt.image_names{i})));
  image_weight = opt.light_vec(i, :) * vertices(nn_index(i), :)';
  image_buffer(:,:,:,reverse_ind(i)) = image_buffer(:,:,:,reverse_ind(i)) + I * image_weight;
  weight_sum(reverse_ind(i)) = weight_sum(reverse_ind(i)) + image_weight;
end

for i = 1:direction_num
  image_buffer(:,:,:,i) = image_buffer(:,:,:,i) / weight_sum(i);
end

light_vec = vertices(unique_ind, :);

opt.image_num = direction_num;
opt.light_vec = light_vec;

end