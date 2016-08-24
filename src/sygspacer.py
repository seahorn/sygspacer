#!/usr/bin/env python

import sys
import os
import os.path
import threading
from multiprocessing import Process, Pool
import multiprocessing
import z3
import z3core
import stats
from z3_utils import *
from LogManager import LoggingManager
from sygparser import SygSpacerParser
import stats
import cStringIO
import utils
from six.moves import cStringIO # Py2-Py3 Compatibility

TEST=\
"""
(set-logic LIA)

(declare-primed-var top.usr.inc@0 Bool)
(declare-primed-var top.usr.rst_c1@0 Bool)
(declare-primed-var top.usr.rst@0 Bool)
(declare-primed-var top.usr.o1@0 Bool)
(declare-primed-var top.usr.o2@0 Bool)
(declare-primed-var top.usr.ok@0 Bool)
(declare-primed-var top.res.init_flag@0 Bool)
(declare-primed-var top.impl.usr.c1@0 Int)
(declare-primed-var top.impl.usr.c2@0 Int)

(synth-inv str_invariant(
  (top.usr.inc@0 Bool)
  (top.usr.rst_c1@0 Bool)
  (top.usr.rst@0 Bool)
  (top.usr.o1@0 Bool)
  (top.usr.o2@0 Bool)
  (top.usr.ok@0 Bool)
  (top.res.init_flag@0 Bool)
  (top.impl.usr.c1@0 Int)
  (top.impl.usr.c2@0 Int) 
))

(define-fun
  init (
    (top.usr.inc@0 Bool)
    (top.usr.rst_c1@0 Bool)
    (top.usr.rst@0 Bool)
    (top.usr.o1@0 Bool)
    (top.usr.o2@0 Bool)
    (top.usr.ok@0 Bool)
    (top.res.init_flag@0 Bool)
    (top.impl.usr.c1@0 Int)
    (top.impl.usr.c2@0 Int)
  ) Bool
  
  (let
   ((X1 0))
   (let
    ((X2 0))
    (and
     (=
      top.impl.usr.c2@0
      (ite top.usr.rst@0 0 (ite (and top.usr.inc@0 (< X1 6)) (+ X1 1) X1)))
     (=
      top.impl.usr.c1@0
      (ite
       (or top.usr.rst_c1@0 top.usr.rst@0)
       0
       (ite (and top.usr.inc@0 (< X2 10)) (+ X2 1) X2)))
     (= top.usr.o2@0 (= top.impl.usr.c2@0 6))
     (= top.usr.o1@0 (= top.impl.usr.c1@0 10))
     (= top.usr.ok@0 (=> top.usr.o1@0 top.usr.o2@0))
     top.res.init_flag@0)))
)


(define-fun
  prop (
    (top.usr.inc@0 Bool)
    (top.usr.rst_c1@0 Bool)
    (top.usr.rst@0 Bool)
    (top.usr.o1@0 Bool)
    (top.usr.o2@0 Bool)
    (top.usr.ok@0 Bool)
    (top.res.init_flag@0 Bool)
    (top.impl.usr.c1@0 Int)
    (top.impl.usr.c2@0 Int)
  ) Bool
  
  top.usr.ok@0
)

(inv-constraint str_invariant init trans prop)

(check-synth)

"""

class Spacer(object):
    def __init__(self, args, ctx, fp):
        self.log = LoggingManager.get_logger(__name__)
        self.args = args
        self.fp = fp
        return

    
    def setSolver(self):
        """Set the configuration for the solver"""
        self.fp.set (engine='spacer')
        if self.args.stat:
            self.fp.set('print_statistics',True)
        if self.args.spacer_verbose:
             z3.set_option (verbose=1)
        self.fp.set('use_heavy_mev',True)
        self.fp.set('pdr.flexible_trace',True)
        self.fp.set('reset_obligation_queue',False)
        self.fp.set('spacer.elim_aux',False)
        if self.args.eldarica: self.fp.set('print_fixedpoint_extensions', False)
        if self.args.utvpi: self.fp.set('pdr.utvpi', False)
        if self.args.tosmt:
            self.log.info("Setting low level printing")
            self.fp.set ('print.low_level_smt2',True)
        if not self.args.pp:
            self.log.info("No pre-processing")
            self.fp.set ('xform.slice', False)
            self.fp.set ('xform.inline_linear',False)
            self.fp.set ('xform.inline_eager',False)
        return


    def parse(self):
        """ Parse Sygus file """
        fi = self.args.file
        self.log.info("Parsing ... " + str(fi))
        sygus = ""
        with utils.stats.timer('Parsing'):
            with open(fi, "r") as infile:
                sygus = infile.read()
            parser = SygSpacerParser()
            script = parser.get_script(sygus)
            for cmd in script:
                print(cmd.name)
            print("*"*50)

            
    def solve(self):
        self.parse()
        return
        




