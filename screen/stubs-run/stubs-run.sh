#!/bin/sh
id=stubs
screen -S $id -d -m

# keep the output of terminated commands for debugging
screen -r -X -S $id zombie kr

screen -r -X -S $id screen -t t1 $HOME/stubs/t1.sh
screen -r -X -S $id screen -t t2 $HOME/stubs/t2.sh
