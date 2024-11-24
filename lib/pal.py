from logic import *

# Symbols
AKnight = Symbol("A is a knight")
AKnave = Symbol("A is a knave")

# Puzzle 0
# A says "I am both a knight and a knave."
knowledge0 = And(
    Or(AKnight, AKnave),   # A is either a knight or a knave
    Not(And(AKnight, AKnave)),  # A cannot be both a knight and a knave
    Implication(AKnight, And(AKnight, AKnave)),  # If A is a knight, the statement must be true
    Implication(AKnave, Not(And(AKnight, AKnave)))  # If A is a knave, the statement must be false
)

# Model checking for Puzzle 0
print(model_check(knowledge0, AKnight))
print(model_check(knowledge0, AKnave))

