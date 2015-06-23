-- | Type and functions for predicates: the atoms of first-order logic.
module Manticore.Predicate where

import Manticore.Text
import Manticore.Term

-- | Predicates are atoms (thus they evaluate to true/false) mapping a list
-- of terms (objects) to a truth value.
data Predicate t =
  -- | Builds a predicate with a string and a list of terms.
  Predicate String [Term t]

instance (Eq t) => Eq (Predicate t) where
  (Predicate n0 ts0) == (Predicate n1 ts1) =
    n0 == n1 && all (uncurry (==)) (zip ts0 ts1)

instance (Ord t) => Ord (Predicate t) where
  (Predicate n0 ts0) `compare` (Predicate n1 ts1) = compareFun n0 ts0 n1 ts1

instance (Show t) => Show (Predicate t) where
  show = rmQuotes . showPredicate
    where
      showPredicate (Predicate n ts) =
        n ++ "(" ++ (if null ts then "" else terms) ++ ")"
        where terms = mkString $ map show ts

-- | Shows the internal structure of the predicate.
showPredStruct :: (Show a) => Predicate a -> String
showPredStruct (Predicate n ts) =
  "Predicate " ++ n ++ " [" ++ (if null ts then "" else terms) ++ "]"
  where terms = mkString (map showTermStruct ts)

-- 'ground' typeclass?

-- | Tests if the term is 'grounded', i.e. if it has no variables.
groundPred :: Predicate t -> Bool
groundPred (Predicate _ ts) = all groundTerm ts