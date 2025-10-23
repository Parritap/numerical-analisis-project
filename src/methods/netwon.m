% Este script implementa el método de Newton-Raphson para encontrar raíces de una función f(x) en Matlab.
% Solicita al usuario el valor inicial, la función y el error requerido, y realiza iteraciones hasta encontrar la raíz con el error especificado.
% Incluye validaciones para evitar divisiones por cero y muestra el resultado final y el error alcanzado.

% Script para correr el archivo en Bash
% cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "x^3 - 7*x^2 + 14*x - 6\n1\n0.01" | ./run_matlab.sh src/methods/netwon.m

format long;
syms x;

try
    f_str = input('Ingrese la función para buscar una raíz: f(x) = ', 's');
    f = str2sym(f_str);
    xn = input('Ingrese el valor inicial de x: x = ');
    errorEsperado = input('Ingrese el error requerido: E = ');

    % Validación de que la derivada no sea cero en el punto inicial
    Df = diff(f, x);

    if subs(Df, xn) == 0
        error('La derivada en el punto inicial es cero. El método de Newton puede no converger.');
    end

    a = vpa(subs(f, xn));
    b = vpa(subs(Df, xn));
    xn2 = xn - a / b;
    Error = xn2 - xn;
    xn = xn2;
    i = 1;

    while abs(Error) > errorEsperado
        a = vpa(subs(f, xn));
        b = vpa(subs(Df, xn));

        % Verificar que la derivada no sea cero antes de dividir
        if b == 0
            error('La derivada es cero en la iteración %d. El método no puede continuar.', i);
        end

        xn2 = xn - a / b;
        Error = xn2 - xn;
        xn = xn2;
        i = i + 1;

        disp('Iteración:');
        disp(i);
        disp('La raíz de la función es:');
        disp(xn2);
    end

    % Resultado final
    fprintf('\nRaíz encontrada después de %d iteraciones: %.10f\n', i, double(xn2));
    fprintf('Error final: %.10e\n', abs(Error));

catch ME
    fprintf('Error: %s\n', ME.message);
    disp('Asegúrese de ingresar la función correctamente y valores numéricos para el valor inicial y el error requerido.');
end
