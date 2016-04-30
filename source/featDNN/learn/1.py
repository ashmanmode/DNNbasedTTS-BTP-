import theano
from theano import tensor as T

a = T.scalar();
b = T.scalar();

y = a*b;

mult = theano.function(inputs=[a,b], outputs=y)

print mult(2,3)