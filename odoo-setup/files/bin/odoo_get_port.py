#!/usr/bin/python

import sys, getopt


def get_port(argv):
    """ Return the port on which the odoo version should run. '--longpolling' option indicates if we need the longpolling port.
        Each version will have a range of 11 possible port. In this range, the first is the port, and and the 3rd is the longpolling port.
    """
    try:
        version = int(float(argv[0]))
    except ValueError:
        return '0'

    offset = 0
    if len(argv) == 2 and argv[1] == '--longpolling':
        offset = 3

    port = 8069  # base port
    base_version = 11  # we deploy version 11.0 and nothing before
    return port + (version % base_version) * base_version + offset

if __name__ == "__main__":
   print(get_port(sys.argv[1:]))
