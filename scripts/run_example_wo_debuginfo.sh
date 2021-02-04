path=`dirname $0`'/..'
echo $path

export PYTHONPATH=$path && export DEBUG_MODE=false && python $path/examples/dump_ast.py
