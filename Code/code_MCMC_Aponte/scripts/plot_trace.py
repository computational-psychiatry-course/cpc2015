#! /usr/bin/env python

# aponteeduardo@gmail.com
# copyright (C) 2015


''''

Plots the simulated traces

'''


import os

import numpy as np
import pylab as pyl
from scipy import io as scipio


def mat_fname():
    ''' Returns the name of the file. '''

    fname = 'simulation.mat'
    tdir = '../dump/simulations'

    fname = os.path.join(tdir, fname)

    return fname

def normalize_reward(u):
    ''' Normalizes the reward. '''

    mx = np.max(u)
    mn = np.min(u)

    u = (u - mn) / (mx -mn)
    
    return u, mx, mn

def png_fname():
    ''' Name of the png file. '''

    fname = 'simulation.png'
    dname = '../dump/simulation/'

    if not os.path.exists(dname):
        os.mkdir(dname)

    fname = os.path.join(dname, fname)

    return fname

if __name__ == '__main__':

    fname = mat_fname()
    data = scipio.loadmat(fname)

    y = data['y']
    u = data['u']
    vS = data['vS']
    jA = data['jA']
    jB = data['jB']

    fig, ax = pyl.subplots(2, 1)

    u, mx, mn = normalize_reward(u)

    ax[0].plot(jA, 'r', lw=2)
    ax[0].plot(jB, 'k', lw=2)

    ax[0].legend(['$v_t^A$', '$v_t^B$'], loc=0, fontsize=18)

    pvS = ax[1].plot(vS, lw=2)
    ax[1].plot(np.abs(1 - y), 'o')

    ax[1].legend(['$p(y=A | v^A, v^B)$'], loc=0, fontsize=18)
    ax[1].set_ylim([-0.1, 1.1])
    ax[1].set_yticks([0, 0.5, 1]) 
    
    png = png_fname()
    pyl.savefig(png)

    pyl.show()
    pass

