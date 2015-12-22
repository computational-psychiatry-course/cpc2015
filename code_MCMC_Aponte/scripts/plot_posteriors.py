#! /usr/bin/env python

# aponteeduardo@gmail.com
# copyright (C) 2015


''''

Plot the posterior distributions.

'''

import os

import numpy as np
import scipy.io as scio
import pylab as pyl


def posteriors_fname():
    ''' Return name of the file with the posteriors. '''

    fname = 'posteriors.mat'
    dname = '../dump/posteriors'

    fname = os.path.join(dname, fname)

    return fname


if __name__ == '__main__':
    
    fname = posteriors_fname()
    post = scio.loadmat(fname)
    post = post['post']
    
    theta = post['theta'][0, 0]

    alpha = np.arctan(theta[0, :])/np.pi + 0.5

    print(np.mean(alpha))

    beta = np.exp(theta[1, :])

    print np.mean(beta)

    fig, ax = pyl.subplots(2, 1)

    ax[0].plot(alpha[0:1000], 'r', lw=1.5)
    ax[1].plot(beta[0:1000], 'g', lw=1.5)

    pyl.savefig('../dump/posteriors/traces.png')

    fig, ax = pyl.subplots(1, 2, figsize=(8, 4))

    ax[0].hist(beta, color='g', bins=50)
    ax[1].hist(alpha, color='r', bins=50)

    pyl.savefig('../dump/posteriors/hists.png')

    pyl.show()
    pass

