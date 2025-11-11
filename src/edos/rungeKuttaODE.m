% Método de Runge-Kutta de cuarto orden para resolver EDOs
% 
% Ejemplo de prueba con bash (Ecuación: y' = -2*t*y, y(0) = 1, t en [0, 2], h = 0.1):
% cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "-2*t*y\n1\n0\n2\n0.1" | ./run_matlab.sh src/edos/rungeKuttaODE.m
%
% Otros ejemplos:
% 1. Crecimiento exponencial: y' = y, y(0) = 1, t en [0, 2], h = 0.1
%    echo -e "y\n1\n0\n2\n0.1" | ./run_matlab.sh src/edos/rungeKuttaODE.m
%
% 2. Decaimiento: y' = -y, y(0) = 10, t en [0, 3], h = 0.1
%    echo -e "-y\n10\n0\n3\n0.1" | ./run_matlab.sh src/edos/rungeKuttaODE.m
%
% 3. Oscilador: y' = cos(t), y(0) = 0, t en [0, 6.28], h = 0.1
%    echo -e "cos(t)\n0\n0\n6.28\n0.1" | ./run_matlab.sh src/edos/rungeKuttaODE.m

function rungeKuttaODE()
    try
        % Ingrese la ecuación diferencial en la forma y' = f(t, y)
        syms t y;
        f_str = input('Ingrese la ecuación diferencial en la forma y'' = f(t, y), f(t, y) = ', 's');
        f = str2func(['@(t, y) ' f_str]);

        % Ingrese las condiciones iniciales
        y0 = input('Ingrese el valor inicial de y (y0): ');
        t0 = input('Ingrese el tiempo inicial (t0): ');
        tf = input('Ingrese el tiempo final (tf): ');
        h = input('Ingrese el tamaño del paso (h): ');

        % Validaciones de los datos de entrada
        if ~isscalar(y0) || ~isscalar(t0) || ~isscalar(tf) || ~isscalar(h)
            error('Las condiciones iniciales, tiempo inicial, tiempo final y tamaño del paso deben ser escalares.');
        end

        if tf <= t0 || h <= 0
            error('El tiempo final debe ser mayor que el tiempo inicial y el tamaño del paso debe ser positivo.');
        end

        % Calcular el número de pasos
        numSteps = round((tf - t0) / h);

        % Inicializar arrays para almacenar resultados
        t_values = zeros(1, numSteps + 1);
        y_values = zeros(1, numSteps + 1);

        % Inicializar condiciones iniciales
        t_values(1) = t0;
        y_values(1) = y0;

        % Aplicar el método de Runge-Kutta de cuarto orden
        for i = 1:numSteps
            k1 = h * f(t_values(i), y_values(i));
            k2 = h * f(t_values(i) + h/2, y_values(i) + k1/2);
            k3 = h * f(t_values(i) + h/2, y_values(i) + k2/2);
            k4 = h * f(t_values(i) + h, y_values(i) + k3);

            y_values(i + 1) = y_values(i) + (k1 + 2*k2 + 2*k3 + k4) / 6;
            t_values(i + 1) = t_values(i) + h;
        end

        % Mostrar los resultados
        disp('Resultados del método de Runge-Kutta de cuarto orden:');
        disp('t_values:');
        disp(t_values);
        disp('y_values:');
        disp(y_values);

        % Graficar la solución
        plot(t_values, y_values, 'LineWidth', 2);
        title('Solución de la Ecuación Diferencial por Runge-Kutta de Cuarto Orden');
        xlabel('t');
        ylabel('y(t)');
        grid on;

    catch
        error('Error en la entrada de datos. Asegúrese de ingresar la ecuación diferencial, condiciones iniciales, tiempo inicial, tiempo final y tamaño del paso correctamente.');
    end
end
