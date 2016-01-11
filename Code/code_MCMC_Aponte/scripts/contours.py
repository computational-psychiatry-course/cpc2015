#! /usr/bin/env python

# aponteeduardo@gmail.com
# copyright (C) 2015


''''

Generate contour plots.

'''

import numpy as np
from matplotlib.mlab import griddata
import matplotlib.pyplot as plt
import numpy.ma as ma
from numpy.random import uniform


def gen_cov(angle, eigen):
    ''' Return the rotation matrix. '''

    rotmat = np.array([[np.cos(angle), -np.sin(angle)],
        [np.sin(angle), np.cos(angle)]])

    rotmat = np.dot(np.diag(eigen), rotmat)

    return rotmat



# make up some randomly distributed data
npts = 200
x = uniform(-2,2,npts)
y = uniform(-2,2,npts)
z = np.exp(-x**2-y**2)
# define grid.
xi = np.linspace(-2.1,2.1,100)
yi = np.linspace(-2.1,2.1,100)

xv, yv = np.meshgrid(xi, yi)

tx = xv.reshape((xv.size, 1))
ty = yv.reshape((yv.size, 1))

txy = np.concatenate([tx, ty], 1)

tilt = gen_cov(np.pi * 0.25, [4.5, 1])


zv = np.exp(-0.5 * np.diag(np.dot(np.dot(txy, np.dot(tilt.T, tilt)), txy.T)))
zv = zv.reshape(xv.shape)

# grid the data.
#zi = griddata(x,y,z,xi,yi)
# contour the gridded data, plotting dots at the randomly spaced data points.
CS = plt.contour(xv,yv,zv,5,linewidths=0.5,colors='k')
CS = plt.contourf(xv,yv,zv,5,cmap=plt.cm.jet)
plt.xlim(-2,2)
plt.ylim(-2,2)
plt.title('griddata test (%d points)' % npts)
plt.show()


if __name__ == '__main__':
    pass    

