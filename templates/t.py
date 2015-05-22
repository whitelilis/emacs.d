#!/usr/bin/env python
# coding=utf-8

import sys
import os
import inspect
#################################################################################################
import logging
from logging.handlers import RotatingFileHandler
Rthandler = RotatingFileHandler('done_ana.log', maxBytes=10*1024*1024,backupCount=5)
formatter = logging.Formatter('%(asctime)s P%(process)d T%(thread)d %(filename)s:%(lineno)d %(funcName)s %(levelname)s %(message)s')
Rthandler.setFormatter(formatter)
logger = logging.getLogger('')
logger.addHandler(Rthandler)
logger.setLevel(logging.INFO)
pwd = os.path.abspath(os.path.dirname(inspect.stack()[0][1]))

import socket
hostname = socket.gethostname()
################################################################################################

%@
