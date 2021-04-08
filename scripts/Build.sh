#!/bin/bash -f

if [ "$1" == "" ]; then
    echo "Usage:  $0 <dict_name>"
    exit 1
fi
dict=$1

TOPDIR="$( builtin cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

dictname=$dict.dic
outdir=$TOPDIR/dist
outdict=$outdir/$dictname
basedir=$TOPDIR/base
generator=$basedir/$dict'-generator.dic'

if [ ! -e $generator ]; then
    echo "Missing configuration file $generator"
    exit 1
fi

if [ ! -e $outdir ]; then
    mkdir $outdir
fi

rm -f $outdict
build_dict_cli --op build --input_dict_path $generator --output_dict_path $outdict --cleanup
version=`build_dict_cli --op get_version --input_dict_path $outdict`
#
archivefile=$TOPDIR/archive/$dict-v$version'.dic'
cp $outdict $archivefile

echo "Completed generation of $dictname"
exit 0
