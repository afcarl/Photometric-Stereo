function opt = process_data(opt)
% This function perform uniformly sampling data in terms of light direction
light_x = opt.light_vec(:, 1);
light_y = opt.light_vec(:, 2);
light_z = opt.light_vec(:, 3);
% iteratively subdivde surface 4 (default) times
vertices = icosahedron_sample(4);

end
