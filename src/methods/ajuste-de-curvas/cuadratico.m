% Script de bash para correr el programa en la línea de comandos:
% cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "5\n[1.2,3.5;2,5;2.8,6.2;3.5,7.8;4.1,9.0]" | ./run_matlab.sh src/methods/ajuste-de-curvas/cuadratico.m

function quadraticRegression()
    % Establecer formato de visualización para mostrar más decimales
    format long;
    
    % Solicitar al usuario que ingrese los puntos de regresión (xi, yi)
    try
        % Obtener el número de puntos del usuario
        n = input('Ingrese el número de puntos para la regresión cuadrática: n = ');
        
        % Validar que n sea un número único, mayor que 2, y un entero
        if ~isscalar(n) || n <= 2 || mod(n, 1) ~= 0
            error('Se requieren al menos 3 puntos para la regresión cuadrática.');
        end
        
        % Solicitar al usuario que ingrese los puntos de datos
        disp('Ingrese los puntos en el formato [x1, y1; x2, y2; ...]:');
        points = input('Puntos = ');
        
        % Validar que la matriz de entrada tenga exactamente 2 columnas y n filas
        if size(points, 2) ~= 2 || size(points, 1) ~= n
            error('Ingrese correctamente los puntos en el formato [x1, y1; x2, y2; ...].');
        end
        
        % Extraer las coordenadas x e y de la matriz de puntos
        x = points(:, 1);  % Primera columna contiene los valores de x
        y = points(:, 2);  % Segunda columna contiene los valores de y
        
        % Realizar regresión cuadrática (ajustar un polinomio de grado 2)
        % polyfit retorna los coeficientes [a, b, c] para ax^2 + bx + c
        p = polyfit(x, y, 2);
        
        % Mostrar los coeficientes del polinomio cuadrático
        disp('Coeficientes del polinomio cuadrático:');
        disp(p);
        
        % Imprimir la ecuación final en color verde usando códigos ANSI
        % Formato: f(x) = ax^2 + bx + c
        fprintf('\033[0;32mLa forma final es: f(x) = %.4fx^2 + %.4fx + %.4f\033[0m\n', p(1), p(2), p(3));
        
        % Generar puntos para graficar la curva ajustada
        x_fit = linspace(min(x), max(x), 100);  % Crear 100 puntos equiespaciados entre el x mínimo y máximo
        y_fit = polyval(p, x_fit);               % Evaluar el polinomio en estos puntos
        
        % Crear una nueva ventana de figura
        figure;
        
        % Graficar la curva cuadrática ajustada como una línea azul
        plot(x_fit, y_fit, 'b-', 'LineWidth', 2);
        hold on;  % Mantener el gráfico para agregar más elementos
        
        % Graficar los puntos de datos originales como círculos rojos rellenos
        scatter(x, y, 'r', 'filled');
        
        % Agregar etiquetas y formato al gráfico
        title('Regresión Cuadrática');
        xlabel('x');
        ylabel('y');
        legend('Regresión Cuadrática', 'Puntos de Regresión', 'Location', 'Best');
        grid on;   % Mostrar líneas de cuadrícula
        hold off;  % Liberar el gráfico
        
    catch
        % Manejar cualquier error que ocurra durante la ejecución
        error('Error en la entrada de datos. Asegúrese de ingresar el número de puntos y los puntos correctamente.');
    end
end