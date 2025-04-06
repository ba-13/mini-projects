import Text.Read

{-
Pattern Matching
order of specifying patterns is important
always have catch-all pattern so program doesn't crash

this leads to matching a value to a constructer, and binding new variables
essentially binding values to names
-}

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER!"
lucky x = "Sorry you're out of luck, pal!" -- patterns checked top to bottom

recursiveFactorialWithPatternMatch :: (Integral a) => a -> a
recursiveFactorialWithPatternMatch 0 = 1
recursiveFactorialWithPatternMatch n = n * recursiveFactorialWithPatternMatch (n - 1)

-- how to ensure that n negative isn't passed?

second :: (a, b, c) -> b
second (_, y, _) = y

secondInList :: [a] -> a
secondInList [] = error "Doesn't have any element dummy!"
secondInList [x] = error "Doesn't have second element dummy!"
secondInList (x : y : xs) = y

lengthOfList :: (Num b) => [a] -> b
lengthOfList [] = 0
lengthOfList (_ : xs) = 1 + lengthOfList xs

sumOfList :: (Num a) => [a] -> a
sumOfList [] = 0
sumOfList (x : xs) = x + sumOfList xs

-- to keep a reference to the whole object when destructuring
pointOutFirstLetter :: String -> String
pointOutFirstLetter "" = "Empty String!"
pointOutFirstLetter whole@(x : xs) = "The first character of '" ++ whole ++ "' is " ++ [x]

{-
Guards
evaluate arbitrary booleans using arguments
where clause to rename variables, local to that function body
doesn't carry over to a different pattern match of the same function
-}

densityTell :: (RealFloat a) => a -> a -> String
densityTell mass volume
  | density < air = "dis floats"
  | density <= water = "dis stais betwin"
  | otherwise = "shuck sinks"
  where
    density = mass / volume
    air = 1.2
    water = 1000.0

factorialSafe :: (Integral a) => a -> a
factorialSafe 0 = 1
factorialSafe n
  | n > 0 = n * factorialSafe (n - 1)
  | otherwise = error "Passed less than 0"

myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
  | a > b = GT
  | a == b = EQ
  | otherwise = LT

-- Pattern Guards to match result
-- didn't understand this one, as this doesn't compile as well
-- density :: String -> String
-- density input
--   | Just density <- readMaybe input, density < 1.2 = "Wow! You're going for a ride in the sky!"
--   | Just density <- readMaybe input, density <= 1000.0 = "Have fun swimming, but watch out for sharks!"
--   | Nothing <- readMaybe input :: ((RealFloat a) => Maybe a) = "You know I need a density, right?"
--   | otherwise = "If it's sink or swim, you're going to sink."

-- \| otherwise = [f] ++ ". " ++ [l] ++ "."
initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
  where
    (f : _) = firstname
    (l : _) = lastname

oneWaytoGetDensity :: (RealFloat a) => [(a, a)] -> [a]
oneWaytoGetDensity xs = [density m v | (m, v) <- xs]
  where
    density mass volume = mass / volume -- can define local functions

anotherWaytoGetDensity :: (RealFloat a) => [(a, a)] -> [a]
anotherWaytoGetDensity xs = [density | (m, v) <- xs, let density = m / v]

filteredDensity :: (RealFloat a) => [(a, a)] -> [a]
filteredDensity xs =
  [ density
    | (m, v) <- xs, -- this is a predicate, and not a guard
      let density = m / v; air = 1.2,
      density < air
  ]

{-
let <binding> in <expression>
can be used to create local variables, functions for the expression after in
can be used paired with pattern matching to extract out data
-}
squares = let square x = x * x in [square 4, square 3, square 19]

randomValue =
  let someData = (1, 42, 100913)
   in (let (a, b, c) = someData in a ^ b + c) * 100

{-
Case expressions

alternative of doing pattern matching on parameters of function definitions
-}

-- Indentation matters in Haskell!
secondInList' :: [a] -> a
secondInList' x = case x of
  [] -> error "Doesn't have any element dummy!"
  [x] -> error "Doesn't have second element dummy!"
  (x : y : xs) -> y

-- observe why this warns you
-- because case is used to destructure data constructors
-- but a function's match is that function itself!
-- the pattern match works on data constructors while these are function values
calculator :: (Num a) => a -> (a -> a -> a) -> a -> a
calculator x fun y = case fun of
  (+) -> x * y
  (-) -> x + y
  (*) -> x - y

data Operation = Add | Subtract | Multiply

calculatorWithoutWarn :: (Num a) => a -> Operation -> a -> a
calculatorWithoutWarn x op y = case op of
  Add -> x + y
  Subtract -> x - y
  Multiply -> x * y