{-# LANGUAGE GADTs #-}
module Game.NovelMonad
  ( Choices(..)
  , YesNo(..)
  , Sex(..)
  , Actor(..)
  , NovelBase(..)
  , Novel
  , talk
  , trunOverThePage
  , selectChoices
  ) where
import Control.Monad.Operational.Simple

-- choices

class (Enum a, Bounded a) => Choices a where
  showItem :: a -> String

data YesNo = Yes | No deriving (Show, Read, Eq, Ord, Enum, Bounded)
instance Choices YesNo where
  showItem = show

-- actor infomation

data Sex = Boy | Girl | Unknown deriving (Show, Read, Eq, Ord)
data Actor = Narrator | Actor 
  { actorName :: String
  , actorSex :: Sex
  } deriving (Show, Read, Eq, Ord)

-- novel monad

data NovelBase x where
  Talk :: Actor -> String -> NovelBase ()
  TurnOverThePage :: NovelBase ()
  SelectChoices :: Choices a => Novel () -> NovelBase a
  GetStrLn :: Novel () -> NovelBase String

type Novel = Program NovelBase

-- actions

talk :: Actor -> String -> Novel ()
talk act = singleton . Talk act

trunOverThePage :: Novel ()
trunOverThePage = singleton TurnOverThePage 

selectChoices :: Choices a => Novel () -> Novel a
selectChoices question = singleton $ SelectChoices question

getStrLn :: Novel () -> Novel String
getStrLn question = singleton $ GetStrLn question
