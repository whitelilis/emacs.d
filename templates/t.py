#!/usr/bin/env python
# coding=utf-8

import sys
import os

#################################################################################################
import logging
from logging.handlers import RotatingFileHandler
Rthandler = RotatingFileHandler('done_ana.log', maxBytes=10*1024*1024,backupCount=5)
formatter = logging.Formatter('%(asctime)s P%(process)d T%(thread)d %(levelname)s %(message)s')
Rthandler.setFormatter(formatter)
logger = logging.getLogger('')
logger.addHandler(Rthandler)
logger.setLevel(logging.INFO)
################################################################################################

%@
