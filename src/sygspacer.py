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
  trans (
    
    ;; Current state.
    (top.usr.inc@0 Bool)
    (top.usr.rst_c1@0 Bool)
    (top.usr.rst@0 Bool)
    (top.usr.o1@0 Bool)
    (top.usr.o2@0 Bool)
    (top.usr.ok@0 Bool)
    (top.res.init_flag@0 Bool)
    (top.impl.usr.c1@0 Int)
    (top.impl.usr.c2@0 Int)
    
    ;; Next state.
    (top.usr.inc@1 Bool)
    (top.usr.rst_c1@1 Bool)
    (top.usr.rst@1 Bool)
    (top.usr.o1@1 Bool)
    (top.usr.o2@1 Bool)
    (top.usr.ok@1 Bool)
    (top.res.init_flag@1 Bool)
    (top.impl.usr.c1@1 Int)
    (top.impl.usr.c2@1 Int)
  
  ) Bool
  
  (let
   ((X1 top.impl.usr.c2@0))
   (let
    ((X2 top.impl.usr.c1@0))
    (and
     (=
      top.impl.usr.c2@1
      (ite top.usr.rst@1 0 (ite (and top.usr.inc@1 (< X1 6)) (+ X1 1) X1)))
     (=
      top.impl.usr.c1@1
      (ite
       (or top.usr.rst_c1@1 top.usr.rst@1)
       0
       (ite (and top.usr.inc@1 (< X2 10)) (+ X2 1) X2)))
     (= top.usr.o2@1 (= top.impl.usr.c2@1 6))
     (= top.usr.o1@1 (= top.impl.usr.c1@1 10))
     (= top.usr.ok@1 (=> top.usr.o1@1 top.usr.o2@1))
     (not top.res.init_flag@1))))
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
        self.decl_primed_var = dict()
        self.define_fun = dict()
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
        sy_decl_primed_var = []
        sy_define_fun = []
        with utils.stats.timer('Parsing'):
            with open(fi, "r") as infile:
                sygus = infile.read()
            parser = SygSpacerParser()
            script = parser.get_script(TEST)
            for cmd in script:
                if cmd.name == 'declare-primed-var':
                    sy_decl_primed_var.append(cmd)
                elif cmd.name == 'define-fun':
                    sy_define_fun.append(cmd)
            

        for cmd in sy_decl_primed_var:
            for l in cmd.args:
                self.decl_primed_var.update({l.symbol_name(): l.symbol_type()})
        
        for cmd in sy_define_fun:
            fun_name = cmd.args[0]
            fun_vars = cmd.args[1]
            self.define_fun.update({fun_name:fun_vars})
            formulas = cmd.args[3]
        return
            
                
        


    def declare_vars(self):
        self.log.info("Declare variables ... ")
        z3vars = []
        for v, typ in self.decl_primed_var.iteritems():
            if typ.is_bool_type():
                z3vars.append(z3.Bool(v))
            elif typ.is_int_type():
                z3vars.append(z3.Int(v))
            elif typ.is_real_type():
                z3vars.append(z3.Real(v))
            else:
                assert false, 'Unsupported type: %s' % str(typ)
        self.fp.declare_var(z3vars)


    def define_relations(self):
        self.log.info("Define relations ... ")
        for fun_name, vars in self.define_fun.iteritems():
            z3vars = []
            z3Type =  []
            for v in vars:
                var_name = v.symbol_name()
                var_type = v.symbol_type()
                if var_type.is_bool_type():
                    z3vars.append(z3.Bool(var_name))
                    z3Type.append(z3.BoolSort())
                elif var_type.is_int_type():
                    z3vars.append(z3.Int(var_name))
                    z3Type.append(z3.IntSort())
                elif var_type.is_real_type():
                    z3vars.append(z3.Real(var_name))
                    z3Type.append(z3.RealSort())
                else:
                    assert false, 'Unsupported type: %s' % str(typ)
            self.fp.declare_var(z3vars)
            fun = z3.Function(fun_name, z3Type)
            self.fp.register_relation(fun)
            

        
        
            
    def solve(self):
        self.parse()
        self.declare_vars()
        self.define_relations()
        return
        




