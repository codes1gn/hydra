import ast
import inspect
import textwrap


class HydraCompiler:

  __slots__ = ['_py_module']

  def __init__(self):
    self._py_module = None

  @property
  def py_module(self):
    return self._py_module

  def import_source(self, func):
    src_filename = inspect.getsourcefile(func)
    print('src_filename = ', src_filename)
    src_lines, start_lineno = inspect.getsourcelines(func)
    print('src_lines = ', src_lines)
    print('start_lineno = ', start_lineno)
    src_code = "".join(src_lines)
    print('src_code with indent = ', src_code)
    src_code = textwrap.dedent(src_code)
    print('src_code without indent = ', src_code)
    ast_root = ast.parse(src_code, filename=src_filename)

    # adjust start_lineno starting from 0 as file header
    ast.increment_lineno(ast_root, n=start_lineno-1)
    print('dump ast_root = ', ast.dump(ast_root))

    # get module body
    ast_fdef = ast_root.body[0]
    print('dump ast_function_def = ', ast.dump(ast_fdef, include_attributes=True))