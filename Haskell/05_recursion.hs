-- In Haskell, we do computations by declaring what something is (declarative)
-- many times recursive definitions are used for that
maximumOfList :: (Ord a) => a -> [a] -> a
maximumOfList initValue list = case list of
  [x] -> max x initValue
  x : xs -> maximumOfList (max x initValue) xs

-- the following is a trailing edge recursion
-- top down
maximumOfListButBetter :: (Ord a) => [a] -> a
maximumOfListButBetter [] = error "empty list"
maximumOfListButBetter [x] = x
maximumOfListButBetter (x : xs)
  | x > maxTail = x
  | otherwise = maxTail
  where
    maxTail = maximumOfListButBetter xs

replicate' :: (Integral n) => n -> a -> [a]
replicate' count val
  | count < 0 = error "Cant copy negative times"
  | count == 0 = []
replicate' count val = val : replicate' (count - 1) val

take' :: (Integral n) => n -> [a] -> [a]
take' count ls
  | count <= 0 = []
  | null ls = []
take' count (x : xs) = x : take' (count - 1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' ls = last ls : reverse' (init ls)

repeat' :: a -> [a]
repeat' x = x : repeat' x

replicate'' :: (Integral n) => n -> a -> [a]
replicate'' count val = take' count (repeat' val)

zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x : xs) (y : ys) = (x, y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' query [] = False
elem' query (x : xs)
  | query == x = True
  | otherwise = elem' query xs

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort [x] = [x]
-- quicksort (x : xs) =
--   let smallerSorted = quicksort [a | a <- xs, a <= x]
--       biggerSorted = quicksort [a | a <- xs, a > x]
--    in smallerSorted ++ [x] ++ biggerSorted

quicksort (x : xs) = smallerSorted ++ [x] ++ biggerSorted
  where
    smallerSorted = quicksort [a | a <- xs, a <= x]
    biggerSorted = quicksort [a | a <- xs, a > x]
