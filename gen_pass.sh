#!/bin/bash
len=$1
nb=$2


if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: ./gen_pass.sh [lenght] [number]"
    exit 1
fi

< /dev/urandom tr -dc \`1234567890\-\=qwertyuiop\[\]\asdfghjkl\;\'zxcvbnm\,\.\/\~\!\@\#\$\%\^\&\*\(\)\_\+QWERTYUIOP\{\}\|ASDFGHJKL\:\"ZXCVBNM\<\>\? | fold -w $len | head -n $nb
