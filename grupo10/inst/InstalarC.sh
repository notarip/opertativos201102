#!/bin/bash

function setParamFromConf
{
	getConfigParam "CURRDIR"
	GRUPO=$CONFIGPARAM	
	getConfigParam "BINDIR"	
	DEFBINDIR=$CONFIGPARAM
	getConfigParam "ARRIDIR"	
	DEFARRIDIR=$CONFIGPARAM
	getConfigParam "DATASIZE"	
	DEFDATASIZE=$CONFIGPARAM
	getConfigParam "LOGDIR"	
	DEFLOGDIR=$CONFIGPARAM
	getConfigParam "LOGEXT"	
	DEFLOGEXT=$CONFIGPARAM
	getConfigParam "MAXLOGSIZE"	
	DEFLOGSIZE=$CONFIGPARAM
}

function setParamDefault
{
	DEFBINDIR="/bin"
	DEFARRIDIR="/arribos"
	DEFDATASIZE="100"
	DEFLOGDIR="/log"
	DEFLOGEXT=".log"
	DEFLOGSIZE="400"
	#obtener $grupo
	AUXNOMBRE=$(pwd)
	AUXNOMBRE=${#AUXNOMBRE}
	AUXNOMBRE=`echo "$AUXNOMBRE-5" | bc`
	GRUPO=$(pwd | cut -c1-$AUXNOMBRE)
}

function escapear_param
{
	echo -e "$1" > ../temp/aescapear.txt
	ESCAPEADO=$(sed "s/\//\\\\\//g" ../temp/aescapear.txt)
}

function setear_conf_param
{
	escapear_param $2
	sed "s/\($1 = \)\(.*\)/\1$ESCAPEADO/" ../conf/InstalarC.conf > ../temp/InstalarC.conf
	mv ../temp/InstalarC.conf ../conf/InstalarC.conf
}

function actualizar_archivo_configuracion
{
	if [ -f "../conf/InstalarC.conf" ];then
		setear_conf_param "BINDIR" "$DEFBINDIR"
		setear_conf_param "ARRIDIR" "$DEFARRIDIR"
		setear_conf_param "DATASIZE" "$DEFDATASIZE Mb"
		setear_conf_param "LOGDIR" "$DEFLOGDIR"
		setear_conf_param "LOGEXT" "$DEFLOGEXT"
		setear_conf_param "MAXLOGSIZE" "$DEFLOGSIZE Kb"
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/iniciarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/iniciarC.sh "+%d/%m/%Y %k:%M:%S")
		setear_conf_param "INICIARU" "$OWNER"
		setear_conf_param "INICIARF" "$FECHACREACION"
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/detectarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/detectarC.sh "+%d/%m/%Y %k:%M:%S")
		setear_conf_param "DETECTARU" "$OWNER"
		setear_conf_param "DETECTARF" "$FECHACREACION"
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/sumarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/sumarC.sh "+%d/%m/%Y %k:%M:%S")
		setear_conf_param "SUMARU" "$OWNER"
		setear_conf_param "SUMARF" "$FECHACREACION"
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/listarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/listarC.sh "+%d/%m/%Y %k:%M:%S")
		setear_conf_param "LISTARU" "$OWNER"
		setear_conf_param "LISTARF" "$FECHACREACION"
	else	
		#echo -e "$GRUPO"
		
		#echo -e "CURRDIR = /home/flavius/sistemasoperativos" > ../conf/InstalarC.conf
		echo -e "CURRDIR = $GRUPO" >> ../conf/InstalarC.conf
		echo -e "CONFDIR = $GRUPO/conf" >> ../conf/InstalarC.conf
		echo -e "DATAMAE = $GRUPO/mae" >> ../conf/InstalarC.conf
		echo -e "LIBDIR = $GRUPO/lib" >> ../conf/InstalarC.conf
		echo -e "BINDIR = $DEFBINDIR" >> ../conf/InstalarC.conf
		echo -e "ARRIDIR = $DEFARRIDIR" >> ../conf/InstalarC.conf
		echo -e "DATASIZE = $DEFDATASIZE Mb" >> ../conf/InstalarC.conf
		echo -e "LOGDIR = $DEFLOGDIR" >> ../conf/InstalarC.conf
		echo -e "LOGEXT = $DEFLOGEXT" >> ../conf/InstalarC.conf
		echo -e "MAXLOGSIZE = $DEFLOGSIZE Kb" >> ../conf/InstalarC.conf	
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/iniciarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/iniciarC.sh "+%d/%m/%Y %k:%M:%S")
		echo -e "INICIARU = $OWNER" >> ../conf/InstalarC.conf
		echo -e "INICIARF = $FECHACREACION" >> ../conf/InstalarC.conf
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/detectarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/detectarC.sh "+%d/%m/%Y %k:%M:%S")
		echo -e "DETECTARU = $OWNER" >> ../conf/InstalarC.conf
		echo -e "DETECTARF = $FECHACREACION" >> ../conf/InstalarC.conf
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/sumarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/sumarC.sh "+%d/%m/%Y %k:%M:%S")
		echo -e "SUMARU = $OWNER" >> ../conf/InstalarC.conf
		echo -e "SUMARF = $FECHACREACION" >> ../conf/InstalarC.conf
		OWNER=`stat -c %U $GRUPO$DEFBINDIR/listarC.sh`
		FECHACREACION=$(date -r $GRUPO$DEFBINDIR/listarC.sh "+%d/%m/%Y %k:%M:%S")
		echo -e "LISTARU = $OWNER" >> ../conf/InstalarC.conf
		echo -e "LISTARF = $FECHACREACION" >> ../conf/InstalarC.conf
		echo -e "reservada" >> ../conf/InstalarC.conf
		echo -e "reservada" >> ../conf/InstalarC.conf
	fi
}

