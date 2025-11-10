% Este script implementa el método de serie de Taylor para aproximar una función en un punto dado.
% Calcula la serie de Taylor de orden N para una función simbólica alrededor del punto 'a'.
% Solicita al usuario la función, el punto central y el orden de la serie.

% Script para correr el archivo en Bash
%
% Ejemplo 1: Serie de Taylor de e^x (exp(x)) alrededor de 0 con orden 5
% cd $HOME/git-repos/numerical-analisis-project && echo -e "exp(x)\n0\n5" | ./run_matlab.sh src/methods/taylor/taylor.m
%
% Ejemplo 2: Serie de Taylor de sin(x) alrededor de 0 con orden 7
% cd $HOME/git-repos/numerical-analisis-project && echo -e "sin(x)\n0\n7" | ./run_matlab.sh src/methods/taylor/taylor.m
%
% Ejemplo 3: Serie de Taylor de cos(x) alrededor de 0 con orden 6
% cd $HOME/git-repos/numerical-analisis-project && echo -e "cos(x)\n0\n6" | ./run_matlab.sh src/methods/taylor/taylor.m
%
% Ejemplo 4: Serie de Taylor de ln(1+x) alrededor de 0 con orden 5
% cd $HOME/git-repos/numerical-analisis-project && echo -e "log(1+x)\n0\n5" | ./run_matlab.sh src/methods/taylor/taylor.m

format long;
syms x;
sympref("PolynomialDisplayStyle","ascend"); % Imprimir en orden ascendente, es decir, de menor a mayor grado.




% Solicitar entrada al usuario
f_str = input('Ingrese la función: f(x) = ', 's');
FUN = str2sym(f_str);

a = input('Ingrese el punto central de la serie (a): ');
N = input('Ingrese el orden de la serie de Taylor (N): ');

% Validar que N sea un entero positivo
if N < 0 || floor(N) ~= N
    error('El orden N debe ser un entero no negativo.');
end

% Obtener la variable simbólica
x_var = symvar(FUN);
if isempty(x_var)
    error('La función debe contener al menos una variable.');
end
x = x_var(1);

% Inicializar la serie de Taylor
T = sym(0);
f_deriv = FUN;

% Imprimir encabezado
fprintf('\n%s\n', repmat('=', 1, 90));
fprintf('CÁLCULO DE SERIE DE TAYLOR\n');
fprintf('%s\n', repmat('=', 1, 90));
fprintf('Funcion: %s\n', char(FUN));
fprintf('Punto central (a): %g\n', a);
fprintf('Orden (N): %d\n', N);
fprintf('%s\n', repmat('=', 1, 90));

% Imprimir tabla de términos
fprintf('\n%-10s %-30s %-30s %-30s\n', 'Termino', 'f^(n)(a)', 'Coeficiente [ f^(n)(a)/n! ] ', 'Termino de la serie');
fprintf('%s\n', repmat('-', 1, 105));

% Calcular la serie: sum_{n=0}^{N} f^(n)(a)/n! * (x-a)^n
for n = 0:N
        % Evaluar la n-ésima derivada en el punto a
        f_at_a = subs(f_deriv, x, a);

        % Calcular el coeficiente
    coef = f_at_a / factorial(n);

    % Calcular el término actual
    if n == 0
        term = coef;
    else
        term = coef * (x - a)^n;
    end

    % Agregar el término a la serie
    T = T + term;

    % Imprimir información del término
    fprintf('%-10d %-30s %-30s %-30s\n', ...
        n, ...
        char(vpa(f_at_a, 6)), ...
        char(vpa(coef, 6)), ...
        char(term));

    % Calcular la siguiente derivada para la próxima iteración
    if n < N
        f_deriv = diff(f_deriv, x);
    end
end

fprintf('%s\n', repmat('-', 1, 105));

% Simplificar la serie final
T = simplify(T);

% Mostrar resultado final
fprintf('\n%s\n', repmat('=', 1, 90));
fprintf('RESULTADO FINAL\n');
fprintf('%s\n', repmat('=', 1, 90));
fprintf('Serie de Taylor de orden %d:\n\n', N);
fprintf('\x1b[32mT_%d(x) = %s\x1b[0m\n', N, char(T));
fprintf('\n%s\n', repmat('=', 1, 90));

%%%%% GRAFICANDO %%%%%%


% Graficar la funcion original y la serie de Taylor
fprintf('\nGenerando grafica...\n');

% Definir rango de graficacion centrado en el punto a
x_range = linspace(a - 2, a + 2, 500);

% Evaluar la funcion original y la serie de Taylor
f_vals = double(subs(FUN, x, x_range));
T_vals = double(subs(T, x, x_range));

% Crear la grafica
figure('Position', [100, 100, 800, 600]);
hold on;
grid on;

% Graficar funcion original
plot(x_range, f_vals, 'b-', 'LineWidth', 2, 'DisplayName', ['f(x) = ' char(FUN)]);

% Graficar serie de Taylor
plot(x_range, T_vals, 'r--', 'LineWidth', 2, 'DisplayName', sprintf('T_%d(x)', N));

% Marcar el punto central
plot(a, double(subs(FUN, x, a)), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'DisplayName', sprintf('Punto central (a = %g)', a));

% Configurar la grafica
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title(sprintf('Serie de Taylor de orden %d para f(x) = %s alrededor de x = %g', N, char(FUN), a), 'FontSize', 14);
legend('Location', 'best', 'FontSize', 10);
hold off;

fprintf('Grafica generada exitosamente.\n');
