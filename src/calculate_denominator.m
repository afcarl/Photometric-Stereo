function [denominator_ind, image_buffer] = calculate_denominator(opt, rgb_buffer)

% Motivation:
%   we want to choose an image to cancel out the surface albedo
%
% Algorithm:
%   for each pixel location (i, j), sort corresponding pixel intensities
%   over all sampled images

[image_height, image_width, ~, ~] = size(rgb_buffer);
image_buffer = zeros(image_height, image_width, opt.image_num);

% we direct multiply here to avoid dividing 255 on rgb_buffer
% which is unnecessary to multiply back
for i = 1:opt.image_num
  image_buffer(:,:,i) = 0.2989 * rgb_buffer(:,:,1,i) + ...
    0.5870 * rgb_buffer(:,:,2,i) + 0.1140 * rgb_buffer(:,:,3,i);
end

rank_matrix = zeros(size(image_buffer));
assignment = zeros(opt.image_num, 1);
for i = 1:image_width
  for j = 1:image_height
    pixels = squeeze(image_buffer(j, i, :));
    [~, inds] = sort(pixels);
    assignment(inds) = 1:opt.image_num;
    rank_matrix(j, i, :) = assignment;
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
[~, denominator_ind] = max(kr_matrix);

end
