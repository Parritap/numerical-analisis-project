%  Implementación documentada del método
%  de Newton–Raphson para hallar raíces de f(x).
%
%   El usuario ingresa:
%   1) Lee f(x) en notación habitual, la convierte a handle.
%   2) Lee x0 inicial y tol en decimal.
%   3) Itera hasta err<tol, maneja derivada cero.
%   4) Imprime tabla y grafica resultados.
   %% Se limpia la pantalla y memoria
       clc; clear; close all;
      
   %% 1. Entrada de la función en notación de calculadora
   expr = input("Introduce f(x), p.e. x^3 - x - 2: ", 's');  
   % 2.1 Convertir a expresión teniendo en cuenta las diferentes notaciones para MatLab:
   %    ^ → .^    * → .*    / → ./
   expr = regexprep(expr, '(?<!\.)\^', '.^');               
   expr = regexprep(expr, '(?<!\.)\*', '.*');               
   expr = regexprep(expr, '(?<!\.)\/', './');               
   % 2.2 Crear handle de función
   f = str2func(['@(x) ' expr]);                            
   %% 3. Derivada simbólica y handle
   sx   = sym('x');                                          % Variable simbólica
   fsym = str2sym(expr);                                     % Función simbólica
   dfdx = matlabFunction(diff(fsym, sx), 'Vars', sx);        % Handle f'(x)
   %% 4. Lectura de x0 y tolerancia
   x0 = input("Estimación inicial x0: ");                    % Punto de partida
   tol_str = input("Tolerancia (ej. 0.001): ", 's');          % Leer como cadena
   tol = str2double(tol_str);                                 % Convertir a número
   if isnan(tol) || tol<=0                                    % Validar tol
       error("Tolerancia inválida. Debe ser un decimal positivo.");
   end
   %% 5. Inicialización
   xs   = x0;        % Vector de aproximaciones
   data = [];        % [iter, x_k, f(x_k), err]
   err  = Inf;       % Error inicial
   k    = 0;         % Iterador
   itCap = 1e4;      % Tope para evitar bucle infinito
   %% 6. Bucle Newton–Raphson hasta err ≤ tol
   while err > tol && k < itCap
       xk   = xs(end);     
       fxk  = f(xk);         
       dfxk = dfdx(xk);      
       if dfxk == 0                                       
           error("Derivada nula en x=%.6f. No converge.", xk); 
       end
       % Paso de Newton
       x_next = xk - fxk/dfxk; 
       err    = abs(x_next - xk); 
       k = k + 1;              
       data(end+1,:) = [k, x_next, f(x_next), err]; 
       xs(end+1) = x_next;     
   end
   if k==itCap && err>tol
       warning("Se alcanzó el máximo de iteraciones (%d) sin converger.", itCap);
   end
   %% 7. Impresión de tabla de iteraciones
   fprintf("\nTabla de iteraciones (tol=%.g):\n", tol);
   fprintf("It |    x_k    |   f(x_k)   |   Error\n");
   fprintf("---|-----------|------------|-----------\n");
   for i=1:size(data,1)
       fprintf("%2d | %9.6f | %10.4e | %9.4e\n", ...
               data(i,1), data(i,2), data(i,3), data(i,4));
   end
   %% 8. Resultados finales
   root = data(end,2);
   finalErr = data(end,4);
   fprintf("\nRaíz: %.8f   Iteraciones: %d   Error final: %g\n", ...
           root, k, finalErr);
   %% 9. Gráfica de f(x) y recorrido de iteraciones
   figure; hold on; grid on;
   xx = linspace(min(xs)-1, max(xs)+1, 500);
   plot(xx, f(xx), 'LineWidth',1.5);                      
   plot(data(:,2), data(:,3), 'ro-', 'MarkerFaceColor','r');
   plot(root, f(root), 'go', 'MarkerSize', 6, 'MarkerFaceColor', 'g', 'LineWidth', 2); % Resalta la raíz
   xlabel('x'); ylabel('f(x)');
    title(sprintf('Método de Newton–Raphson para: %s', expr));
   legend('f(x)', 'Iteraciones','Location','best');
   hold off;
