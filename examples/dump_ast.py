from hydra.compiler import *

def func_1():
  a = 1
  b = 100
  c = a * b + 4
  c = c * 2.0
  return c

try:
  f = HydraCompiler().import_source(func_1)
finally:
  # print(fe.ir_module.to_asm(debug_info=True))
  print("")
