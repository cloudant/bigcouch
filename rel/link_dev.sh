#!/usr/bin/env bash

mklinks() {
    for node in `ls -d rel/dev?`; do
        app=`basename $1`
        apppath=`ls -d $node/lib/$app*`

        rm -rf $apppath/ebin
        rm -rf $apppath/include
        rm -rf $apppath/priv

        ln -s $PWD/$1/ebin $apppath/ebin 2>/dev/null
        ln -s $PWD/$1/include $apppath/include 2>/dev/null
        ln -s $PWD/$1/priv $apppath/priv 2>/dev/null
    done
}

for dir in `ls -d deps/*`; do
    mklinks $dir
done

mklinks apps/couch
