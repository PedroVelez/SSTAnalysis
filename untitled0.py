#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 27 23:24:44 2018

@author: pvb
"""
import scipy.io as sio
import matplotlib.pyplot as plt


data = sio.loadmat('./Data/SSTRaprocan.mat')
sstd=data['sstd']

plt.plot(sstd[1,:])