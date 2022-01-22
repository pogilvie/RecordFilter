
# format of input
# representation of result
# the parsing algorrithm
# evaluation of the expression


-(x + 5) * -2
IDs (variable)
Numbers
infix (binary) operators
prefix (unitary) operators
()

E -> T + E
E -> T - E
E -> T
T -> F * T
T -> F / T
T -> F
F -> ID
F -> Integer
F -> ( E )
F -> -F

E -> T + E | T - E | T
T -> F * E | F / E | F
F -> ID | Integer | ( E ) | -F




E -> T { AND | OR T }
T -> "true" | "false" | "(" E ")" 


Given
(true AND false) OR false