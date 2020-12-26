
%close all
clear

%% Constants
WINDOW_SIZE = 1000;
AVE_PERIOD = 500;


%% Load Data

%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 15th 2015 getOrientation\2015-03-15T082113-968_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\W%rkout March 15th 2015 getOrientation\2015-03-15T082252-598_0.csv'); % 7 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 15th 2015 getOrientation\2015-03-15T082600-030_0.csv'); % 3 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 15th 2015 getOrientation\2015-03-15T082955-333_0.csv');
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T064221-540_0.csv'); % 4 Laps w/ rapid null after last flipturn
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T064422-316_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T064559-647_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T064753-370_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T064937-793_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T065113-774_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T065249-045_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T065423-282_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T065559-815_0.csv'); % 4 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T065754-783_0.csv'); % 4 Laps Backstroke (This really messes up the data)
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T070618-352_0.csv'); % 6 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T070839-853_0.csv'); % 6 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T071053-374_0.csv'); % 6 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T071308-538_0.csv'); % 6 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T071535-122_0.csv'); % 8 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 17th 2015 getOrientation\2015-03-17T071839-780_0.csv'); % 8 Laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle Workouts getOrientation\2015-03-19T072256-129_0.csv'); % Full workout
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle Workouts getOrientation\2015-03-18T073023-673_0.csv'); % Full workout
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle oac\2015-03-20T073658-290_0.csv'); % bad result
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle oac\2015-03-20T073847-305_0.csv'); % bad result
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle oac\2015-03-20T074038-755_0.csv'); % bad result
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle oac\2015-03-20T074215-339_0.csv');  % bad result
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle oac\2015-03-20T074400-325_0.csv'); % 4 laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Freestyle oac\2015-03-20T074537-920_0.csv');
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 22nd 2015 ogla\2015-03-22T081649-571_0.csv'); % 4 laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 22nd 2015 ogla\2015-03-22T081833-583_0.csv');
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 22nd 2015 ogla\2015-03-22T082024-727_0.csv');
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\Workout March 22nd 2015 ogla\2015-03-22T084749-909_0.csv'); %Workout

%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-03-27T060921-434_0.csv'); % 250 300 300 10x50 6x100 250 - 88 laps
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-03-23T072810-011_0.csv'); % 70 laps (9+11+10+10+10+10+10)
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-03-24T073111-646_0.csv',1); % problematic
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-03-25T073120-941_0.csv',1); % 64 laps (16 + 12*3 + 12)
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-03-29T081705-237_0.csv'); % 128 laps (22+2+12*3+8*3+4*3+2*3+12+8+4+2) long peroids of nothing; hard to process
%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-03-31T070354-876_0.csv'); % 106 laps (13 + 19 + 8 + 8 kick + 8 + 10 + 10 kick + 10 + 6*2 + 8)
csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-04-01T072152-367_0.csv'); % stopped part way through

%csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\March Workouts ogl\2015-04-02T071712-613_0.csv');
csv_data = csvread('C:\Users\Jon Peck\Documents\Swimming Data\April Workouts ogl\2015-04-06T072952-507_0.csv'); % stopped part way through
%% Read out data
csv_data(end,:) = []; % last item is bad

t = csv_data(:,1);
azimuth_c = csv_data(:,2);
pitch_c = csv_data(:,3);
roll_c = csv_data(:,4);

g_x = csv_data(:,5);
g_y = csv_data(:,6);
g_z = csv_data(:,7);
% g_m = sqrt((g_x.^2 + g_y.^2 + g_z.^2)); % is always 9.8

la_x = csv_data(:,8);
la_y = csv_data(:,9);
la_z = csv_data(:,10);
la_m = sqrt((la_x.^2 + la_y.^2 + la_z.^2));



%% Period based average
% This simulates live data

lap_count = 0;

PERIOD_MS = 2000; % ~2 seconds is good for laps; 200 ms is good for strokes
LAP_CHECK_PERIODS = 2;
THRESHOLD = 1;

