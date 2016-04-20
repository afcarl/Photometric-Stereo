
data_path = './data/data02/';
recursive_subdivide = 5;
opt = config(data_path);
% try to load cached data
if numel(dir([opt.cache_path '*.bmp'])) ~= 0
  all_images = dir([opt.cache_path '/*.bmp']);
  opt.image_names = {all_images.name};
  opt.image_num = length(opt.image_names);
  cache_light = load([opt.cache_path 'light_vec.mat']);
  opt.light_vec = cache_light.light_vec;
else
  process_data(opt);
end

denominator_image = calculate_denominator(opt);\
