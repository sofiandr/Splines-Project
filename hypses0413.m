
%% Session list for 24 Hour sleep data
% Set session list

id = 0;
clear sesInfo;
ProbeDate = datenum('2023-12-08')
channelRSC = 'resampled_csc26.mat'
%% id = 1
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-15_12-22-16',...
    'hyp', 'Hypnogram_01-23-23_VM_FINAL_MERGED.mat', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 7);
%% id = 2
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-16_12-00-36', ...
    'hyp', 'Hypnogram_01-23-23_VM_FINAL_MERGED.mat', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 8);
%% id = 3 
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-17_12-03-10', ...
    'hyp', 'Hypnogram_02-04-23_VM_FINAL_MERGED.mat', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 9);
%% id = 4
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-18_11-59-39', ...
    'hyp', 'Hypnogram_02-05-23_VM_FINAL_MERGED.mat', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 10);
%% id = 5
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-20_12-58-15', ...
    'hyp', 'Hypnogram_02-13-23_VM_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2022-12-20_12-18-27', ...
    'day', 12);
%% id = 6
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-21_13-00-46', ...
    'hyp', 'Hypnogram_02-13-23_VM_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2022-12-21_12-11-49', ...
    'day', 13);

%% id = 7
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-25_13-15-23', ...
    'hyp', 'Hypnogram_02-14-23_ADL_FINAL_MERGED.mat', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 17);
%% id = 8
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-26_13-54-40', ...
    'hyp', 'Hypnogram_02-28-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2022-12-26_12-49-38', ...
    'day', 18);
%% id = 9
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2022-12-27_13-29-52', ...
    'hyp', 'Hypnogram_02-28-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2022-12-27_12-27-09', ...
    'day', 19);
%% id = 10
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2022-12-30_13-18-41', ...
    'hyp', 'Hypnogram_02-28-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2022-12-30_12-12-39', ...
    'day', 20);
%% id = 11
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2022-12-31_13-19-17', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2022-12-31_12-11-24', ...
    'day', 21);
%% id = 12
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2023-01-01_15-22-25', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 22);
%% id = 13
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2023-01-02_12-07-35', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 23);
%% id = 14
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2023-01-03_13-05-55', ...
    'hyp', 'Hypnogram_03-05-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2023-01-03_12-00-08', ...
    'day', 24);
%% id = 15
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2023-01-04_12-58-01', ...
    'hyp', 'Hypnogram_01-24-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2023-01-04_11-54-24', ...
    'day', 25);
%% id = 17
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'dual_Mo-0413_2023-01-05_12-05-14', ...
    'hyp', 'Hypnogram_03-05-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 26);
%% id = 17
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2023-01-06_13-25-18', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', NaN, ...
    'day', 27);
%% id = 18
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2023-01-08_13-09-54', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', channelRSC, ...
    'beh', 'Mo-0413_2023-01-08_12-03-41', ...
    'day', 29);
%% id = 19
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2023-01-10_12-32-16', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', 'resampled_csc25.mat', ...
    'beh', NaN, ...
    'day', 31);
%% id = 21
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2023-01-12_13-54-49', ...
    'hyp', 'Hypnogram_03-01-23_ADL_FINAL_MERGED', ...
    'csc', 'resampled_csc25.mat', ...
    'beh', 'Mo-0413_2023-01-12_12-52-11', ...
    'day', 33);
%% id = 21
id = id + 1;
sesInfo(id) = struct(...
    'ses', 'one_Mo-0413_2023-01-14_11-13-12', ...
    'hyp', 'Hypnogram_03-02-23_ADL_FINAL_MERGED', ...
    'csc', 'resampled_csc25.mat', ...
    'beh', NaN, ...
    'day', 35);