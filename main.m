
opt = config();

[opt, rgb_buffer] = process_data(opt);
[denominator_ind, image_buffer] = calculate_denominator(opt, rgb_buffer);
norm_matrix = estimate_norm(denominator_ind, image_buffer, opt);
depth_map = reconstruct_surf(norm_matrix);

figure, surf(depth_map);

% for debugging propose, we may view the diffuse light image
[m,n,~] = size(norm_matrix);
light = [-1, 1, 1] / sqrt(3);
lightImg = zeros(m, n);
for i = 1:m
  for j = 1:n
    lightImg(i, j) = light * squeeze(norm_matrix(i,j,:));
  end
end
figure, imshow(lightImg);