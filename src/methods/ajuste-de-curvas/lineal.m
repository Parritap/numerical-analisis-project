    % Ajuste de curvas lineal
    % cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "guia/datos.csv\n6\n7" | ./run_matlab.sh src/methods/ajuste-de-curvas/lineal.m

    function linearRegression()
        format long;

        % Obtener el directorio del script y cambiar al directorio del proyecto
        scriptPath = fileparts(mfilename('fullpath'));
        projectPath = fullfile(scriptPath, '..', '..', '..');
        cd(projectPath);
        disp(['Directorio de trabajo: ' pwd]);

        % Solicitar el nombre del archivo CSV
        disp('Ingrese la ruta del archivo CSV (relativa al directorio del proyecto):');
        filename = input('Archivo: ', 's');

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

        % Solicitar las columnas a usar
        disp('Ingrese el numero de columna para la variable independiente (x):');
        col_x = input('Columna x: ');
        disp('Ingrese el numero de columna para la variable dependiente (y):');
        col_y = input('Columna y: ');

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
