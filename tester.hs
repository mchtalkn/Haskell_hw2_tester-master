import Data.Char
import Data.List.Split
import Data.List
import HW2
import Expression
import Parser

tester' ::([(String,ExprV)],ExprV)->([(String,ExprV)],ExprV)->Bool
tester' ([],_) ([],_) =True
tester' ([],_) _ =False
tester' _ ([],_) =False
tester' ((x:y),a) ((z:t),b)= if tester_eq (snd x) (snd z) then tester'  (y,a) (t,b) else False


tester_eq ::ExprV->ExprV -> Bool
tester_eq  (Leaf (Variable v)) (Leaf (Variable u)) = True
tester_eq (Leaf (Constant a)) (Leaf (Constant b)) = (a==b)
tester_eq (UnaryOperation Minus p) (UnaryOperation Minus j)  = (tester_eq p j)
tester_eq (BinaryOperation Plus p k) (BinaryOperation Plus j t) = (tester_eq p  j)&& (tester_eq k t)
tester_eq (BinaryOperation Times p k) (BinaryOperation Times j t) = (tester_eq p j)&& (tester_eq k t)
tester_eq _ _ =False
