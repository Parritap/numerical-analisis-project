function Biseccion()

    format long ;
    syms x ;

    try
        funcion = input('Ingrese la función para buscar una raíz: f(x) = ', 's');
        f = inline(funcion);
        a = input('Ingrese el valor inicial del intervalo: a = ');
        b = input('Ingrese el valor final del intervalo: b = ');
        errorEsperado = input('Ingrese un error esperado para aproximarse a la raíz: ');

        if f(a)*f(b) > 0
            error('La función no corta el eje x en el intervalo dado.');
        else
            cont = 1;
            while (abs((b - a)/(2^cont)) > errorEsperado)
                cont = cont + 1;
                c = (a + b) / 2;

                if f(a)*f(c) <= 0
                    b = c;
                else
                    a = c;
                end
            end
            c = (a + b) / 2;
            disp('La cantidad de iteraciones fue:');
            disp('i=');
            disp(cont);
            disp('La raíz en la función con el error esperado es:');
            disp('X=');
            disp(c);
            ezplot(funcion); % Graficamos
            grid on;
        end
    catch
        error('Error en la entrada de datos. Asegúrese de ingresar la función correctamente y valores numéricos para los intervalos y el error esperado.');
    end
end

Biseccion()