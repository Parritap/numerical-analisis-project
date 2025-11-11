% Interpolacion de Lagrange
    % NOTA!!!!!! -> Es mejor dar la ruta absoluta del CSV para evitar errores
    % cd /Users/esteban/git-repos/numerical-analisis-project && ./run_matlab.sh src/methods/interpolacion/lagrange.m

    function lagrangeInterpolation(filename, col_x, col_y, num_points)
        % lagrangeInterpolation - Realiza interpolacion de Lagrange sobre datos de un archivo CSV
        %
        % Sintaxis: lagrangeInterpolation(filename, col_x, col_y, num_points)
        %
        % Argumentos:
        %   filename   - Ruta al archivo CSV (relativa a la raiz del proyecto)
        %   col_x      - Numero de columna para la variable independiente (x)
        %   col_y      - Numero de columna para la variable dependiente (y)
        %   num_points - Numero de puntos a usar para la interpolacion (distribuidos equitativamente)
        %
        % Ejemplo:
        %   lagrangeInterpolation('guia/datos.csv', 6, 7, 10)
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
        x_all = data(:, col_x);
        y_all = data(:, col_y);
        
        % Verificar que los datos sean numericos
        if ~isnumeric(x_all) || ~isnumeric(y_all)
            error('Las columnas seleccionadas deben contener datos numericos.');
        end
        
        % Eliminar filas con valores NaN
        valid_idx = ~isnan(x_all) & ~isnan(y_all);
        x_all = x_all(valid_idx);
        y_all = y_all(valid_idx);

        % Numero total de puntos de datos disponibles
        total_points = length(x_all);
        disp(['Numero de puntos validos en el archivo: ' num2str(total_points)]);
        
        % Validar que haya al menos 2 puntos disponibles
        if total_points <= 1
            error('Se requieren al menos 2 puntos para la interpolacion.');
        end
        
        % Validar que num_points sea valido
        if num_points > total_points
            warning('El numero de puntos solicitado (%d) es mayor que los disponibles (%d). Se usaran todos los puntos.', num_points, total_points);
            num_points = total_points;
        end
        
        if num_points < 2
            error('Se requieren al menos 2 puntos para la interpolacion.');
        end
        
        % Seleccionar num_points distribuidos equitativamente
        if num_points == total_points
            % Usar todos los puntos
            selected_indices = 1:total_points;
        else
            % Distribuir equitativamente los indices
            selected_indices = round(linspace(1, total_points, num_points));
            % Asegurar que sean unicos (por si hay redondeos duplicados)
            selected_indices = unique(selected_indices);
        end
        
        % Extraer los puntos seleccionados para la interpolacion
        x_data = x_all(selected_indices);
        y_data = y_all(selected_indices);
        
        % Numero final de puntos a usar
        n = length(x_data);
        disp(['Numero de puntos seleccionados para interpolacion: ' num2str(n)]);
        disp(['Rango de x: [' num2str(min(x_data)) ', ' num2str(max(x_data)) ']']);

        syms x;
        
        % Inicializacion del polinomio interpolador
        lagrangePoly = 0;

        for i = 1:n
            % Construccion de los terminos de Lagrange
            term = y_data(i);
            for j = 1:n
                if j ~= i
                    term = term * (x - x_data(j)) / (x_data(i) - x_data(j));
                end
            end

            % Sumar terminos al polinomio interpolador
            lagrangePoly = lagrangePoly + term;
        end

        % Mostrar el polinomio interpolador
        fprintf('\033[32mEl polinomio interpolador de Lagrange es:\033[0m\n');
        poly_str = char(simplify(lagrangePoly));
        fprintf('\033[32m%s\033[0m\n', poly_str);
        
        % Imprimir mensaje en color verde
        fprintf('\033[32mPolinomio de Lagrange calculado exitosamente (grado %d)\033[0m\n', n-1);

        % Crear mascara para identificar puntos no seleccionados
        all_indices = 1:total_points;
        not_selected_mask = ~ismember(all_indices, selected_indices);
        not_selected_indices = all_indices(not_selected_mask);
        
        % Graficar primero los puntos NO seleccionados en gris
        if ~isempty(not_selected_indices)
            scatter(x_all(not_selected_indices), y_all(not_selected_indices), 50, [0.7 0.7 0.7], 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 0.5, 'MarkerFaceAlpha', 0.4);
            hold on;
        end
        
        % Graficar los puntos seleccionados en verde
        scatter(x_data, y_data, 80, 'g', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5, 'MarkerFaceAlpha', 0.7);
        
        % Graficar el polinomio interpolador en verde
        fplot(lagrangePoly, [min(x_data) max(x_data)], 'g-', 'LineWidth', 2);
        
        % Agregar etiquetas y formato al grafico usando los nombres de las columnas
        xlabel(x_label, 'FontSize', 12, 'FontWeight', 'bold');
        ylabel(y_label, 'FontSize', 12, 'FontWeight', 'bold');
        title(['Interpolacion de Lagrange: ' y_label ' vs ' x_label ' (n=' num2str(n) ')'], 'FontSize', 14, 'FontWeight', 'bold');
        
        % Leyenda apropiada segun si hay puntos no seleccionados
        if ~isempty(not_selected_indices)
            legend('Datos no usados', 'Datos seleccionados', 'Polinomio Interpolador', 'Location', 'best');
        else
            legend('Datos seleccionados', 'Polinomio Interpolador', 'Location', 'best');
        end
        
        grid on;
        hold off;
    end
    lagrangeInterpolation('/Users/esteban/git-repos/numerical-analisis-project/guia/datos.csv', 6, 7, 5)
