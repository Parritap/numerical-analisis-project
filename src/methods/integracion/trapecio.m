function trapezoidalIntegration()
    % Ingrese la función a integrar
    try
        syms x;
        f_str = input('Ingrese la función a integrar, f(x) = ', 's');
        f = str2func(['@(x) ' f_str]);

        % Ingrese los límites de integración
        a = input('Ingrese el límite inferior de integración (a): ');
        b = input('Ingrese el límite superior de integración (b): ');

        if a >= b
            error('El límite inferior de integración (a) debe ser menor que el límite superior (b).');
        end

        % Ingrese el número de subintervalos (trapezoides)
        n = input('Ingrese el número de subintervalos (n): ');

        if ~isscalar(n) || n <= 0 || mod(n, 1) ~= 0
            error('El número de subintervalos (n) debe ser un entero positivo.');
        end

        % Calcular el ancho de cada subintervalo
        h = (b - a) / n;

        % Calcular la aproximación de la integral utilizando el método del trapecio
        integralApproximation = h * (f(a) / 2 + sum(arrayfun(f, linspace(a + h, b - h, n - 1))) + f(b) / 2);

        % Mostrar la aproximación de la integral
        disp('La aproximación de la integral utilizando el método del trapecio es:');
        disp(integralApproximation);

        % Graficar la función y los trapecios
        x_values = linspace(a, b, 1000);
        y_values = arrayfun(f, x_values);

        plot(x_values, y_values, 'LineWidth', 2);
        hold on;

        % Dibujar los trapecios
        for i = 1:n
            x_i = a + (i - 1) * h;
            x_f = a + i * h;
            y_i = f(x_i);
            y_f = f(x_f);

            % Coordenadas de los vértices del trapecio
            x_vertices = [x_i, x_f, x_f, x_i, x_i];
            y_vertices = [0, 0, y_f, y_i, 0];

            plot(x_vertices, y_vertices, 'r');
        end

        title('Método del Trapecio para la Integración Numérica');
        xlabel('x');
        ylabel('f(x)');
        legend('Función', 'Trapecios', 'Location', 'Best');
        grid on;
        hold off;

    catch
        error('Error en la entrada de datos. Asegúrese de ingresar la función, los límites y el número de subintervalos correctamente.');
    end
end
