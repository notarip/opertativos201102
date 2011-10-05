#!/bin/bash

function prueba1
{
	PRUEBA1=AAAA

	if [ -z "$PRUEBA1" ];then
		echo prueba 1 vacia
	fi

	if [ -z "$PRUEBA2" ];then
		echo prueba 2 vacia
	fi 
}

function prueba2
{
	
	LISTA=$(find . -type f | sed 's/\(^.\/\)\(.*\)/\2/')

	for ARCH in $LISTA 
	do	
		echo $ARCH
		#break
	done
}


prueba2
