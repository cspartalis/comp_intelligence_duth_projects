%% students
% Xristoforos Spartalis 56785
% Ilias Papadeas 56989

%% create the datasets
%generate 200 random numbers for x [-2,2]
x = -2 + 4.*rand(200,1);

%generate 200 random numbers for y [-2,2]
y = -2 + 4.*rand(200,1);

%solutions of the function f(x,y)
sol = [0.5*exp(x) + cos(3*pi*y)];

%matrix with inputs and outputs
data = [x y sol];

%split data into datasets
train_ds = data (1:140,:);
test_ds = data (141:end,:);

%split dataset into input and target
train_input = train_ds (:, [1,2]);
train_target = train_ds (:, [3]);

test_input = test_ds (:, [1,2]);
test_target = test_ds (:, [3]);

%transpose columns to rows
train_input = train_input.';
train_target = train_target.';

test_input = test_input.';
test_target = test_target.';

%% create the neural network

%create the PR matrix with
% | min_x max_x |
% | min_y max_y |

PR = minmax(train_input);

%The net has one input layer with 2 neurons
%two hidden layers with 30 neurons each and
%one output layer with 1 neuron
% the first two activate functions are sigmmoid and the last one is linear
net = newff (PR, [100 100 1], {'tansig', 'tansig', 'purelin'}, 'traingd');
view(net);

%% training and testing
[net, tr] = train (net, train_input, train_target);

a = sim (net, test_input);

err = a - test_target;

%% plots
figure(1);
plot(test_target, '-o');
hold on;
plot(a, '-x');
legend ('real', 'estimated');
hold off;

zeroAxis = zeros(60);
figure(2);
plot (err,'*c');
hold on;
plot (zeroAxis);
legend ('error');
hold off;