function instalar_componente
{
	AUX=${INSTALADOS[$2]}
	if [ "$AUX" = "NO" ];then
		#echo -e "./$1.sh"
		if [ -f "./$1.sh" ];then
			cp "./$1.sh" "$GRUPO$DEFBINDIR/$1.sh" 
		else
			mostrar_grabar "Error en la instalacion, no se puede encontrar el archivo de comando $1.sh"
			fin
		fi
	fi
}

function generar_directorios_archivos
{	
	#solo mostrar
	mostrar_grabar "Creando estructuras de Directorio......."
	mkdir -p $GRUPO/conf
	mkdir -p $GRUPO/mae
	mkdir -p $GRUPO$DEFBINDIR
	mkdir -p $GRUPO$DEFARRIDIR
	mkdir -p $GRUPO$DEFLOGDIR
	mkdir -p $GRUPO/rechazados
	mkdir -p $GRUPO/preparados
	mkdir -p $GRUPO/listos
	mkdir -p $GRUPO/nolistos
	mkdir -p $GRUPO/ya
	mostrar_grabar "moviendo archivos...."
	if [ -f "./encuestas.mae" ];then
		cp "./encuestas.mae" "$GRUPO/mae/encuestas.mae" 
	else
		mostrar_grabar "Advertencia en la instalacion, no se puede encontrar el archivo encuestas.mae"
	fi
	if [ -f "./preguntas.mae" ];then
		cp "./preguntas.mae" "$GRUPO/mae/preguntas.mae" 
	else
		mostrar_grabar "Advertencia en la instalacion, no se puede encontrar el archivo preguntas.mae"
	fi
	if [ -f "./encuestadores.mae" ];then
		cp "./encuestadores.mae" "$GRUPO/mae/encuestadores.mae" 
	else
		mostrar_grabar "Advertencia en la instalacion, no se puede encontrar el archivo encuestadores.mae"
	fi
	
	instalar_componente "iniciarC" 1
	instalar_componente "detectarC" 2
	instalar_componente "sumarC" 3
	instalar_componente "listarC" 4
}

