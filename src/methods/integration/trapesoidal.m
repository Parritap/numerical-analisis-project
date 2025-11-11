% Integracion Trapezoidal
    % NOTA!!!!!! -> Es mejor dar la ruta absoluta del CSV para evitar errores
    % cd /Users/esteban/git-repos/numerical-analisis-project && ./run_matlab.sh src/methods/integration/trapesoidal.m

    function trapezoidalIntegration(filename, col_x, col_y)
        % trapezoidalIntegration - Realiza integracion numerica usando la Regla del Trapecio sobre datos de un archivo CSV
        %
        % Sintaxis: trapezoidalIntegration(filename, col_x, col_y)
        %
        % Argumentos:
        %   filename - Ruta al archivo CSV (relativa a la raiz del proyecto)
        %   col_x    - Numero de columna para la variable independiente (x)
        %   col_y    - Numero de columna para la variable dependiente (y)
        %
        % Ejemplo:
        %   trapezoidalIntegration('guia/datos.csv', 6, 7)
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
        x_data = data(:, col_x);
        y_data = data(:, col_y);
        
        % Verificar que los datos sean numericos
        if ~isnumeric(x_data) || ~isnumeric(y_data)
            error('Las columnas seleccionadas deben contener datos numericos.');
        end
        
        % Eliminar filas con valores NaN
        valid_idx = ~isnan(x_data) & ~isnan(y_data);
        x_data = x_data(valid_idx);
        y_data = y_data(valid_idx);

        % Ordenar los datos por x (requerido para integracion)
        [x_data, sort_idx] = sort(x_data);
        y_data = y_data(sort_idx);

        % Numero de puntos
        n = length(x_data);
        disp(['Numero de puntos validos: ' num2str(n)]);
        
        % Validar que haya al menos 2 puntos
        if n <= 1
            error('Se requieren al menos 2 puntos para la integracion.');
        end
        
        % Aplicar la Regla del Trapecio
        % Formula: Integral ≈ Σ[(x[i+1] - x[i]) * (y[i] + y[i+1]) / 2]
        integral = 0.0;
        detalles = cell(n-1, 1);
        
        for i = 1:(n-1)
            h = x_data(i+1) - x_data(i);  % Ancho del intervalo
            area_parcial = h * (y_data(i) + y_data(i+1)) / 2;
            integral = integral + area_parcial;
            
            % Guardar detalles de cada trapecio
            detalles{i} = struct('intervalo', sprintf('[%.2f, %.2f]', x_data(i), x_data(i+1)), ...
                                 'h', h, ...
                                 'area', area_parcial);
        end
        
        % Mostrar resultados
        fprintf('\n');
        fprintf('========================================================================\n');
        fprintf('INTEGRACION NUMERICA: Regla del Trapecio\n');
        fprintf('========================================================================\n');
        fprintf('\n');
        fprintf('Variables: %s (X) vs %s (Y)\n', x_label, y_label);
        fprintf('Rango de integracion: [%.2f, %.2f]\n', x_data(1), x_data(end));
        fprintf('Numero de intervalos (trapecios): %d\n', n-1);
        fprintf('\n');
        fprintf('\033[32mArea bajo la curva (Integral): %.6f\033[0m\n', integral);
        fprintf('\n');
        
        % Mostrar detalles de los primeros 5 trapecios
        fprintf('Detalles de los primeros 5 trapecios:\n');
        fprintf('------------------------------------------------------------------------\n');
        fprintf('%-20s %-15s %-15s\n', 'Intervalo', 'Ancho (h)', 'Area Parcial');
        fprintf('------------------------------------------------------------------------\n');
        
        num_mostrar = min(5, length(detalles));
        for i = 1:num_mostrar
            det = detalles{i};
            fprintf('%-20s %-15.4f %-15.6f\n', det.intervalo, det.h, det.area);
        end
        
        if length(detalles) > 5
            fprintf('... (%d trapecios mas)\n', length(detalles) - 5);
        end
        fprintf('========================================================================\n');
        
        % Graficar los datos y los trapecios
        figure('Position', [100, 100, 1200, 600]);
        
        % Grafica principal
        hold on;
        
        % Dibujar los trapecios primero (para que esten detras)
        for i = 1:(n-1)
            % Coordenadas de los vertices del trapecio
            x_trap = [x_data(i), x_data(i+1), x_data(i+1), x_data(i)];
            y_trap = [0, 0, y_data(i+1), y_data(i)];
            
            % Rellenar el trapecio con color cian y borde azul
            fill(x_trap, y_trap, 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'blue', 'LineWidth', 1);
        end
        
        % Graficar la linea que conecta los puntos
        plot(x_data, y_data, 'b-', 'LineWidth', 2, 'DisplayName', 'Datos');
        
        % Graficar los puntos de datos
        scatter(x_data, y_data, 80, 'b', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1, 'DisplayName', 'Puntos de datos');
        
        % Etiquetas y titulo
        xlabel(x_label, 'FontSize', 12, 'FontWeight', 'bold');
        ylabel(y_label, 'FontSize', 12, 'FontWeight', 'bold');
        title(sprintf('Regla del Trapecio: %s vs %s\nArea = %.4f', y_label, x_label, integral), ...
              'FontSize', 14, 'FontWeight', 'bold');
        
        % Leyenda y grid
        legend('Trapecios', 'Datos', 'Puntos de datos', 'Location', 'best');
        grid on;
        hold off;
        
        % Ajustar limites del eje Y
        y_min = min(0, min(y_data));
        y_max = max(y_data);
        y_range = y_max - y_min;
        ylim([y_min - 0.05*y_range, y_max + 0.1*y_range]);
        
        disp(' ');
        disp('Grafica generada exitosamente.');
    end
    
    trapezoidalIntegration('/Users/esteban/git-repos/numerical-analisis-project/guia/datos.csv', 6, 7)