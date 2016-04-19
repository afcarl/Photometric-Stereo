function opt = config(data_path)

opt.data_path = data_path;
% get list names by dir command
all_images = dir([data_path '/*.bmp']);
opt.image_names = {all_images.name};
% get light vector txt
opt.light_vec = load([data_path '/lightvec.txt']);

addpath(genpath('./src/'));

end