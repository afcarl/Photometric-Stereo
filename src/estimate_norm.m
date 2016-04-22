function estimated_norm = estimate_norm(denominator_ind, image_buffer, opt)

% produce initial norm estimation for each pixel in the image set
% image pixels are models as p(N.L)

light_denominator = opt.light_vec(denominator_ind, :);
light_ratio = [opt.light_vec(1:denominator_ind-1, :); 
  opt.light_vec(denominator_ind+1:end, :)];

image_height = size(image_buffer, 1);
image_width = size(image_buffer, 2);

estimated_norm = zeros(image_height, image_width, 3);

for i = 1:image_height
  for j = 1:image_width
    I_denominator = image_buffer(i, j, denominator_ind);
    I_ratio = [squeeze(image_buffer(i, j, 1:denominator_ind - 1));
      squeeze(image_buffer(i, j, denominator_ind + 1: end))];
    A = I_denominator * light_ratio - I_ratio * light_denominator;
    [~, ~, v] = svd(A, 0);
    if v(3, 3) > 0
      estimated_norm(i, j, :) = v(:, 3);
    else
      estimated_norm(i, j, :) = -v(:, 3);
    end
  end
end

end