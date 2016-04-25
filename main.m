
data_path = './data/data02/';
opt = config(data_path);
% try to load cached data
if numel(dir([opt.cache_path '*.bmp'])) ~= 0 && exist([opt.cache_path 'light_vec.mat'], 'file')
  all_images = dir([opt.cache_path '/*.bmp']);
  opt.image_names = {all_images.name};
  opt.image_num = length(opt.image_names);
  cache_light = load([opt.cache_path 'light_vec.mat']);
  opt.light_vec = cache_light.light_vec;
else
  opt = process_data(opt);
end

[denominator_ind, image_buffer] = calculate_denominator(opt);
norm_matrix = estimate_norm(denominator_ind, image_buffer, opt);

% for debugging propose, we may view the diffuse light image
[m,n,~] = size(norm_matrix);
light = [-2, 2, 2] / sqrt(14);
lightImg = zeros(m, n);
for i = 1:m
  for j = 1:n
    lightImg(i, j) = light * squeeze(norm_matrix(i,j,:));
  end
end
