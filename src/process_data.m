function opt = process_data(opt)
% This function perform uniformly sampling data in terms of light direction

% iteratively subdivde surface 4 (default) times
vertices = icosahedron_sample(4);
% get only points in half plane (light direction plane)
vertices = vertices(vertices(:, 3) >= 0, :);

% Algorithm:
% for each one vertex, seek the nearest light direction
% for that direction, interpolate images

% first figure out for each image, which vertex is its nearest neighbour
[IDX, ~] = knnsearch(vertices, opt.light_vec);
[IDX, ~, reverse_ind] = unique(IDX);
% Note: in theory, if light direction are the same, we don't need to
% interpolate them again, however, due to practical error, even when
% light direction are the same, the images are different
direction_num = size(IDX, 1);
% process one image to get image height and width
I = imread(strcat(opt.data_path, opt.image_names{1}));
warning('This loop way are too slow, try to figure out how to vectorize it');

weight_sum = zeros(direction_num, 1);
image_buffer = zeros([size(I), direction_num]);
for i = 1:opt.image_num
  tic_toc_print('Interpolate images %d / %d\n', i, opt.image_num);
  I = double(imread(strcat(opt.data_path, opt.image_names{i})));
  image_weight = opt.light_vec(i, :) * opt.light_vec(reverse_ind(i), :)';
  image_buffer(:,:,:,reverse_ind(i)) = image_buffer(:,:,:,reverse_ind(i)) + I * image_weight;
  weight_sum(reverse_ind(i)) = weight_sum(reverse_ind(i)) + image_weight;
end

for i = 1:direction_num
  I = image_buffer(:,:,:,i);
  I = rgb2gray(uint8(I / weight_sum(i)));
  imwrite(I, [opt.cache_path 'image' num2str(i) '.bmp']);
end
% 
% for i = 1:direction_num
%   tic_toc_print('Interpolate images and save to cache %d / %d\n', i, direction_num);
%   light_direction = opt.light_vec(IDX(i), :);
%   weight_sum = 0.0;
%   image_buffer = zeros(size(I));
%   for j = 1:opt.image_num
%     image_weight = opt.light_vec(j, :) * light_direction';
%     I = double(imread(strcat(opt.data_path, opt.image_names{j})));
%     image_buffer = image_buffer + I * image_weight;
%     weight_sum = weight_sum + image_weight;
%   end
%   image_buffer = uint8(image_buffer / weight_sum);
%   grey_image = rgb2gray(image_buffer);
%   imwrite(grey_image, [opt.cache_path 'image' num2str(i) '.bmp']);
% end

light_vec = opt.light_vec(IDX, :);
save([opt.cache_path 'light_vec.mat'], 'light_vec');

all_images = dir([opt.cache_path '/*.bmp']);
opt.image_names = {all_images.name};
opt.image_num = length(opt.image_names);
opt.light_vec = light_vec;

end
