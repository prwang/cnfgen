#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""Implementation of subset cardinality formulas

Copyright (C) 2012, 2013, 2014, 2015  Massimo Lauria <lauria@kth.se>
https://github.com/MassimoLauria/cnfgen.git
"""

from cnfformula.cnf import CNF
from cnfformula.cnf import loose_majority_constraint,loose_minority_constraint

from cnfformula.cmdline import BipartiteGraphHelper

import cnfformula.families
import cnfformula.cmdline

@cnfformula.families.register_cnf_generator
def SubsetCardinalityFormula(B):
    r"""SubsetCardinalityFormula

    Consider a bipartite graph :math:`B`. The CNF claims that at least half
    of the edges incident to each of the vertices on left side of :math:`B`
    must be zero, while at least half of the edges incident to each
    vertex on the left side must be one.

    Variants of these formula on specific families of bipartite graphs
    have been studied in [1]_, [2]_ and [3]_, and turned out to be
    difficult for resolution based SAT-solvers.

    Each variable of the formula is denoted as :math:`x_{i,j}` where
    :math:`\{i,j\}` is an edge of the bipartite graph. The clauses of
    the CNF encode the following constraints on the edge variables.

    For every left vertex i with neighborhood :math:`\Gamma(i)`

    .. math::
         
         \sum_{j \in \Gamma(i)} x_{i,j} \leq \frac{|\Gamma(i)|}{2}

    For every right vertex j with neighborhood :math:`\Gamma(j)`

    .. math::
         
         \sum_{i \in \Gamma(j)} x_{i,j} \geq \frac{|\Gamma(i)|}{2}.

    Parameters
    ----------
    B : networkx.Graph
        the graph vertices must have the 'bipartite' attribute
        set. Left vertices must have it set to 0 and the right ones to 1.
        Any vertex without the attribute is ignored.

    Returns
    -------
    A CNF object

    References
    ----------
    .. [1] Mladen Miksa and Jakob Nordstrom
           Long proofs of (seemingly) simple formulas
           Theory and Applications of Satisfiability Testing--SAT 2014 (2014)
    .. [2] Ivor Spence
           sgen1: A generator of small but difficult satisfiability benchmarks
           Journal of Experimental Algorithmics (2010)
    .. [3] Allen Van Gelder and Ivor Spence
           Zero-One Designs Produce Small Hard SAT Instances
           Theory and Applications of Satisfiability Testing--SAT 2010(2010)

    """
    Left  =  [v for v in B.nodes() if B.node[v]["bipartite"]==0]
    Right =  [v for v in B.nodes() if B.node[v]["bipartite"]==1]
            
    ssc=CNF()
    ssc.header="Subset cardinality formula for graph {0}\n".format(B.name)

    def var_name(u,v):
        """Compute the variable names."""
        if u<=v:
            return 'x_{{{0},{1}}}'.format(u,v)
        else:
            return 'x_{{{0},{1}}}'.format(v,u)

    for u in Left:
        for e in B.edges(u):
            ssc.add_variable(var_name(*e))
        
    for u in Left:
        edge_vars = [ var_name(*e) for e in B.edges(u) ]
        for cls in loose_minority_constraint(edge_vars):
            ssc.add_clause(cls,strict=True)

    for v in Right:
        edge_vars = [ var_name(*e) for e in B.edges(v) ]
        for cls in loose_majority_constraint(edge_vars):
            ssc.add_clause(cls,strict=True)
    
    return ssc




@cnfformula.cmdline.register_cnfgen_subcommand
class SCCmdHelper(object):
    name='subsetcard'
    description='subset cardinality formulas'

    @staticmethod
    def setup_command_line(parser):
        BipartiteGraphHelper.setup_command_line(parser)

    @staticmethod
    def build_cnf(args):
        B = BipartiteGraphHelper.obtain_graph(args)
        return SubsetCardinalityFormula(B)
