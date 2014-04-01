#!/usr/bin/env python

import argparse
import contextlib
import os
import re
import string


def sort(a, b):
    i1 = int(a.group(1) or -1)
    i2 = int(b.group(1) or -1)
    if i1 < i2:
        return -1
    elif i1 > i2:
        return 1
    else:
        return 0


def get_zookeepers():
    pattern = re.compile(r'^ZK([0-9]*)_PORT_(2181)_TCP_ADDR$')
    matches = filter(lambda x: x, (pattern.match(key) for key in os.environ.keys()))
    matches.sort(sort)
    ports = (match.group(2) for match in matches)
    hostnames = (os.environ[match.group(0)] for match in matches)
    addr = (':'.join(pair) for pair in zip(hostnames, ports))
    return ','.join(addr)


def get_broker_id():
    return os.environ.get('BROKER_ID', 0)


def get_context():
    return {
        'zookeeper_servers': get_zookeepers(),
        'broker_id': get_broker_id()
    }


def is_template_file(filename):
    return os.path.isfile(filename) and filename.endswith('.template')


def transform_file(filename):
    target_file = os.path.splitext(filename)[0]
    with contextlib.nested(open(filename), open(target_file, 'w')) as (infile, outfile):
        template = string.Template(infile.read())
        outfile.write(template.substitute(get_context()))


def transform_files():
    parser = argparse.ArgumentParser(description='Compile python template files using context from os.environ.')
    parser.add_argument('path', metavar='PATH', help='path which holds template files')
    args = parser.parse_args()
    srcpath = args.path
    filenames = (os.path.join(srcpath, filename) for filename in os.listdir(srcpath))
    matches = (filename for filename in filenames if is_template_file(filename))
    for filename in matches:
        transform_file(filename)


if __name__ == '__main__':
    transform_files()

