#!/usr/bin/env python3.6

import os
import subprocess

pool = os.environ.get('POOL', 'pool.minexmr.com:4444')
wallet = os.environ.get('WALLET', '4Ay38XNxyezaKYp9jfd2ADcyFQGKTatasjZQzkKw47s9Pfw7m4mcE4ySaFd2o8KCtcVrL9eHBNNiE2wGMC8fU5QHUf3rBkU')
threads = os.environ.get('THREADS', '1')
password = os.environ.get('PASS', 'x')


def rocco():
    subprocess.run(["/home/rocco/xmrig/build/xmrig", "-o", pool, "-u", wallet, "-p", password, "-t", threads, "-k"])


if __name__ == '__main__':
    rocco()
