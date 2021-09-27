-- Comments
{- 
MultiLine Comments
 -}

import Data.List
import System.IO

-- Int -2^63 2^63
minInt = minBound::Int

-- Double 11 point precision
bigFloat = 3.9999999999999 + 0.0000000000005

-- Bool True False
-- Char '
-- Tuple

-- Permanent Values
always5 :: Int
always5 = 5;

sumOfNums = sum [1..1000]

modEx = mod 5 4 -- Prefix operator
modEx2 = 15 `mod` 4 -- Infix operator

negNumEx = 5 + (-4) -- Parenthesis is necessary

num9 = 9 :: Int
sqrtOf9 = sqrt (fromIntegral num9)

favNums = 2:7:8:13:[] -- creating lists.
moreFavNums = 69:favNums

revFavNums = reverse moreFavNums
isListEmpty = null moreFavNums
secondPrim