from six.moves import cStringIO # Py2-Py3 Compatibility

from pysmt.smtlib.parser import SmtLibParser
from pysmt.smtlib.script import SmtLibCommand


class SygSpacerParser(SmtLibParser):
    def __init__(self, env=None, interactive=False):
        SmtLibParser.__init__(self, env, interactive)
        
        self.commands['declare-primed-var'] = self._cmd_declare_primed_var
        self.commands['synth-inv'] = self._cmd_synth_inv
        self.commands['check-synth'] = self._cmd_check_synth
        self.commands['inv-constraint'] = self._cmd_inv_constraint

    def parse_inv_params(self, tokens, command):
        """Parses a list of names and type from the tokens"""
        current = tokens
        res = []
        while current != ")":
            t = next(current)
            if t == "(" or t == ")":
                return res
            res.append(t)
            current = tokens
        return res
        
    def _cmd_inv_constraint(self, current, tokens):
        """(inv-constraint <term>)"""
        elements = self.parse_inv_params(tokens, current)
        return SmtLibCommand(current, elements)

    def _cmd_declare_primed_var(self, current, tokens):
        """(declare-primed-const <symbol> <sort>)"""
        elements = self.parse_atoms(tokens, current, 2)
        (var, typename) = elements
        v = self._get_var(var, typename)
        self.cache.bind(var, v)
        return SmtLibCommand(current, [v])

    def _cmd_check_synth(self, current, tokens):
        """(check-synth)"""
        self.parse_atoms(tokens, current, 0)
        return SmtLibCommand(current, [])

    def _cmd_synth_inv(self, current, tokens):
        """(synth-inv <fun_def>)"""
        formal = []
        var = self.parse_atom(tokens, current)
        namedparams = self.parse_named_params(tokens, current)
    
        for (x,t) in namedparams:
            v = self._get_var(x, t)
            self.cache.bind(x, v)
            formal.append(v)
        
        # Discard parameters
        for x in formal:
            self.cache.unbind(x.symbol_name())      
        # Finish Parsing
        self.consume_closing(tokens, current)
        return SmtLibCommand(current, [var, formal])
    




TEST = """

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
"""

# parser = SygSpacerParser()

# script = parser.get_script(cStringIO(TEST))

# from pysmt.shortcuts import ForAll, Function, Implies, Symbol
# from pysmt.typing import FunctionType, BOOL, INT, REAL

# inv_name = None
# for cmd in script:
#     if cmd.name == 'synth-inv':
#         inv_name = cmd.args[0]
    
# import cStringIO
# from pysmt.smtlib.printers import SmtPrinter
# buf_out = cStringIO.StringIO()

# p = SmtPrinter(buf_out)

# for cmd in script:    
#     if cmd.name == 'define-fun':
#         p.printer(cmd.args[3])
#         print(buf_out.getvalue())
        # typ = [c.symbol_type() for c in cmd.args[1]]
        # func_type = FunctionType(BOOL, typ)
        # inv_name = Symbol('inv', func_type)
        # inv = Function(inv_name, cmd.args[1])
        # implies = Implies(cmd.args[3], inv)
        # forall = ForAll(cmd.args[1], implies)
        # print forall.serialize()

  
        