MEAN_ACCEL_THESHOLD = 5;

start_time = t(1);
start_index = 1;
mean_compass = [];
mean_accel = [];
mean_g = [];


for i = 2:size(t)
    stop_time = t(i);
    if (stop_time - start_time) > PERIOD_MS
        x = sum(cos(azimuth_c(start_index:i)))/numel(start_index:i);
        y = sum(sin(azimuth_c(start_index:i)))/numel(start_index:i);
        average_angle = atan2(y,x);
        mean_compass = [mean_compass ; average_angle];
        %mean_accel = [mean_accel; sum(la_m(start_index:i))/numel(start_index:i)];
        mean_accel = [mean_accel; sum(la_m(start_index:i))/numel(start_index:i)];
        mean_g = [mean_g; sum(g_y(start_index:i))/numel(start_index:i)]; % gravity along y seems to match up with stroke accel
        start_index = i;
        start_time = t(i);
        num_means = numel(mean_compass);      
    end
end
    
%% Pick the first peak
% TODO: make work in for loop
% FIXME: This does work for large sets of data that have time at the wall

%sum(diff(find(delta > THRESHOLD)) > GUARD_CELLS) + 2

% sum(abs(lap_check) > LAP_THRESHOLD) + 1


%% Jacobson/Karel TCP timeout based
BAIS = 0.25;%BAIS = 1;
MIN_LAP_TIME_S = 12;
MIN_LAP_PERIODS = MIN_LAP_TIME_S/(PERIOD_MS/1000);
COMPASS_PERIOD_OFFSET = 1;
COMPASS_THRESHOLD = 2*pi/3;
INTEGRATED_ACCEL_THRESHOLD = 110;
AJDACENT_LAP_START_WINDOW = MIN_LAP_PERIODS;
MIN_DEVIATION = 0.35;

y = mean_accel(1);
e = mean_accel(1);
d = mean_accel(1);

NEW_VALUE_WEIGHT = 0.45;
H = 0.25;
lap_end = 1;
average_angle = 0;
average_angle_i = 0;
total_accel = 0;
lap_ends = 1;
lap_starts = 1;
lap_start = 1;
threshold_passes = 1;
is_first_lap = true;
has_started_lap = false;
over_accel_threshold = false;
for i = 2:numel(mean_accel)
    s = mean_accel(i);
    y(i) = (1-NEW_VALUE_WEIGHT)*y(i-1) + NEW_VALUE_WEIGHT*s;
    e(i) = abs(s-y(i-1));
    d(i) = d(i-1) + H*(e(i) - d(i-1));
    
    last_period_over_accel_threshold = over_accel_threshold;
    
    over_accel_threshold = e(i) > (d(i)+BAIS);
    over_min_lap_time = (i - lap_start(lap_starts)) >  MIN_LAP_PERIODS;
    is_moving = d(i) > MIN_DEVIATION;
    is_rising_edge = (s-y(i-1)) > 0;
    
    if over_accel_threshold % time to check to see what we have
        start_index = lap_start(lap_starts)+COMPASS_PERIOD_OFFSET;
        stop_index = i - COMPASS_PERIOD_OFFSET;
        % Check overall acceleration
        integrated_accel = mean(mean_accel(start_index:stop_index))*(numel(start_index:stop_index)*PERIOD_MS/1000);
        total_accel = [total_accel integrated_accel];
        threshold_passes = [threshold_passes i];
        if is_rising_edge
            %not_adjacent_lap_start = (i - lap_start(lap_starts)) > AJDACENT_LAP_START_WINDOW;
            %if not_adjacent_lap_start && is_rising_edge
                lap_start = [lap_start i];
                lap_starts = lap_starts + 1;
                has_started_lap = true;
            %end
            continue;
        end
        
        
        if is_moving
            last_lap_end = lap_end(end);
            lap_end = [lap_end i];
            lap_start = [lap_start i];
            lap_ends = lap_ends + 1;
            lap_starts = lap_starts + 1;
        end
    elseif last_period_over_accel_threshold % Post process
        % Get all over the minimum lap time
        possible_lap_ends = find(lap_end > (i-MIN_LAP_PERIODS));
        if ~isempty(possible_lap_ends)
            bad_lap_ends = possible_lap_ends(1:end-1); %only keep the last
            lap_end(bad_lap_ends) = [];
            lap_ends = lap_ends - numel(bad_lap_ends);
        
            possible_lap_start = find(lap_start < (i-MIN_LAP_PERIODS)); % TODO: Need to clean up lap start
            start_index = max(possible_lap_start);
            stop_index = lap_end(end);
            a = sum(cos(mean_compass(start_index:stop_index)))/numel(start_index:stop_index);
            b = sum(sin(mean_compass(start_index:stop_index)))/numel(start_index:stop_index);
            average_angle = [average_angle atan2(b,a)]; % TODO: Need to figure out how to use this data to validate laps
            average_angle_i = [average_angle_i lap_end(end)];
        end
        
    end
        
        
