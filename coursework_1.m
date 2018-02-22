%% Read, convert colour space to grayscale and then perform noise-removal via Gaussian filtering.
% Assume the image to be read is stored in the same directory as this
% script with the name 'image.bmp'
% Stuff we need to count is always coloured green.
% Literally any other colour is useless as we only need count nuclei
imgdata = imread('image.bmp');
% should be fine to extract rgb straight out of the image
red = imgdata(:,:,1);
green = imgdata(:,:,2);
blue = imgdata(:,:,3);
% clean noise by using matlab standard gaussian filtering
green = imgaussfilt(green);
% normalise colours
green = (green - (red + blue)/2.0);
%% Retrieve the threshold automatically by getting the mean gray intensity of all pixels which have an intensity above zero.
% This algorithm essentially asserts that the threshold == average
% intensity of a pixel belonging to a nucleus.
green_size = size(green);
total = mean(mean(green)) * green_size(1) * green_size(2);
num_zeros = numel(green(green < 1));
num_non_zeros = (green_size(1) * green_size(2)) - num_zeros;
mean_threshold = total / num_non_zeros;
%% Apply generated threshold to create the final binary image.
green(green < mean_threshold) = 0;
green(green > mean_threshold) = 255;
%% Use bwmorph-remove, a binary image processing standard function, to only show the outline of each nucleus, making it easy to count them.
% The commented line below applies bwmorph-remove until the image does not
% change. This is the behaviour we want, but if we apply it step-by-step,
% counting each time, we can very easily retrieve the number of nuclei
% detected.
green = bwmorph(green, 'remove', Inf);
imshow(green);

