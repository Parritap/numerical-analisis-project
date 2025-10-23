    % Ajuste de curvas lineal
    % cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "[1,4;-2,5;3,-1;4,1]" | ./run_matlab.sh src/methods/ajuste-de-curvas/lineal.m

    function linearRegression()
        format long;

        % Ingrese los datos en el formato [x1, y1; x2, y2; ...]
        disp('Ingrese los datos en el formato [x1, y1; x2, y2; ...]:');
        data = input('Datos = ');

        % Extraer las coordenadas x e y de los datos
        x = data(:, 1);
        y = data(:, 2);

        % Número de puntos de datos
        n = length(x);

        % Calcular las sumas necesarias para el ajuste lineal
        sumX = sum(x);
        sumY = sum(y);
        sumXY = sum(x .* y); % "Element wise operation, ie. x1 * y1 + x2 * y2 + x3 * y3 + ...
        sumX2 = sum(x .^ 2); % Element wise operation, eleva cada término de la matriz al cuadrado.

        % Calcular los coeficientes de la regresión lineal (y = mx + b)
        m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX ^ 2);
        b = (sumY - m * sumX) / n;

        % Mostrar los coeficientes de la regresión lineal
        disp('Coeficientes de la regresión lineal:');
        disp(['Pendiente (m): ' num2str(m)]);
        disp(['Intercepto (b): ' num2str(b)]);
       fprintf('\033[32mLa función lineal ajustada es: y = %.4fx + %.4f\033[0m\n', m, b);

        % Graficar los datos y la línea de regresión lineal
        fplot(@(x) m * x + b, [min(x) max(x)]);
        hold on;
        scatter(x, y, 'r', 'filled');
        title('Ajuste Lineal (Regresión Lineal)');
        xlabel('x');
        ylabel('y');
        legend('Regresión Lineal', 'Datos', 'Location', 'Best');
        grid on;
        hold off;
    end

    linearRegression()
