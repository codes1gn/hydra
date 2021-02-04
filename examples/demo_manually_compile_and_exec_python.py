import tensorflow.compat.v1 as tf

def model(input1, input2):
    import tensorflow.compat.v1 as tf
    a = tf.add(input1, input2)
    b = input1 - input2
    c = tf.multiply(a, b)
    return c

import inspect
# source_code = model
source_code = inspect.getsource(model)
source_code += "logits = model(input1, input2)\n"
print(source_code)
_a = tf.constant(1, shape=[2, 2])
_b = tf.constant(2, shape=[2, 2])


# error, how to run??
_local = {'input1':_a, 'input2':_b, 'logits': 0}
_global = {}
exec(source_code, _global, _local)
logits = _local['logits']

with tf.Session() as sess:
    _ = sess.run(logits)
    print(_)
