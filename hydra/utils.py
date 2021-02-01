import os

__all__ = [
    'vlog'
]

def vlog(*args, **kwargs):
  if bool(os.getenv("DEBUG_MODE", 'False').lower() in ['true', '1']):
    print(*args, **kwargs)
  else:
    pass

