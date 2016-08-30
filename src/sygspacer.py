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
import cStringIO # Py2-Py3 Compatibility
import utils
from pysmt.environment import get_env
from pysmt.smtlib.printers import SmtPrinter
import subprocess as sub
import test

class Spacer(object):
    def __init__(self, args, ctx, fp):
        self.log = LoggingManager.get_logger(__name__)
        self.args = args
        self.fp = fp
        self.decl_primed_var = list()
        self.define_fun = dict()
        self.all = dict()
        self.synth_inv = dict() # invariants to be synthesized
        self.allVars = dict()
        if not self.args.verbose: LoggingManager.disable_logger()
        return


    def isexec (self, fpath):
        """ check if program is executable"""
        if fpath == None: return False
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)


    def which(self,program):
        """ check locaton of a program"""
        fpath, fname = os.path.split(program)
        if fpath:
            if isexec (program):
                return program
        else:
            for path in os.environ["PATH"].split(os.pathsep):
                exe_file = os.path.join(path, program)
                if isexec (exe_file):
                    return exe_file
        return None

    def getSpacer(self):
        """ Get the binary location for Spacer"""
        spacer = None
        if not self.isexec (spacer):
            root = os.path.dirname(os.path.realpath(__file__))
            bin = os.path.abspath (os.path.join(root, '..', '..', '..','bin'))
            spacer = os.path.join (bin, "z3")
        if not self.isexec (spacer):
            raise IOError ("Cannot find Spacer")
        return spacer




    def parse(self):
        """ Parse Sygus file """
        fi = self.args.file
        self.log.info("Parsing ... " + str(fi))
        sy_define_fun, sy_synth_inv, sy_inv_const = list(), list(), list()
        parser = SygSpacerParser()

        script = parser.get_script_fname(fi)

        for cmd in script:
            if cmd.name == 'declare-primed-var':
                self.decl_primed_var.append(cmd.args[0])
            elif cmd.name == 'define-fun':
                sy_define_fun.append(cmd)
            elif cmd.name == 'inv-constraint':
                sy_inv_const.append(cmd)
            elif cmd.name == 'synth-inv':
                sy_synth_inv.append(cmd)
            # else:
            #     assert False, 'Unknown commands %s' % cmd.name

        # store all the invariants to be synthesized
        for cmd in sy_synth_inv:
            self.synth_inv.update({cmd.args[0]:cmd.args[1]})

        # store all the define fun
        for cmd in sy_define_fun:
            fun_name = cmd.args[0]
            fun_vars = cmd.args[1]
            self.define_fun.update({fun_name:cmd.args[1:]})

        # build the dictionary for the all parse
        for cmd in sy_inv_const:
            try:
                inv_name = cmd.args[0]
                inv_vars = self.synth_inv[inv_name]
                init = self.define_fun[cmd.args[1]]
                trans = self.define_fun[cmd.args[2]]
                prop = self.define_fun[cmd.args[3]]
                init.append(cmd.args[1])
                trans.append(cmd.args[2])
                prop.append(cmd.args[3])
                self.all.update({inv_name : {'vars': inv_vars, 'init':init, 'trans':trans, 'prop':prop}})
            except Exception as e:
                self.log.error(str(e) + " definition not found")

    def declareVars(self, vars):
        """ Declare Vars"""
        decl_vars = list()
        d_var = "(declare-var %s %s)"
        for v in vars:
            var_type = v.symbol_type()
            var_name = v.symbol_name()
            if var_type.is_bool_type():
                decl_vars.append(d_var % (var_name, 'Bool'))
            elif var_type.is_int_type():
                decl_vars.append(d_var % (var_name, 'Int'))
            elif var_type.is_real_type():
                decl_vars.append(d_var % (var_name, 'Real'))
            else:
                assert false, 'Unsupported type: %s' % str(typ)
        return decl_vars

    def _typString(self, typ):
        z3types = list()
        for t in typ:
            var_type = t.symbol_type()
            if var_type.is_bool_type():
                z3types.append('Bool')
            elif var_type.is_int_type():
                z3types.append('Int')
            elif var_type.is_real_type():
                z3types.append('Real')
            else:
                assert false, 'Unsupported type: %s' % str(typ)
        return z3types


    def mkInit(self, inv, inv_args, init_def):
        init_args = init_def[0]
        init_name = init_def[3]
        # check that the number of inv_args and init_args are the same
        assert inv_args == len(init_args) , 'args(%s) != args(%s)' % (inv, init_name)
        init_body = init_def[2]
        args_str = ' '.join(str(x) for x in init_args)
        buf_out = cStringIO.StringIO()
        p = SmtPrinter(buf_out)
        p.printer(init_body)
        body_str  = buf_out.getvalue()
        rule = "(rule (=> %s  (%s %s)))" % (body_str, inv, args_str)
        return rule

    def mkTrans(self, inv, inv_args, trans_def):
        trans_name = trans_def[3]
        trans_args = trans_def[0]
           # check that the number of inv_args*2 and init_args are the same
        assert (inv_args*2) == len(trans_args) , 'args(%s) != args(%s)' % (inv, trans_name)
        unprimed_args = trans_args[0:inv_args]
        primed_args = trans_args[inv_args:]
        decl_vars = self.declareVars(primed_args)
        self.allVars.update({'primed_var':decl_vars})
        trans_body = trans_def[2]
        primed_str = ' '.join(str(x) for x in primed_args)
        unprimed_str = ' '.join(str(x) for x in unprimed_args)
        inv_primed = "(%s %s)" % (inv, primed_str)
        inv_unprimed = "(%s %s)" % (inv, unprimed_str)
        buf_out = cStringIO.StringIO()
        p = SmtPrinter(buf_out)
        p.printer(trans_body)
        body_str  = buf_out.getvalue()
        rule = "(rule (=> (and %s %s) %s))" % (inv_unprimed, body_str, inv_primed)
        return rule

    def mkProp(self, inv, inv_args, prop_def):
        prop_name = prop_def[3]
        prop_args = prop_def[0]
           # check that the number of inv_args*2 and init_args are the same
        assert (inv_args) == len(prop_args) , 'args(%s) != args(%s)' % (inv, prop_name)
        # (rule (=> (and (str_invariant prop_args) (not prop_body)) ERROR))
        prop_body = prop_def[2]
        arg_str = ' '.join(str(x) for x in prop_args)
        inv_str = "(%s %s)" % (inv, arg_str)
        buf_out = cStringIO.StringIO()
        p = SmtPrinter(buf_out)
        p.printer(prop_body)
        body_str = buf_out.getvalue()
        rule = "(rule (=> (and %s (not %s)) ERROR))" % (inv_str, body_str)
        return rule


    def mkSynthInv(self, inv, vars):
        """ Make a function declaration of invariant to be synthesized """
        z3types_str = self._typString(vars)
        inv_decl = '(declare-rel %s (%s))' % (inv, ' '.join(x for x in z3types_str))
        error_decl = '(declare-rel ERROR () )'
        return {'inv_decl': inv_decl, 'error':error_decl}

    def processInv(self):
        """ Process all the invriants to be synthesized """
        inv_rules = dict()
        for inv, tbp in self.all.iteritems():
            self.log.info('Rules for  ... ' + inv)
            inv_args = tbp['vars']
            inv_dict = self.mkSynthInv(inv, inv_args)
            init_rule = self.mkInit(inv, len(inv_args), tbp['init'])
            trans_rule = self.mkTrans(inv, len(inv_args), tbp['trans'])
            prop_rule = self.mkProp(inv, len(inv_args), tbp['prop'])
            inv_rules.update({inv:{'init_rule':init_rule,
                                   'trans_rule':trans_rule,
                                   'prop_rule':prop_rule,
                                   'inv_decl':inv_dict['inv_decl'],
                                   'error':inv_dict['error']}})
        return inv_rules


    def toHorn(self):
        """ From Sygus format to Horn Clauses """
        self.parse()
        inv_rules = self.processInv()
        decl_vars = self.declareVars(self.decl_primed_var)
        self.allVars.update({'unprimed':decl_vars})
        horn = ""
        for k, vars in self.allVars.iteritems():
            horn +='\n'.join(x for x in vars) + '\n'
        for inv, rule in inv_rules.iteritems():
            horn += rule['inv_decl'] + '\n'
            horn += rule['error'] + '\n'
            horn += '\n; init rule for %s' % inv + '\n'
            horn += rule['init_rule'] + '\n'
            horn += '\n; trans rule for %s' % inv +'\n'
            horn += rule['trans_rule'] +'\n'
            horn += '\n; prop rule for %s' % inv +'\n'
            horn += rule['prop_rule'] + '\n'
        horn += '(query ERROR)'
        horn_file = self.args.file + '.smt2'
        self.log.info("Writing into ... " + horn_file)
        with open(horn_file, "w") as f:
            f.write(horn)
        if self.args.solve:
            if self.args.syg: self.solve(horn_file)
            else: self.runSpacer(horn_file)
        return


    def solve(self, horn_file):
        """ Solve directly """
        self.setSolver()
        with utils.stats.timer ('Parse'):
            q = self.fp.parse_file (horn_file)
        preds = utils.fp_get_preds(self.fp)
        with utils.stats.timer ('Query'):
            res = self.fp.query (q[0])
            if res == z3.sat:
                utils.stat ('Result', 'CEX')
            elif res == z3.unsat:
                utils.stat ('Result', 'SAFE')
                self.printInv(preds)
            else:
                utils.stat ('Result', 'UNK')
        stats.brunch_print()
        return

    def printInv(self, preds):
        """ Get unprocessed invariants """
        self.log.info('Getting Invariants ... ')
        for p in preds:
            if str(p.decl()) != 'ERROR':
                invs = utils.fp_get_cover_delta(self.fp, p)
                print "----------------------------"
                print "Predicate: " + str(p)
                print "Invariants: \n\t" + str(invs)
                print "----------------------------"



    def setSolver(self):
        """Set the configuration for the solver"""
        self.fp.set (engine='spacer')

        self.fp.set('print_statistics',True)
        if self.args.spacer_verbose:
             z3.set_option (verbose=1)
        self.fp.set('use_heavy_mev',True)
        self.fp.set('pdr.flexible_trace',True)
        self.fp.set('reset_obligation_queue',False)
        self.fp.set('spacer.elim_aux',False)
        self.fp.set('print_fixedpoint_extensions', False)
        if self.args.utvpi: self.fp.set('pdr.utvpi', False)
        if not self.args.pp:
            self.log.info("No pre-processing")
            self.fp.set ('xform.slice', False)
            self.fp.set ('xform.inline_linear',False)
            self.fp.set ('xform.inline_eager',False)
        return


    def runSpacer (self, in_name):
        """ Run Spacer """
        stats =  ["fixedpoint.print_statistics=true"] if self.args.stat else []
        utvpi =  ["pdr.utvpi=false"] if self.args.stat else []
        spacer_args = [self.getSpacer (),
                       "fixedpoint.xform.slice=false",
                       "fixedpoint.xform.inline_linear=false",
                       "fixedpoint.xform.inline_eager=false",
                       "fixedpoint.use_heavy_mev=true",
                       "fixedpoint.print_fixedpoint_extensions=false",
	               "fixedpoint.pdr.flexible_trace=true",
	               "fixedpoint.reset_obligation_queue=true",
                       "fixedpoint.print_answer=true",
                       "-v:1",
                       "fixedpoint.engine=spacer"] + stats + utvpi + [in_name]
        if self.args.verbose: print ' '.join (spacer_args)
        utils.stat ('Result', 'UNKNOWN')
        result = None
        try:
            p = sub.Popen (spacer_args, shell=False, stdout=sub.PIPE, stderr=sub.STDOUT)
            result,_ = p.communicate()
            with open(in_name+"_result.txt", "w") as f:
                f.write(result)
        except Exception as e:
            print str(e)
