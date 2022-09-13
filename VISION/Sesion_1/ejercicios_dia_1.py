#EJERCICIOS DÍA 1
import cv2
def numero_mayor(numero_1: int,numero_2: int):
    """" Esta función devuelve el número más grande de los dos introducidos.
            numero_1: Es un número cualquiera.
            numero_2: Es un número cualquiera.
    """
    if(numero_1>=numero_2):
        print("El número más grande entre",numero_1,"y el",numero_2,"es el:",numero_1)
    else:
        print("El número más grande entre",numero_1,"y el",numero_2,"es el:",numero_2)


def longitud_cadena(cadena: str):
    """Esta función nos permite obtener la longitud """
    longitud = 0
    for i in cadena:
        longitud +=1
    print("La longitud de la cadena introducida es:",longitud)
    
def vocal_no_vocal(caracter: str):    
    vocales = "aeiou"    
    if(vocales.find(caracter) == -1):
        print("El caracter NO es una vocal")
    else:
        print("El caracter es una vocal")

numero_mayor(1,5)
longitud_cadena("Hacienda")


def multiplicacion_falsa(multiplo_1: int, multiplo_2: int):
    auxiliar = 0
    for i in range(multiplo_2):        
        auxiliar =auxiliar + multiplo_1
    print("La multiplicación da:", auxiliar)
longitud_cadena = 0
def binario_a_decimal(numero_a_convertir: str):
    auxiliar = 0
    longitud_cadena = len(numero_a_convertir)
    for i in range(longitud_cadena):
        if(numero_a_convertir[i] == "1"):
            cuenta = 2^(longitud_cadena-(i+1))
            auxiliar += cuenta
    print("El número en decimal es el:", auxiliar)        

    
multiplicacion_falsa(5,3)
vocal_no_vocal("j")
binario_a_decimal("1101")

