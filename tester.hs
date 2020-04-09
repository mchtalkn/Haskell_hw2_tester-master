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
tester' ((x:y),a) ((z:t),b)= if  (tester_rename'' (snd x))== (tester_rename'' (snd z)) then tester'  (y,a) (t,b) else False


tester_eq ::ExprV->ExprV -> Bool
tester_eq  (Leaf (Variable v)) (Leaf (Variable u)) = True
tester_eq (Leaf (Constant a)) (Leaf (Constant b)) = (a==b)
tester_eq (UnaryOperation Minus p) (UnaryOperation Minus j)  = (tester_eq p j)
tester_eq (BinaryOperation Plus p k) (BinaryOperation Plus j t) = (tester_eq p  j)&& (tester_eq k t)
tester_eq (BinaryOperation Times p k) (BinaryOperation Times j t) = (tester_eq p j)&& (tester_eq k t)
tester_eq _ _ =False

var_list :: ExprV->[(String)]
var_list (Leaf (Variable a))=[a]
var_list (Leaf _) = []
var_list (UnaryOperation Minus a)=var_list a
var_list (BinaryOperation Plus a b)= (var_list a)++(var_list b)
var_list (BinaryOperation Times a b)=(var_list a)++(var_list b)

tester_rename :: ExprV->String->String->ExprV
tester_rename (Leaf (Variable a)) o n=if(a==o) then (Leaf (Variable n)) else Leaf (Variable o)
tester_rename (Leaf a) _ _ = Leaf a
tester_rename (UnaryOperation Minus a) o n=tester_rename a o n
tester_rename (BinaryOperation Plus a b) o n=BinaryOperation Plus (tester_rename a o n) (tester_rename b o n)
tester_rename (BinaryOperation Times a b) o n=BinaryOperation Times (tester_rename a o n) (tester_rename b o n)

tester_rename' :: ExprV->[String]->Int->ExprV
tester_rename' a [] _ =a
tester_rename' a (x:y) n= tester_rename' (tester_rename a x ("&&"++show n)) y (n+1)

tester_rename'' :: ExprV->ExprV
tester_rename'' a = tester_rename' (a) (var_list a) 0
