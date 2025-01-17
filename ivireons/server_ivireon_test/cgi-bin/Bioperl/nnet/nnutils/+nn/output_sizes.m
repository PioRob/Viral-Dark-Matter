function sizes = output_sizes(net)
%OUTPUT_SIZES Output sizes of a neural network

% Copyright 2010 The MathWorks, Inc.

sizes = zeros(net.numOutputs,1);
outputInd = find(net.outputConnect);
for i=1:net.numOutputs
  sizes(i) = net.outputs{outputInd(i)}.size;
end
