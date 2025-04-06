-- Learnyouahaskell
-- infix function denoted by <> `func` <>

-- Load a file in ghci with :l <filename>

doubleMe x = x + x

-- doubleUs x y = x + y + x + y
doubleUs x y = doubleMe x + doubleMe y

doubleSmallNumber x =
  if x > 100
    then x
    else x * 2

doubleSmallNumber' x = (if x > 100 then x else x * 2) + 1

conanO'Brian = "It's a-me, Conan O'Brien!"

-- Functions can't start with capitals
-- Functions can contain '
-- Functions with no parameters are definitions

lostNumbers = [4, 8, 9, 10, 1, 32, 13, 24]

wo = ['w', 'o']

ot = ['o', 't']

woot = wo ++ ot -- putting lists together

cat = 'A' : " SMALL CAT" -- putting element and list together

-- To obtain a particular index of a list
lostNumber3 = lostNumbers !! 3

-- * list functions

-- head, tail, init, last
-- length, null, reverse
-- From start of list: take <numberOfElements>, drop <numberOfElements>
-- maximum, minimum, sum, product, elem <element>

range20 = [1 .. 20]

rangeAZ = ['a' .. 'z']

range20'2 = [2, 4 .. 20]

range21'2 = [2, 4 .. 21] -- not that strict

lazyRange = take 24 [13, 26 ..] -- an infinite list, but since haskell is lazy, it will wait to check what to do of this list and do things accordingly.

-- cycle : cycles the arr to make an infinite list
-- repeat : similar to cycle but for single element.
-- replicate : repeats $1, $2 number of times to arr.

{-
List Comprehensions: similar to set comprehension done in mathematics, syntax like
[<your needed terms>(x) | x <- [original list], constraints]
-}
boomBangs xs = [if x < 10 then "Boom" else "Bang" | x <- xs, odd x]

nouns = ["hobo", "frog", "pope"]

verbs = ["eats", "fights", "jumps"]

-- list comprehension
nounMitVerb = [n ++ " " ++ v | n <- nouns, v <- verbs]

rightTriangles' sideLength perimeter = [(a, b, c) | a <- [1 .. sideLength], b <- [1 .. a], c <- [1 .. b], a * a == b * b + c * c, a + b + c == perimeter]

-- This is a common pattern in functional programming. You take a starting set of solutions and then you apply transformations to those solutions and filter them until you get the right ones.
