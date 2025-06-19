% 1. Създаваме размит контролер
fis = mamfis('Name', 'CoolingSystemFuzzyController');

% 2. Добавяме входна променлива TemperatureDifference
fis = addInput(fis, [-10 10], 'Name', 'TemperatureDifference');
%fis = addInput(fis, [0 100], 'Name', 'ACPower');  % Мощност на климатика -добавена за симулацията 29.04


% 3. Добавяме изходна променлива CoolingPower
fis = addOutput(fis, [0 100], 'Name', 'CoolingPower');

% 4. Дефинираме трапецовидни функции за входната променлива (TemperatureDifference)
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [-10 -10 -3 0], 'Name', 'Cold');
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [-1 0 0 1], 'Name', 'Moderate');
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [0 3 10 10], 'Name', 'Hot');



% 5. Дефинираме трапецовидни функции за изходната променлива (CoolingPower)
fis = addMF(fis, 'CoolingPower', 'trapmf', [0 0 10 30], 'Name', 'Low');
fis = addMF(fis, 'CoolingPower', 'trapmf', [20 40 60 80], 'Name', 'Medium');
fis = addMF(fis, 'CoolingPower', 'trapmf', [60 80 100 100], 'Name', 'High');


% 6. Добавяме размити правила
ruleList = [
    1 1 1 1;  % Ако е студено, мощността на охлаждане е ниска
    2 2 1 1;  % Ако е умерено, мощността на охлаждане е средна
    3 3 1 1   % Ако е горещо, мощността на охлаждане е висока
];
fis = addRule(fis, ruleList);

% 7. Визуализираме функциите на принадлежност
figure;
subplot(2,1,1);
plotmf(fis, 'input', 1);
title('Temperature Difference - Membership Functions');

subplot(2,1,2);
plotmf(fis, 'output', 1);
title('Cooling Power - Membership Functions');

% 8. Запазваме контролера
writeFIS(fis, 'CoolingFuzzyController.fis');

% 9. Тестваме контролера с входна стойност TemperatureDifference = 5
output = evalfis(fis, [5]);
disp(['Cooling Power Output for Temperature Difference of 5: ', num2str(output)]);
