function denominator_image = calculate_denominator(opt)

% Motivation:
% we want to choose an image to cancel out the surface albedo
% Algorithm:
% for each pixel location (i, j), sort corresponding pixel intensities
% over all sampled images

I = imread([opt.cache_path, opt.image_names{1}]);
[image_height, image_width] = size(I);
image_buffer = zeros(image_height, image_width, opt.image_num);
for i = 1:opt.image_num
  image_buffer(:,:,i) = imread([opt.cache_path opt.image_names{i}]);
end

rank_matrix = uint8(zeros(size(image_buffer)));
for i = 1:image_width
  for j = 1:image_height
    pixels = squeeze(image_buffer(j, i, :));
    [~, inds] = sort(pixels);
    rank_matrix(j, i, :) = inds;
  end
end

L = 0.7 * opt.image_num;
H = 0.9 * opt.image_num;

k_matrix = zeros(opt.image_num, 1);
r_matrix = zeros(opt.image_num, 1);

for i = 1:opt.image_num
  mask_matrix = rank_matrix(:,:,i) >= L;
  k_matrix(i) = sum(mask_matrix(:));
  r_matrix(i) = mean2(image_buffer(:,:,i) .* mask_matrix);
end

% a small trick here, we convert r_matrix to boolean as mask by comparing
% with H, and we can direclty take max value among kr_matrix, which already
% satisfy the H threshold
kr_matrix = k_matrix .* (r_matrix < H);
[~, ind] = max(kr_matrix);

denominator_image = image_buffer(:,:,ind);

end