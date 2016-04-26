function opt = config()

data_path = 'data/data04/'; % the root folder for dense captured image
image_type = '.bmp';

addpath(genpath('./src/'));
addpath(genpath('./lib/'));

opt.root = './';
opt.data_path = [opt.root data_path];

% get list names by dir command
all_images = dir([opt.data_path '/*' image_type]);
opt.image_names = {all_images.name};
opt.image_num = length(opt.image_names);
% get light vector txt
opt.light_vec = load([opt.data_path '/lightvec.txt']);

end