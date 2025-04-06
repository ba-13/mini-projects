removeNonUpperCaseCharacters :: String -> String
removeNonUpperCaseCharacters st = [ch | ch <- st, ch `elem` ['A' .. 'Z']]

-- in type declarations, there's no differentiation of arguments and return
-- just return type is the last one
addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

-- Functions are expressions too, so checking type of them with :t works as well
-- The type declaration does matter in cases like below
factorialWrongType :: Int -> Int
factorialWrongType n = product [1 .. n]

factorial' :: Integer -> Integer
factorial' n = product [1 .. n]

{-
Type variables
-}
getFirstTwoHead :: [a] -> [a]
getFirstTwoHead list = [head list, head (tail list)]

-- All special character functions are considered infix by default
-- if called as prefix or to be passed as a variable, surround by parenthesis

{-
Type classes
types belong to some type classes/ interfaces that provide them functionality
-}
-- Eq: equality testing: ==, !=
-- Ord: ordering: <, >, <=, >=, compare
comparision = 5 `compare` 3

-- Show: stringify: show
stringified5 = show 5

-- Read: destringify: read
val = read stringified5 :: Float

-- Enum: can be enumerated and used in list ranges: succ, pred
-- Types here are (), Bool, Char, Ordering, Int, Integer, Float, Double
orderingRange = [LT .. GT]

-- Bounded: have upper and lower bound: maxBound, minBound
integerUpperBound = maxBound :: Int

-- Num: types that act like numbers
-- Types here are Int, Integer, Float, Double

{-
declarations can use type classes to specify the type constraints
we want to impose on a variabe argument
example
```
ghci> :t (*)
(*) :: Num a => a -> a -> a
```
means * can accept any a of typeclass Num
and => seperates constraints with the actual declaration
-}

-- Integral: types that act like whole numbers
-- Floating: types that have decimal values

-- usage
randomlist = [1, 2, 3, 4]

-- if we want to add some float to this length it doesnt work, try uncommenting below
-- lengthOfListWithOffset = length randomlist + 3.2
lengthOfListWithOffset = fromIntegral (length randomlist) + 3.2
