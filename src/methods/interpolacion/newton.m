% Interpolacion de Newton
    % NOTA!!!!!! -> Es mejor dar la ruta absoluta del CSV para evitar errores
    % cd /Users/esteban/git-repos/numerical-analisis-project && ./run_matlab.sh src/methods/interpolacion/newton.m

    function newtonInterpolation(filename, col_x, col_y, num_points)
        % newtonInterpolation - Realiza interpolacion de Newton sobre datos de un archivo CSV
        %
        % Sintaxis: newtonInterpolation(filename, col_x, col_y, num_points)
        %
        % Argumentos:
        %   filename   - Ruta al archivo CSV (relativa a la raiz del proyecto)
        %   col_x      - Numero de columna para la variable independiente (x)
        %   col_y      - Numero de columna para la variable dependiente (y)
        %   num_points - Numero de puntos a usar para la interpolacion (distribuidos equitativamente)
        %
        % Ejemplo:
        %   newtonInterpolation('guia/datos.csv', 6, 7, 5)
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

        % Crear una tabla de diferencias divididas
        f = zeros(n, n);
        f(:,1) = y_data;

        for j = 2:n
            for i = 1:n-j+1
                f(i,j) = (f(i+1,j-1) - f(i,j-1)) / (x_data(i+j-1) - x_data(i));
            end
        end

        % Construir el polinomio de Newton simbolicamente
        syms x;
        newtonPoly = f(1,1);
        for j = 2:n
            producto = 1;
            for i = 1:j-1
                producto = producto * (x - x_data(i));
            end
            newtonPoly = newtonPoly + f(1,j) * producto;
        end
        
        % Simplificar y mostrar el polinomio
        newtonPoly = simplify(newtonPoly);
        fprintf('\033[32mEl polinomio interpolador de Newton (grado %d) es:\n%s\033[0m\n', n-1, char(newtonPoly));
        
        % Generar puntos para graficar la curva ajustada
        x_fit = linspace(min(x_data), max(x_data), 300);
        y_fit = double(subs(newtonPoly, x, x_fit));
        
        % Calcular limites del eje Y basados en los datos
        y_min = min([y_all; y_fit(:)]);
        y_max = max([y_all; y_fit(:)]);
        y_range = y_max - y_min;
        
        % Identificar puntos no seleccionados
        not_selected_mask = true(size(x_all));
        not_selected_mask(selected_indices) = false;
        
        % Graficar el polinomio primero (linea verde)
        plot(x_fit, y_fit, 'g-', 'LineWidth', 2.5);
        hold on;
        
        % Graficar puntos NO seleccionados (si existen) en gris
        if any(not_selected_mask)
            scatter(x_all(not_selected_mask), y_all(not_selected_mask), 50, [0.7 0.7 0.7], 'filled', 'MarkerFaceAlpha', 0.4);
        end
        
        % Graficar puntos seleccionados en verde
        scatter(x_data, y_data, 80, 'g', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5, 'MarkerFaceAlpha', 0.7);
        
        % Agregar etiquetas y formato al grafico usando los nombres de las columnas
        xlabel(x_label, 'FontSize', 12, 'FontWeight', 'bold');
        ylabel(y_label, 'FontSize', 12, 'FontWeight', 'bold');
        title(['Interpolacion de Newton: ' y_label ' vs ' x_label ' (n=' num2str(n) ')'], 'FontSize', 14, 'FontWeight', 'bold');
        
        % Leyenda dinamica
        if any(not_selected_mask)
            legend('Polinomio Interpolador', 'Datos no seleccionados', 'Puntos seleccionados', 'Location', 'best');
        else
            legend('Polinomio Interpolador', 'Puntos seleccionados', 'Location', 'best');
        end
        
        grid on;
        ylim([y_min - 0.1*y_range, y_max + 0.1*y_range]);
        hold off;
    end
    newtonInterpolation('/Users/esteban/git-repos/numerical-analisis-project/guia/datos.csv', 6, 7, 5)