-- functions that deal with functions as arguments or return types
-- indispenable in declarative programming

divideByTen :: (Floating a) => a -> a
divideByTen = (/ 10)

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

val = applyTwice (+ 3) 10 -- here `+ 3` is a curried + function

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ _ [] = []
zipWith' _ [] _ = []
zipWith' f (x : xs) (y : ys) = f x y : zipWith' f xs ys

-- flip' :: (a -> b -> c) -> (b -> a -> c)
-- flip' f = g
--   where
--     g x y = f y x

flip' :: (a -> b -> c) -> b -> a -> c
flip' f x y = f y x

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x : xs) = f x : map' f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x : xs)
  | f x = x : filter' f xs
  | otherwise = filter' f xs

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort [x] = [x]
quicksort (x : xs) = smallerSorted ++ [x] ++ biggerSorted
  where
    smallerSorted = quicksort (filter (<= x) xs)
    biggerSorted = quicksort (filter (> x) xs)

filterTillYouGetIt :: (a -> Bool) -> [a] -> Maybe a
filterTillYouGetIt _ [] = Nothing
filterTillYouGetIt f (x : xs)
  | f x = Just x
  | otherwise = filterTillYouGetIt f xs

divisibleBy3829 :: (Integral a) => a -> Bool
divisibleBy3829 x = x `mod` 3829 == 0

val2 = filterTillYouGetIt divisibleBy3829 [100000, 99999 .. 1]

-- val3 = sum (takeWhile (< 10000) (filter odd (map (^ 2) [1 ..])))
val3 :: Integer = sum (takeWhile (< 10000) [x * x | x <- [1, 3 ..]])

-- Collatz sequence
collatz :: (Integral a) => a -> [a]
collatz 1 = [1] -- as 1, 4, 2 is the subsequent cycle
collatz x
  | even x = x : collatz (x `div` 2)
  | odd x = x : collatz (3 * x + 1)

-- get the numbers in 1..100 that have Collatz sequence larger than 15
val4 = map getSecondElement (filter isLongEnough (zip (map collatz [1 .. 100]) [1 .. 100]))
  where
    isLongEnough (x, val) = length x > 15
    getSecondElement (x, y) = y

-- Fold is accumulation of a list
-- doesn't need to just accumulate to one value
foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' f acc [] = acc
foldl' f acc (x : xs) = foldl' f (f acc x) xs

multiplyBy2 :: (Num a) => [a] -> [a]
multiplyBy2 = foldl (\acc x -> acc ++ [x * 2]) []

sum' :: (Num a) => [a] -> a
-- sum' xs = foldl (\acc x -> acc + x) 0 xs
-- sum' = foldl (\acc x -> acc + x) 0
sum' = foldl (+) 0

elem' :: (Eq a) => a -> [a] -> Bool
elem' y = foldl (\acc x -> x == y || acc) False

-- foldr has benefit of not reversing the list when using :
-- that's why we use it for list generation
map'' :: (a -> b) -> [a] -> [b]
map'' f = foldr (\x acc -> f x : acc) []

-- foldl1 and foldr1 takes the first element of the list
-- to be the starting value, therefore requires at least one element
maximum' :: (Ord a) => [a] -> a
maximum' = foldl1 (\acc x -> if x > acc then x else acc) -- no init value needed

-- scanl and scanr also return intermediate values
scanl' :: (a -> b -> a) -> a -> [b] -> [a]
scanl' f acc [] = [acc]
scanl' f acc (x : xs) = acc : scanl' f val xs
  where
    val = f acc x

-- how many natural numbers it takes to have their sum of sqrt to exceed 1000
val5 = length (takeWhile (< 1000) (scanl1 (+) (map sqrt [1 ..]))) + 1

-- function application with lowest precedence
bracketsReplacedByDollar = sum (map sqrt [1 .. 130]) == (sum $ map sqrt [1 .. 130])

-- also function application on a parameter, itself as a function!
mapping = map ($ 2) [(4 +), (10 *), sqrt]

-- we can do function composition as well
negateAbsolute :: (Num a) => [a] -> [a]
negateAbsolute = map (negate . abs)

-- chaining using curried functions
-- val6 = sum (replicate 4 (max 6.7 8.9))
val6 = sum . replicate 4 . max 6.7 $ 8.9

-- because of currying, we can write pure functions, only using functions!
-- eliminating to thing wrt data
fn :: (Floating a, RealFrac a, Integral b) => a -> b
fn = ceiling . negate . tan . cos . max 50

oddSquareSum :: Integer
-- oddSquareSum = (sum . takeWhile (<10000) . filter odd . map (^2)) [1..]
oddSquareSum =
  let oddSquares = filter odd $ map (^ 2) [1 ..]
      belowLimit = takeWhile (< 10000) oddSquares
   in sum belowLimit