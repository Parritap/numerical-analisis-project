% Ajuste de curvas cuadratico
    % NOTA!!!!!! -> Es mejor dar la ruta absoluta del CSV para evitar errores
    % cd /Users/esteban/git-repos/numerical-analisis-project && ./run_matlab.sh src/methods/ajuste-de-curvas/cuadratico.m

    function quadraticRegression(filename, col_x, col_y)
        % quadraticRegression - Realiza regresion cuadratica sobre datos de un archivo CSV
        %
        % Sintaxis: quadraticRegression(filename, col_x, col_y)
        %
        % Argumentos:
        %   filename - Ruta al archivo CSV (relativa a la raiz del proyecto)
        %   col_x    - Numero de columna para la variable independiente (x)
        %   col_y    - Numero de columna para la variable dependiente (y)
        %
        % Ejemplo:
        %   quadraticRegression('guia/datos.csv', 6, 7)
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
            
            % Obtener nombres de las columnas seleccionadas
            column_names = headers.Properties.VariableNames;
            x_label = strrep(column_names{col_x}, '_', ' ');
            y_label = strrep(column_names{col_y}, '_', ' ');
            
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
        
        % Validar que haya al menos 3 puntos para la regresión cuadrática
        if n <= 2
            error('Se requieren al menos 3 puntos para la regresion cuadratica.');
        end
        
        % Realizar regresión cuadrática (ajustar un polinomio de grado 2)
        % polyfit retorna los coeficientes [a, b, c] para ax^2 + bx + c
        p = polyfit(x, y, 2);
        
        % Mostrar los coeficientes del polinomio cuadrático
        disp('Coeficientes del polinomio cuadratico:');
        disp(['a (coef. x^2): ' num2str(p(1))]);
        disp(['b (coef. x): ' num2str(p(2))]);
        disp(['c (intercepto): ' num2str(p(3))]);
        
        % Imprimir la ecuación final en color verde usando códigos ANSI
        % Formato: f(x) = ax^2 + bx + c
        fprintf('\033[32mLa funcion cuadratica ajustada es: y = %.4fx^2 + %.4fx + %.4f\033[0m\n', p(1), p(2), p(3));
        
        % Generar puntos para graficar la curva ajustada
        x_fit = linspace(min(x), max(x), 100);  % Crear 100 puntos equiespaciados entre el x mínimo y máximo
        y_fit = polyval(p, x_fit);               % Evaluar el polinomio en estos puntos
        
        % Graficar los puntos de datos originales como círculos rellenos
        scatter(x, y, 80, 'b', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1, 'MarkerFaceAlpha', 0.6);
        hold on;  % Mantener el gráfico para agregar más elementos
        
        % Graficar la curva cuadrática ajustada como una línea roja
        plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
        
        % Agregar etiquetas y formato al gráfico usando los nombres de las columnas
        xlabel(x_label, 'FontSize', 12, 'FontWeight', 'bold');
        ylabel(y_label, 'FontSize', 12, 'FontWeight', 'bold');
        title(['Regresion Cuadratica: ' y_label ' vs ' x_label], 'FontSize', 14, 'FontWeight', 'bold');
        legend('Datos', sprintf('y = %.4fx^2 + %.4fx + %.4f', p(1), p(2), p(3)), 'Location', 'best');
        grid on;   % Mostrar líneas de cuadrícula
        hold off;  % Liberar el gráfico
    end
    quadraticRegression('/Users/esteban/git-repos/numerical-analisis-project/guia/datos.csv', 6, 7)