    % Ajuste de curvas lineal
    % cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "guia/datos.csv\n6\n7" | ./run_matlab.sh src/methods/ajuste-de-curvas/lineal.m

    function linearRegression(filename, col_x, col_y)
        format long;

        % Obtener el directorio del script y cambiar al directorio del proyecto
        scriptPath = fileparts(mfilename('fullpath'));
        projectPath = fullfile(scriptPath, '..', '..', '..');
        cd(projectPath);
        disp(['Directorio de trabajo: ' pwd]);

        % Leer el archivo CSV
        try
            opts = detectImportOptions(filename, 'Delimiter', ';', 'DecimalSeparator', ',');
            % Leer encabezados primero para mostrar columnas disponibles
            headers = readtable(filename, opts, 'ReadRowNames', false);
            disp('Archivo cargado exitosamente.');
            disp(['Columnas disponibles: ' strjoin(headers.Properties.VariableNames, ', ')]);
            
            % Ahora leer solo los datos numericos
            data = readmatrix(filename, 'Delimiter', ';', 'DecimalSeparator', ',');
            disp(['Numero de filas: ' num2str(size(data, 1))]);
        catch ME
            disp(['Error: ' ME.message]);
            error('No se pudo leer el archivo. Verifique la ruta y el formato.');
        end

        % Extraer las coordenadas x e y de las columnas especificadas
        x = data(:, col_x);
        y = data(:, col_y);
        
        % Verificar que los datos sean numericos
        if ~isnumeric(x) || ~isnumeric(y)
            error('Las columnas seleccionadas deben contener datos numericos.');
        end
        
        % Eliminar filas con valores NaN
        valid_idx = ~isnan(x) & ~isnan(y);
        x = x(valid_idx);
        y = y(valid_idx);

        % Número de puntos de datos
        n = length(x);
        disp(['Numero de puntos validos: ' num2str(n)]);

        % Calcular las sumas necesarias para el ajuste lineal
        sumX = sum(x);
        sumY = sum(y);
        sumXY = sum(x .* y); % "Element wise operation, ie. x1 * y1 + x2 * y2 + x3 * y3 + ...
        sumX2 = sum(x .^ 2); % Element wise operation, eleva cada término de la matriz al cuadrado.

        % Calcular los coeficientes de la regresión lineal (y = mx + b)
        m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX ^ 2);
        b = (sumY - m * sumX) / n;

        % Mostrar los coeficientes de la regresión lineal
        disp('Coeficientes de la regresion lineal:');
        disp(['Pendiente (m): ' num2str(m)]);
        disp(['Intercepto (b): ' num2str(b)]);
        fprintf('\033[32mLa funcion lineal ajustada es: y = %.4fx + %.4f\033[0m\n', m, b);

        % Graficar los datos y la linea de regresion lineal
        scatter(x, y, 80, 'b', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1, 'MarkerFaceAlpha', 0.6);
        hold on;
        x_plot = linspace(min(x), max(x), 100);
        y_plot = m * x_plot + b;
        plot(x_plot, y_plot, 'r-', 'LineWidth', 2);
        xlabel('Variable Independiente (x)', 'FontSize', 12, 'FontWeight', 'bold');
        ylabel('Variable Dependiente (y)', 'FontSize', 12, 'FontWeight', 'bold');
        title('Regresion Lineal', 'FontSize', 14, 'FontWeight', 'bold');
        legend('Datos', 'Regresion Lineal', 'Location', 'best');
        grid on;
        hold off;
    end
    linearRegression('/Users/esteban/git-repos/numerical-analisis-project/guia/datos.csv', 6, 7)
