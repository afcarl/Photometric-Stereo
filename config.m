function opt = config(data_path)

addpath(genpath('./src/'));

opt.root = './';
opt.data_path = [opt.root 'data/data02/'];
opt.cache_path = [opt.data_path 'resampled/'];
mkdir_if_missing(opt.cache_path);
% get list names by dir command
all_images = dir([data_path '/*.bmp']);
opt.image_names = {all_images.name};
opt.image_num = length(opt.image_names);
% get light vector txt
opt.light_vec = load([data_path '/lightvec.txt']);

end