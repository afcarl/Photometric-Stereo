function opt = process_data(opt)
% This function perform uniformly sampling data in terms of light direction

% iteratively subdivde surface 4 (default) times
vertices = icosahedron_sample(4);
% get only points in half plane (light direction plane)
vertices = vertices(find(vertices(:, 3) >= 0), :);

% Algorithm:
% for each one vertex, seek the nearest light direction
% for that direction, interpolate images
[IDX, ~] = knnsearch(opt.light_vec, vertices);
IDX = unique(IDX);
% Note: in theory, if light direction are the same, we don't need to
% interpolate them again, however, due to practical error, even when
% light direction are the same, the images are different
direction_num = size(IDX, 1);
% process one image to get image height and width
I = imread(strcat(opt.data_path, opt.image_names{1}));
warning('This loop way are too slow, try to figure out how to vectorize it');
for i = 1:direction_num
  tic_toc_print('Interpolate images and save to cache %d / %d\n', i, direction_num);
  light_direction = opt.light_vec(IDX(i), :);
  weight_sum = 0.0;
  image_buffer = zeros(size(I));
  for j = 1:opt.image_num
    image_weight = opt.light_vec(j, :) * light_direction';
    I = double(imread(strcat(opt.data_path, opt.image_names{j})));
    image_buffer = image_buffer + I * image_weight;
    weight_sum = weight_sum + image_weight;
  end
  image_buffer = uint8(image_buffer / weight_sum);
  imwrite(image_buffer, [opt.cache_path 'image' num2str(i) '.bmp']);
end

end
