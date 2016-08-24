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
    



# parser = SygSpacerParser()

# script = parser.get_script(cStringIO(SYGUS))


# for cmd in script:
#     print(cmd.name)
# print("*"*50)


