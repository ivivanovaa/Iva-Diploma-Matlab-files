% 1. Създаваме размит контролер
fis = mamfis('Name', 'InverterFuzzyController');

% 2. Добавяме входна променлива TemperatureDifference
% Стойности: -10 (много по-студено от желаното) до +10 (много по-горещо)
fis = addInput(fis, [-10 10], 'Name', 'TemperatureDifference');

% 3. Добавяме изходна променлива Power (от -100 до +100)
% -100: силно охлаждане, 0: не прави нищо, +100: силно затопляне
fis = addOutput(fis, [-100 100], 'Name', 'Power');

% 4. Функции за входа (TemperatureDifference)
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [-10 -10 -4 -1], 'Name', 'Cold');
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [-2 -0.5 0.5 2], 'Name', 'Comfortable');
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [1 4 10 10], 'Name', 'Hot');

% 5. Функции за изхода (Power)
fis = addMF(fis, 'Power', 'trapmf', [-100 -100 -70 -40], 'Name', 'CoolStrong');
fis = addMF(fis, 'Power', 'trapmf', [-60 -30 0 0], 'Name', 'CoolLight');
fis = addMF(fis, 'Power', 'trapmf', [0 0 30 60], 'Name', 'HeatLight');
fis = addMF(fis, 'Power', 'trapmf', [40 70 100 100], 'Name', 'HeatStrong');

% 6. Размити правила
ruleList = [
    1 4 1 1;  % Cold -> HeatStrong
    2 1 1 1;  % Comfortable -> CoolLight
    2 3 1 1;  % Comfortable -> HeatLight
    3 2 1 1;  % Hot -> CoolStrong
    % 2 2 1 1;  % Comfortable -> 0 (няма нужда от действие)
];
% Обяснение: когато сме в комфортната зона, и изходът може да е 0
fis = addRule(fis, ruleList);

% 7. Визуализация
figure;
subplot(2,1,1);
plotmf(fis, 'input', 1);
title('Temperature Difference - Membership Functions');

subplot(2,1,2);
plotmf(fis, 'output', 1);
title('Power (Negative = Cooling, Positive = Heating)');

% 8. Записване
writeFIS(fis, 'InverterFuzzyController.fis');

% 9. Тест
output = evalfis(fis, [-6]); % Стаята е с 6 градуса по-студена от желаното
disp(['Power Output for Temperature Difference -6: ', num2str(output)]);
