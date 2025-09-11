function newton_rapson
syms x;
f=input('Digite la funcion deseada (con variable x)');
df=diff(f); %derivada de f
x0=input('Digite el valor inicial');
n=input('Digite numero de iteraciones');
tol=input('Digite el error maximo de permitido');
for k=1:n
    x1=x0-subs(f,x0)/subs(df,x0);
    if(abs(x1-x0)<tol)
        fprintf('x%d=%f es una aproximacion de una raiz \n',k,x1)
        return
    end
    fprintf('x%d=%f\n',k,x1)
    x0=x1;
end