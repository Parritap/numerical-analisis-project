% Script de Bisección

% ¿Cómo correr el script con bash rápidamente con el ejemplo visto en clase?
% cd /Users/esteban/git-repos/numerical-analisis-project && echo -e "x^3 - 7*x^2 + 14*x - 6\n1\n3.2\n0.01" | ./run_matlab.sh src/methods/raices/biseccion_method.m

format short; % Displays in 4 decimals

try
    funcion = input('Ingrese la función para buscar una raíz: f(x) = ', 's');
    f = str2func(['@(x) ' funcion]);
    a = input('Ingrese el valor inicial del intervalo: a = ');
    b = input('Ingrese el valor final del intervalo: b = ');
    errorEsperado = input('Ingrese un error decimal esperado para aproximarse a la raíz: ');

    if f(a) * f(b) > 0
        error('La función no corta el eje x en el intervalo dado.');
    else
        % Inicializar arrays para almacenar los valores de cada iteración
        p_anterior = 0; % Importante para que el primer error sea del 100 %
        iteraciones = [];
        valores_a = [];
        valores_b = [];
        valores_p = [];
        valores_fc = [];
        valores_fa = [];
        cambio_signo = [];
        errores = [];
        error_porcentual = [];

        cont = 0;
        errorActual = inf;

        while errorActual > errorEsperado
            cont = cont + 1;
            p = (a + b) / 2;
            fp = f(p);
            fa = f(a);

            % Calcular error relativo
            if cont == 1
                errorActual = inf; % Infinito para asegurarnos de entrar al ciclo en la primera iteración
            else
                %El error depende de los puntos medios.
                errorActual = abs(p - p_anterior) / abs(p);
            end

            p_anterior = p; % Actualizar para la siguiente iteración
            par_signos = {'-', '+'}
            signo = par_signos{(fa * fp) <= 0};

            % Guardar valores de esta iteración
            iteraciones = [iteraciones; cont];
            valores_a = [valores_a; a];
            valores_b = [valores_b; b];
            valores_p = [valores_p; p];
            valores_fc = [valores_fc; fp];
            valores_fa = [valores_fa; fa];
            cambio_signo = [cambio_signo; signo];
            errores = [errores; errorActual];
            error_porcentual = [error_porcentual; string(errorActual * 100)];

            if fa * fp <= 0
                b = p;
            else
                a = p;
            end

        end

        errores(1, 1) = 1;
        error_porcentual(1, 1) = "100";
        p = (a + b) / 2;

        % Mostrar tabla de iteraciones
        disp(' ');
        disp('========== TABLA DE ITERACIONES ==========');
        fprintf('\n');
        fprintf('%3s | %12s | %12s | %12s | %12s | %12s | %6s | %12s | %12s\n', ...
            'i', 'a', 'b', 'p', 'f(p)', 'f(a)', 'Signo?', 'Error', 'Error %');
        fprintf('----+-------------+--------------+--------------+--------------+--------------+--------+--------------+--------------\n');

        % Para imprimir más decimales, simplemente cambiar el número que viene despues del punto en el fprintf del forloop.
        for k = 1:length(iteraciones)
            fprintf('%3d | %12.4f | %12.4f | %12.4f | %12.4f | %12.4f | %6s | %12.4f | %12s\n', ...
                iteraciones(k), valores_a(k), valores_b(k), valores_p(k), ...
                valores_fc(k), valores_fa(k), ...
                char(string(cambio_signo(k))), errores(k), char(error_porcentual(k)));
        end

        fprintf('\n');
        disp('==========================================');
        disp(' ');
        disp('La cantidad de iteraciones fue:');
        disp(['i = ' num2str(cont)]);
        disp('La raíz en la función con el error esperado es:');
    disp(['X = ' num2str(p, '%.10f')]);
    disp(['f(X) = ' num2str(f(p), '%.10f')]);
    % Imprimir la forma final de la función en color verde
    fprintf('\033[0;32mLa forma final es: f(x) = %s; raíz encontrada: x = %.10f\033[0m\n', funcion, p);
        ezplot(funcion); % Graficamos
        grid on;
    end

catch
    error('Error en la entrada de datos. Asegúrese de ingresar la función correctamente y valores numéricos para los intervalos y el error esperado.');
end
