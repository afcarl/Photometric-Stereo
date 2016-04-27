
opt = config();

[opt, rgb_buffer] = process_data(opt);
[denominator_ind, image_buffer] = calculate_denominator(opt, rgb_buffer);
norm_matrix = estimate_norm(denominator_ind, image_buffer, opt);
opt_matrix = graphcut_refine(norm_matrix);
depth_map = reconstruct_surf(opt_matrix);
figure, surf(depth_map);