function configurar_logsize
{
	mostrar_grabar "Ingrese el tamaño maximo para los archivos $DEFLOGEXT (en Kbytes): $DEFLOGSIZE" 
	#opciones aceptar,cancelar,volver y opcion nueva
	read -e RESPUESTA
	if [[ "$RESPUESTA" != "a" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		DEFLOGSIZE=$RESPUESTA
	fi
}

function configurar_logext
{
	mostrar_grabar "Ingrese la extensión para los archivos de log: ($DEFLOGEXT)"
	#opciones aceptar,cancelar,volver y opcion nueva
	read -e RESPUESTA
	if [[ "$RESPUESTA" != "a" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		DEFLOGEXT=$RESPUESTA
	fi
}


function configurar_logdir
{
	mostrar_grabar "Ingrese el nombre del directorio de log: ($GRUPO$DEFLOGDIR)"
	#opciones aceptar,cancelar,volver y opcion nueva
	read -e RESPUESTA
	if [[ "$RESPUESTA" != "a" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		DEFLOGDIR=$RESPUESTA
	fi
}


function configurar_bindir
{
	mostrar_grabar "Ingrese el nombre del subdirectorio de ejecutables: ($GRUPO$DEFBINDIR)"
	#opciones aceptar,cancelar,volver y opcion nueva
	read -e RESPUESTA
	if [[ "$RESPUESTA" != "a" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		DEFBINDIR=$RESPUESTA
	fi
}

function chequear_espacio_disco
{
	df -h > ../temp/discspace.txt
	ESPACIOLIBRE=`sed -n "s/\([^ ]*\)\([ ]*\)\([0-9GKMB,][0-9GKMB,]*\)\([ ]*\)\([0-9GKMB,][0-9GKMB,]*\)\([ ]*\)\([0-9,][0-9,]*\)\([GKMB]\)\(.*\)\/$/\7/p" ../temp/discspace.txt`
	UNIDAD=`sed -n "s/\([^ ]*\)\([ ]*\)\([0-9GKMB,][0-9GKMB,]*\)\([ ]*\)\([0-9GKMB,][0-9GKMB,]*\)\([ ]*\)\([0-9,][0-9,]*\)\([GKMB]\)\(.*\)\/$/\8/p" ../temp/discspace.txt`
	case "$UNIDAD" in
		"G")
			ESPACIOLIBRE=`echo "$ESPACIOLIBRE*1024" | bc`
		;;
		"M")
			ESPACIOLIBRE=$ESPACIOLIBRE
		;;
		"K")
			ESPACIOLIBRE=`echo "$ESPACIOLIBRE/1024" | bc`
		;;
		"B")
			ESPACIOLIBRE=`echo "$ESPACIOLIBRE*1048576" | bc`
		;;
	esac
	HAYESPACIOLIBRE="SI"
	if [ $ESPACIOLIBRE -le $DEFDATASIZE ];then
		HAYESPACIOLIBRE="NO"
	fi

} 

function configurar_datasize
{
	mostrar_grabar "Ingrese el espacio mínimo requerido para datos externos(en Mbytes):"
	mostrar_grabar "$DEFDATASIZE Mb"
	#opciones aceptar,cancelar,volver y opcion nueva
	read -e RESPUESTA
	if [[ "$RESPUESTA" != "a" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		DEFDATASIZE=$RESPUESTA
	fi
}

function configurar_arridir
{
	mostrar_grabar "Ingrese el nombre del directorio que permite el arribo de archivos"
	mostrar_grabar "externos ($GRUPO$DEFARRIDIR)"
	#opciones aceptar,cancelar,volver y opcion nueva
	read -e RESPUESTA
	if [[ "$RESPUESTA" != "a" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		DEFARRIDIR=$RESPUESTA
	fi
}

function configurar_instalacion
{
	#falta log de las respuestas
	configurar_arridir
	if [[ "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
		HAYESPACIOLIBRE="NO"
		while [[ "$HAYESPACIOLIBRE" = "NO" && "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];do
			configurar_datasize
			if [[ "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then
				chequear_espacio_disco
				if [ "$HAYESPACIOLIBRE" = "NO" ];then		
				mostrar_grabar "Insuficiente espacio en disco. Espacio disponible: $ESPACIOLIBRE Mb."
				mostrar_grabar "Espacio requerido $DEFDATASIZE Mb"	
				DEFDATASIZE="100"		
				fi
			fi
		done
	fi
	if [[ "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then		
		configurar_bindir
	fi	
	if [[ "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then		
		configurar_logdir
	fi
	if [[ "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then		
		configurar_logext
	fi
	if [[ "$RESPUESTA" != "c" && "$RESPUESTA" != "v" ]];then		
		configurar_logsize
	fi
	if [ "$RESPUESTA" = "c" ];then
		mostrar_grabar "Proceso de instalación cancelado"
		fin
	fi
	if [ "$RESPUESTA" = "v" ];then
		configurar_instalacion
	fi
	
}

function fin
{
	#cerrar el InstalarC.log
	rm -fr ../temp
	exit 0
}

function mostrar_grabar
{
	echo -e "$1"
	#loguear mensaje
}

function instalacion_parcial
{
	mostrar_grabar "Se propone la instalación de los componentes faltantes, con las variables de instalación" 
	mostrar_grabar "siguientes, predefinidas en el archivo de configuración : "
	cat "../conf/InstalarC.conf"
	mostrar_grabar "¿acepta completar la instalación?(Si/No)"
	read -e RESPUESTA
	if [ "$RESPUESTA" = "No" ];then
		mostrar_grabar "¿desea iniciar una instalación completa nueva?(Si/No)"
		read -e RESPUESTA	
		if [ "$RESPUESTA" = "Si" ];then
			INSTALADOS[1]="NO"
			INSTALADOS[2]="NO"
			INSTALADOS[3]="NO"
			INSTALADOS[4]="NO"
			setParamDefault
			instalacion_completa
		fi	
	else
		setParamFromConf
		generar_directorios_archivos
		actualizar_archivo_configuracion
		verificar_instalacion
		print_instalacion_parcial
		mostrar_grabar "* FIN del proceso de Instalación Copyright SisOp (c)2011	*"
		mostrar_grabar "*****************************************************************"	
	fi
}

function instalacion_completa
{		
	mostrar_grabar "********************************************************"
	mostrar_grabar "*      Sistema Consultar Copyright SisOp (c)2011       *"
	mostrar_grabar "********************************************************"
	mostrar_grabar "*Al instalar Consultar UD. expresa estar en un todo de acuerdo *"
	mostrar_grabar "*con los términos y condiciones del \"ACUERDO DE LICENCIA DE *"
	mostrar_grabar "*SOFTWARE \" incluido en este paquete."
	mostrar_grabar "********************************************************"
	mostrar_grabar "Aceptar/Rechazar(a/r)"
	RESPUESTA="";	
	read -e RESPUESTA
	if [ "$RESPUESTA" = "a" ];then
		
		#mkdir ../temp
		#se obtiene la informacion de version de perl existente y se guarda en un archivo
		(perl --version) > ../temp/perlversion.txt
		#se extrae la version de perl del archivo generado anteriormente
		PERL=$(sed -n "s/\(.*v\)\([5-9]\.[0-9.]*\)\(.*\)/\2/p" ../temp/perlversion.txt)	
		if [ "$PERL" = "" ];then
			mostrar_grabar "Para instalar Consultar es necesario contar con Perl 5 o superior"
			mostrar_grabar "intalado. Efectúe su instalación e inténtelo nuevamente. Proceso de"	
			mostrar_grabar "Instalación Cancelado"
		else
			mostrar_grabar "La version de perl instalada en el sistema es v$PERL"
			mostrar_grabar "Todos los directorios del sistema serán subdirectorios de $GRUPO"
			mostrar_grabar "Todos los componentes de la instalación se obtendrán del repositorio:"
			mostrar_grabar "$GRUPO/inst"
			mostrar_grabar $(ls)
			mostrar_grabar "El log de la instalacion se almacenara en $GRUPO/inst"
			mostrar_grabar "Al finalizar la instalación, si la misma fue exitosa se dejara un"
 			mostrar_grabar "archivo de configuración en $GRUPO/conf"
			while [ "1" = "1" ]; do
				configurar_instalacion
				clear
				mostrar_grabar  "****************************************************************"
				mostrar_grabar  "*"
				mostrar_grabar  "*	Parámetros de instalación del paquete Consultar		*"
				mostrar_grabar  "****************************************************************"
				mostrar_grabar  "*"
				mostrar_grabar  "Directorio de trabajo: $GRUPO"
				mostrar_grabar  "Directorio de instalación: $GRUPO/inst"
				mostrar_grabar  "Directorio de configuración: $GRUPO/conf"
				mostrar_grabar  "Directorio de datos maestros: $GRUPO/mae"
				mostrar_grabar  "Directorio de ejecutables: $DEFBINDIR"
				mostrar_grabar  "Librería de funciones: $GRUPO/lib"
				mostrar_grabar	"Directorio de arribos: $DEFARRIDIR"
				mostrar_grabar	"Espacio mínimo reservado en $ARRIDIR: $DEFDATASIZE MB"
				mostrar_grabar  "Directorio para los archivos de Log: $DEFLOGDIR"
				mostrar_grabar  "Extensión para los archivos de Log: $DEFLOGEXT"
				mostrar_grabar  "Tamaño máximo para los archivos de Log: $DEFLOGSIZE KB"
				mostrar_grabar  "Log de la instalación: $GRUPO/inst" 
				mostrar_grabar  "Si los datos ingresados son correctos de ENTER para continuar, si"
				mostrar_grabar	"desea modificar algún parámetro oprima cualquier tecla para reiniciar"
				#si toca cualquier tecla que no sea tab,enter o space
				read -d '' -sn1 RESPUESTA
				if [ "$RESPUESTA" = "" ];then
					break
				else
					clear
				fi
			done
			mostrar_grabar "Iniciando Instalación... Está UD. seguro? (Si/No)"			
			read -e RESPUESTA			
			if [ "$RESPUESTA" != "Si" ];then
				fin
			fi
			generar_directorios_archivos
			actualizar_archivo_configuracion
			verificar_instalacion
			print_instalacion_parcial
			mostrar_grabar "* FIN del proceso de Instalación Copyright SisOp (c)2011	*"
			mostrar_grabar "*****************************************************************"	
		fi
	fi
}

function print_instalacion_completa
{
	mostrar_grabar "********************************************************"
	mostrar_grabar "*      Sistema Consultar Copyright SisOp (c)2011       *"
	mostrar_grabar "********************************************************"
	mostrar_grabar "*Se encuentran instalados los siguientes componentes:  *"
	mostrar_grabar "$MENSAJESI"
	mostrar_grabar "********************************************************"
	mostrar_grabar "Proceso de instalacion cancelado"
}

function print_instalacion_parcial
{
	mostrar_grabar "********************************************************"
	mostrar_grabar "*      Sistema Consultar Copyright SisOp (c)2011       *"
	mostrar_grabar "********************************************************"
	mostrar_grabar "*Se encuentran instalados los siguientes componentes:  *"
	mostrar_grabar "$MENSAJESI"
	mostrar_grabar "*Falta instalar los siguientes componentes:            *"
	mostrar_grabar "$MENSAJENO"
	mostrar_grabar "********************************************************"
}

function comando_instalado
{
	
	if [ -f $1 ];then
		OWNER=`stat -c %U $1`
		FECHACREACION=$(date -r $1 "+%d/%m/%Y %k:%M:%S")
		INSTALADOS[$3]="SI"
		MENSAJESI="$MENSAJESI\n*$2 $FECHACREACION $OWNER*"
		#mostrar_grabar $MENSAJESI
	else
		INSTALACION="parcial"
		INSTALADOS[$3]="NO"
		MENSAJENO="$MENSAJENO\n*$2"
	fi 
}
function verificar_instalacion
{
#1iniciarC
#2detectarC
#3sumarC
#4listarC
FILE="../conf/InstalarC.conf"
INSTALADOS[1]="NO"
INSTALADOS[2]="NO"
INSTALADOS[3]="NO"
INSTALADOS[4]="NO"
if [ -f $FILE ];then
	INSTALACION="completa"
	MENSAJESI=""
	MENSAJENO=""
	#se verifica esten instalados los comandos en bin
	getConfigParam "BINDIR"
	PATHAUX="..$CONFIGPARAM/iniciarC.sh"
	comando_instalado $PATHAUX "iniciarC" 1
	PATHAUX="..$CONFIGPARAM/detectarC.sh"
	comando_instalado $PATHAUX "detectarC"	2
	PATHAUX="..$CONFIGPARAM/sumarC.sh"
	comando_instalado $PATHAUX "sumarC" 3	
	PATHAUX="..$CONFIGPARAM/listarC.sh"
	comando_instalado $PATHAUX "listarC" 4	
	#PATHAUX="$CONFIGPARAM/mirarC.sh"
	#comando_instalado $PATHAUX "mirarC"		
	#PATHAUX="$CONFIGPARAM/moverC.sh"
	#comando_instalado $PATHAUX "moverC"	
	#PATHAUX="$CONFIGPARAM/loguearC.sh"
	#comando_instalado $PATHAUX "loguearC"	
	#PATHAUX="$CONFIGPARAM/stopD.sh"
	#comando_instalado $PATHAUX "stopD"	
	#PATHAUX="$CONFIGPARAM/starD.sh"
	#comando_instalado $PATHAUX "startD"	
	#se verifica esten instalados los archivos maestros en mae
	#getConfigParam "DATAMAE"
	#PATHAUX="$CONFIGPARAM/encuestas.mae"
	#comando_instalado $PATHAUX "encuestas"
	#PATHAUX="$CONFIGPARAM/preguntas.mae"
	#comando_instalado $PATHAUX "preguntas"
	#PATHAUX="$CONFIGPARAM/encuestadores.mae"
	#comando_instalado $PATHAUX "encuestadores"
	if [ "$MENSAJESI" = "" ];then
		INSTALACION="ninguna"
	fi

else 
	INSTALACION="ninguna"
fi
}
function getConfigParam
{
	CONFIGPARAM=`/bin/sed -n "s/$1 = //p" ../conf/InstalarC.conf`
	#echo $CONFIGPARAM
}
mkdir -p ../temp
DATE=$(date "+%d/%m/%Y %k:%M:%S")
mostrar_grabar "$DATE-$USERNAME-instalarC-I-Inicio de ejecucion"
verificar_instalacion
case "$INSTALACION" in
	"completa")
		print_instalacion_completa
		;;
	"parcial")
		print_instalacion_parcial
		instalacion_parcial
		;;
	"ninguna")
		if [ -f ../conf/InstalarC.conf ];then
			setParamFromConf	
		else
			setParamDefault
		fi
		instalacion_completa
		;;
esac
fin

