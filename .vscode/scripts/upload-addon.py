#!/usr/bin/env python

"""Upload addon zip using ayon-python-api.

It's used to upload addons versions that epcified as arguments.
It requires having a .env file with the following keys:
- 'AYON_SERVER_URL': AYON server URL
- 'AYON_API_KEY': AYON service user api key

Script usage examples: 
  python upload_addon_zip.py --addon E:/ayon-core
  python upload_addon_zip.py --package-dir E:/packages --addon E:/ayon-houdini
  python upload_addon_zip.py --addon E:/ayon-core --addon E:/ayon-houdini --addon E:/ayon-applications
  
Support flags: 
'--debug': used to make log more verbose.
'--addon' ('-a'): used to specify addon repo full path, it'll be used to get addon zip name.
'--package-dir' : used to specify package directory.

Notes:
    users must at least one of these flags '--addon or '--package-dir'.
    if '--package-dir' not found, the code will fall to default package dir in the given addon paths.
    if '--addon' not found, the code will upload all packages found in the given package dir.

"""

import argparse
import logging
import os
import sys
from pathlib import Path

try:
    import ayon_api
    from ayon_api import get_server_api_connection

    has_ayon_api = True
except ModuleNotFoundError:
    has_ayon_api = False

try:
    from dotenv import load_dotenv

    load_dotenv()
except ModuleNotFoundError:
    if has_ayon_api:
        logging.warning("dotenv not installed, skipping loading .env file")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--debug",
        dest="debug",
        action="store_true",
        help="Debug log messages."
    )
    parser.add_argument(
        "-a",
        "--addon",
        dest="addons",
        action="append",
        help="Limit addon creation to given addon repo paths.",
    )
    parser.add_argument(
        "--package-dir",
        dest="package_dir",
        default=None,
        help="Override default addon path."
    )
    
    args = parser.parse_args(sys.argv[1:])
    
    # Set Log Level and create log object
    level = logging.INFO
    if args.debug:
        level = logging.DEBUG
    logging.basicConfig(level=level)
    log: logging.Logger = logging.getLogger("upload_package")

    # Check if addon path exists.
    package_dir = None
    if args.package_dir:
        package_dir = args.package_dir
        package_dir = package_dir.replace(".", os.getcwd())
        package_dir = Path(package_dir)
        package_dir = package_dir.resolve()

        if not package_dir.exists():
            log.debug(package_dir)
            raise RuntimeError(
                "Package directory doesn't exist: {}".format(package_dir)
            )
        
        package_dir = str(package_dir)

    addons = []
    if args.addons:
        for addon in args.addons:
            # read package.py and get zip name
            content = {}
            with open(f"{addon}/package.py") as package:
                exec(package.read(), content)

            if not package_dir:
                # Fall to the default package dir 
                package_dir = f"{addon}/package"

            addons.append(
                f"{package_dir}/{content['name']}-{content['version']}.zip"
            )
    else:
        # Get all zips inside the given package path
        if not package_dir:
            raise RuntimeError(
                "No package dir was specified."
            )
        for package_name in os.listdir(package_dir):
            addons.append(f"{package_dir}/{package_name}")
    
    if not addons:
        raise RuntimeError(
                "No Addons found. Please re-run the script with the correct args."
            )

    # Log in and Try to upload addons
    ayon_api.init_service()
    log.info("Trying to upload zips")

    trigger_restart = False

    for path in addons:

        if not os.path.isfile(path):
            log.warning("Skipping, file is not found: '{}'."
                        .format(path))
            continue 
        
        log.info("Uploading: '{}'".format(path))
        response = ayon_api.upload_addon_zip(path)
    
    if trigger_restart: 
        server = get_server_api_connection()
        if server:
            server.trigger_server_restart()
        else:
            log.warning("Could not restart server")