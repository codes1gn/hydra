path=`dirname $0`'/..'
echo $path

PATH_BAK=$PYTHONPATH

export PYTHONPATH=$PYTHONPATH:$path && export DEBUG_MODE=false && python $path/examples/dump_ast.py
unset PYTHONPATH
export PYTHONPATH=$PATH_BAK