end
numel(lap_end)

%%
angle_diff = abs(diff(mean_compass));
angle_diff(angle_diff > pi) = 2*pi - angle_diff(angle_diff > pi);

%% CFAR
GUARD_CELLS = 2;
REFERENCE_CELLS = 4;

delta = zeros(size(angle_diff));
for i = (1+GUARD_CELLS+REFERENCE_CELLS):(numel(angle_diff) - (GUARD_CELLS+REFERENCE_CELLS))
    left_sum = sum(angle_diff(i-(GUARD_CELLS+REFERENCE_CELLS)):angle_diff(i-GUARD_CELLS));
    right_sum = sum(angle_diff(i+GUARD_CELLS):angle_diff(i+(GUARD_CELLS+REFERENCE_CELLS)));
    reference = mean([left_sum right_sum]);
    delta(i) = angle_diff(i) - reference;
end

%% Plots

figure;hold all;plot(mean_compass);plot(mean_accel);plot(y);plot(e);plot(d+BAIS)

%lap_end = find(e > (d+BAIS));
%first_hit = lap_end(find(diff(lap_end) > MIN_LAP_PERIODS)+1);
stem(lap_end,ones(size(lap_end))*3,'r')
stem(lap_start,ones(size(lap_start))*2,'g')
%plot(average_angle_i,average_angle,'kx')
plot(2:numel(y),angle_diff*10,'k')
plot(threshold_passes,total_accel/10,'k.');
plot(2:numel(y),delta*10,'m')
legend('compass','accel','ave','err','dev','end','start','diff','threshold')
%figure;hold on;plot(csv_data(:,1),csv_data(:,2),'r');plot(csv_data(:,1),csv_data(:,3),'g');plot(csv_data(:,1),csv_data(:,4),'b')

%figure;hold on;plot(t,x_c,'r');plot(t,z_c,'b')

%%
to = (t - min(t))/1e3 - 109; % offset to make the plot pretty
figure;hold all;plot(to,g_x);plot(to,g_y);plot(to,g_z);plot(to,la_m)
legend('g_x','g_y','g_z','a_m')
xlabel('Time (s)')
ylabel('Magitude')

% %%
% figure;
% hold all;
% for i = 1:numel(compass_data)
%     plot(diff(compass_data{i}));
% end

%%
%figure;hold on;plot(x_c+y_c+z_c)
% 
% crossings = crossing(x_c+y_c+z_c)
% 
% plot(crossings,zeros(size(crossings)),'rx')
% 
% disp([ num2str(numel(crossings)) ' laps'])

%% 
%figure;hold on;plot(t(2:end),diff(x_c+y_c+z_c))


%figure;scatter3(csv_data(:,2),csv_data(:,3),csv_data(:,4));