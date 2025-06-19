% 1. Създаваме размит контролер за затопляне
fis = mamfis('Name', 'HeatingSystemFuzzyController');

% 2. Добавяме входна променлива TemperatureDifference (желана - реална температура)
fis = addInput(fis, [-10 10], 'Name', 'TemperatureDifference');

% 3. Добавяме изходна променлива HeatingPower
fis = addOutput(fis, [0 100], 'Name', 'HeatingPower');

% 4. Дефинираме трапецовидни функции за входната променлива (TemperatureDifference)
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [-10 -10 -3 0], 'Name', 'Cold');
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [-1 0 0 1], 'Name', 'Moderate');
fis = addMF(fis, 'TemperatureDifference', 'trapmf', [0 3 10 10], 'Name', 'Hot');

% 5. Дефинираме трапецовидни функции за изходната променлива (HeatingPower)
fis = addMF(fis, 'HeatingPower', 'trapmf', [0 0 10 30], 'Name', 'Low');
fis = addMF(fis, 'HeatingPower', 'trapmf', [20 40 60 80], 'Name', 'Medium');
fis = addMF(fis, 'HeatingPower', 'trapmf', [60 80 100 100], 'Name', 'High');

% 6. Добавяме размити правила за затопляне
% Логика: колкото по-студено е, толкова по-силно трябва да затопляме
ruleList = [
    1 3 1 1;  % Ако е студено, мощността на затопляне е висока
    2 2 1 1;  % Ако е умерено, мощността на затопляне е средна
    3 1 1 1   % Ако е горещо, мощността на затопляне е ниска
];
fis = addRule(fis, ruleList);

% 7. Визуализираме функциите на принадлежност
figure;
subplot(2,1,1);
plotmf(fis, 'input', 1);
title('Temperature Difference - Membership Functions');

subplot(2,1,2);
plotmf(fis, 'output', 1);
title('Heating Power - Membership Functions');

% 8. Запазваме контролера
writeFIS(fis, 'HeatingFuzzyController.fis');

% 9. Тестваме контролера с входна стойност TemperatureDifference = -5
output = evalfis(fis, [-5]);
disp(['Heating Power Output for Temperature Difference of -5: ', num2str(output)]);
