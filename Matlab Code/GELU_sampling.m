% This code is for the graph and sampling of GELU activation function;
x = -10:0.001:10;
y = 0.5 * x .* (1 + erf(x / sqrt(2)));

% sampling;
samples = 1024;
t = -6:(12/(samples-1)):6;
y_sampled = 0.5 * t .* (1 + erf(t / sqrt(2)));

stem(t,y_sampled);
grid on;


% Pasting samples to csv file;
file_name = "GElU.csv";
writematrix(y_sampled, file_name); 
