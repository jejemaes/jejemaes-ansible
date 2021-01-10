#!/usr/bin/python3

import json
import os
import sys, getopt


BASE_XML_PORT = 8069  # base port
BASE_VERSION = '11.0' # we deploy version 11.0 and nothing before


def _compute_port(version, is_longpolling=False):
    offset = 0
    if is_longpolling:
        offset = 3

    port = 8069
    base_version = 11
    return BASE_XML_PORT + (version % (int(float(BASE_VERSION)))) * int(float(BASE_VERSION)) + offset

def get_config(argv):
    """ Return the port on which the odoo version should run. '--longpolling' option indicates if we need the longpolling port.
        Each version will have a range of 11 possible port. In this range, the first is the port, and and the 3rd is the longpolling port.
    """
    try:
        version_str = argv[0]
        version = int(float(version_str))
    except ValueError:
        return {}

    try:
        base_src_path = argv[1]
    except Exception:
        return {}

    addons_path_list = []
    for item in os.listdir(base_src_path):
        if item != 'odoo':
            full_path = os.path.join(base_src_path, item)
            if os.path.isdir(full_path):  # ~/src/theme, ~/src/jejemaes, ...
                full_path = os.path.join(base_src_path, item, version_str)
                if os.path.isdir(full_path):  # ~/src/theme/14.0, ~/src/jejemaes/14.0, ...
                    addons_path_list.append(full_path)
    addons_path_list.append(os.path.join(base_src_path, 'odoo', version_str, 'addons'))  # odoo base addons are late

    # TODO: compute it, formula in openerp script
    max_workers = 3

    return {
        # misc
        'addons_path': addons_path_list,
        # database
        'db_maxconn': 32,
        'without_demo': True,
        # hardware (harcoded from odoo)
        'limit_time_cpu': 900,
        'limit_time_real': 2700,  # downloading a 3GB database backup take a long time...
        # thread and subporcess
        'max_cron_threads': 1,
        'workers': max_workers,
        # dbfilter based on host, but cloud_base module will force it
        'dbfilter': '^(%h)$',
        'list_db': True, # disable db list --no-database-list arg
        # ports
        'xmlrpc_interface': '127.0.0.1',
        'xmlrpcs_interface': '127.0.0.1',
        'xmlrpc_port': _compute_port(version),
        'xmlrpcs_port': _compute_port(version),
        'longpolling_port': _compute_port(version, is_longpolling=True),
    }

if __name__ == "__main__":
    data = get_config(sys.argv[1:])
    print(json.dumps(data))
