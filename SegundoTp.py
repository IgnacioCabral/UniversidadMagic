import math
import cmath

# --------------------------------------------------------------------------------------------
# Calculo de distancia por cada antena:
# -------------------TOA1---------------------------------------------------------------------

Trtt1 =  5e+08        
#Tiempo de ida y vuelta en la medicion de distancia

Ttat =   2.85e+07          
#Tiempo de respuesta del agente 
d = [0, 0, 0, 0]


d[0] = (3*10**8/10**16) * ( Trtt1 - Ttat )/2


#---------------------TOA2--------------------------------------------------------------------

Trtt2 =  5e+08          
#Tiempo de ida y vuelta en la medicion de distancia

Ttat =  2.8595e+07        
#Tiempo de respuesta del agente 

d[1] = (3*10**8 / 10**16 ) * ( Trtt2 - Ttat )/2


#-----------------------Rss1-------------------------------------------------------------------
#
# Aca le voy a poner por el momento lo que dice el paper que mï¿½s o menos da un resultado de 10m
#pero habria que calcular un di por medio de la potencia
do = 7.01
gama = 4.58
p0 = 10
pr = 9.81
d [2] = 10 ** (( p0 - pr )/ ( 10 * gama )) * do



#-----------------------Rss2------------------------------------------------------------------
# Aca le voy a poner por el momento lo que dice el paper que mï¿½s o menos da un resultado de 10m
#pero habrï¿½a que calcular un di por medio de la potencia

do = 7.01
gama = 4.58
p0 = 10
pr = 9.81
d [3] = 10 ** (( p0 - pr )/ ( 10 * gama )) * do

#---------------------------------------------------------------------------------------------   
        

# MATRIZ DE POSICION DE CADA ANTENA

L=10

x = [ 0, L, 0, L ]
y = [ 0, 0, L, L ]

# ANTENA DE REFERENCIA PARA LLS2 Y WLLS2

xr = 0 
yr= 0

# VARIANZA AL TOMAR MEDICIONES CON LAS ANTENAS
eta = 2
SNR0 = 25
d0 = 1
vartoa = [0, 0, 0, 0]
varrss = [0, 0, 0, 0]
for i in [0, 1, 2, 3]:
    vartoa[i] = ( 1 / SNR0 ) * ( d[i] / d0 )
    varrss[i] = eta**2 * vartoa[i]


var = [ vartoa[0], vartoa[1], varrss[2], varrss[3] ]

