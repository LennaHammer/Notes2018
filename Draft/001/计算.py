#%%
import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import sympy

def plot1(f):
    x = np.linspace(-10,10,100)
    y = f(x)
    plt.plot(x,y)

plot1(np.sin)


def s1(x):
    r'''
    公式 $s(x)=\frac{1}{1+e^{-x}}$
    当 x 为 向量时，按元素计算
    也可以写成 $s(x)=\frac{1+\tanh(\frac{x}{2})}{2}$
    '''
    return 1/(1+np.e**(-x))

s = lambda x: 1/(1+np.e**(-x))
s2 = lambda x: (1 + np.tanh(x / 2)) / 2
print(s(0))
print(s(np.array([[1,3],[2,4]])))
print(s2(0))
plot1(s)
#plot1(s2)

#%%
x = sympy.symbols('x')
s3 = 1/(1+sympy.E**(-x))
print(s3)
print(sympy.diff(s3,x))

def ll1_cost(xs,w):
    x = 1
    y = np.dot(x,w)+b
    y2 = 1/(1+np.e**(-y))
    L = np.sum(w**2)
    xent = -y * np.log(y2) - (1-y) * np.log(1-y2)
    cost = None

def lo():
    # Construct Theano expression graph
    p_1 = 1 / (1 + T.exp(-T.dot(x, w) - b))   # Probability that target = 1
    prediction = p_1 > 0.5                    # The prediction thresholded
    xent = -y * T.log(p_1) - (1-y) * T.log(1-p_1) # Cross-entropy loss function
    cost = xent.mean() + 0.01 * (w ** 2).sum()# The cost to minimize
    gw, gb = T.grad(cost, [w, b])             # Compute the gradient of the cost
                                            # w.r.t weight vector w and
                                            # bias term b
                                            # (we shall return to this in a
                                            # following section of this tutorial)


# http://deeplearning.net/software/theano/tutorial/examples.html