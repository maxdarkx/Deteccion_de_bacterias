%--------MASCARACIRCULAR.M---------------------------------------
%--------ENTREGA 2 PDI-------------------------------------------
%--------POR: DAVID CAGUA y JUAN CARLOS MAYA SANCHEZ-------------
%--------C.C.: 1152213450 y 1017131966---------------------------
%--------Telefono: 3012905481------------------------------------
%--------Curso de Procesamiento Digital de Imagenes--------------
%--------v1.0 Entrega: OCTUBRE 27 -------------------------------



function [centroides,areas,cantidad]= mascaracircular(arch)
%%Funcion para Extraer datos de las colonias de bacterias en una muestra
%se le debe ingresar el nombre del archivo, y a la salida mostrara la
%ubicacion de los centroides de las colonias de bacterias (vector), el area
%de cada colonia(vector) y la cantidad de colonias presente(int).




    % clear all;
    % close all;
    % clc;


%se lee el archivo de imagen y se convierte en escala de grises, por comodidad____________________________
    o=imread(arch);
    a=rgb2gray(o);
    %figure(1);
    %imshow(a);
    %impixelinfo
%________________________________________________________________________________________________________

%se obtienen 4 posiciones directamente de la pantalla, haciendo click con el mouse
    b=ginput(4);

%_________________________________________________________________________________________________________



% tomamos esos cuatro puntos y hacemos un promedio buscando el centro entre ellos, y con esos datos
%imprimimos un circulo en la pantalla, que nos va a servir de mascara. Asi se eliminan los bordes del
%recipiente de muestra. Es fundamental tomar bien los cuatro puntos, porque si el programa toma los bordes
%las mediciones no van a estar correctas

    x1= (b(1)+b(2)+b(3)+b(4))/4 ;
    y1= (b(5)+b(6)+b(7)+b(8))/4 ;

%se calculan las dimensiones del circulo y se crea la mascara (a)__________________________________________
    r=(sqrt((b(1)-b(2))^2)+sqrt((b(3)-b(4))^2)+sqrt((b(5)-b(6))^2)+sqrt((b(7)-b(8))^2))/4;
    d=viscircles([x1,y1],r);
    n=size(a,1);
    m=size(a,2);
    %a(((X-x1)^2 + (Y-y2)^2)<=r^2)=255;
    for i=1:n   
        for j=1:m

            p1=(j-x1)^2;
            p2=(i-y1)^2;
            raiz=sqrt(p1+p2);

            if raiz <= r
                a(i,j)=255;                              
            end
        end 
    end
%__________________________________________________________________________________________________________



%se termina la mascara binarizando el resto de objetos que no tienen que ver con el circulo
    a(a<255)=0;
    %figure(2);
    %imshow(a)
    a(a==255)=1;

%___________________________________________________________________________________________________________

%se multiplica la mascara por la imagen original, creando una foto adecuada para trabajar
    e=ones(size(o,1),size(o,2),size(o,3),'uint8');
    for c=1:size(o,3)
        for i=1:size(o,1)
            for j=1:size(o,2)
                e(i,j,c)=o(i,j,c)*a(i,j);
            end
        end
    end

     %figure(6)
     %imshow(e);
     %impixelinfo();
%___________________________________________________________________________________________________________

%se utiliza una funcion de color para filtrar las colonias de bacterias presentes___________________________
    [x,x1]=cultivobacterias(e);
%___________________________________________________________________________________________________________


%si en la foto tomada hay colonias de bacterias que el filtro las pone difusas, una apertura es ideal para 
%mejorar la calidad de la informacion obtenida en la imagen. No se recomienda cuando hay colonias de bacterias
%con areas muy grandes_________________________________________________________________________________________
    ee=strel('disk',4);
    x=imclose(x,ee);

    %figure(7);
    %imshow(x1);
    %hold on;
    %impixelinfo;
%_____________________________________________________________________________________________________________

%Se utiliza regionprops para extraer caracteristicas de la foto filtrada, tales como areas de las colonias y 
%posicion de los centroides de las mismas_____________________________________________________________________
    L=regionprops(x,'Centroid','Area');
    centroides=cat(1,L.Centroid);
    areas=cat(1,L.Area);
    %figure(1);
    %imshow(o);
    %hold on;
    %plot(centroides(:,1),centroides(:,2),'r+');
    cantidad=size(areas);
%_____________________________________________________________________________________________________________
end