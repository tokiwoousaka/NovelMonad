{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE GADTs #-}
module Game.NovelMonad.SimpleInterpreter 
  ( SIConfig(..)
  , Color(..)
  , defaultConfig
  , simpleInterpret
  ) where
import Control.Monad.Operational.Simple
import Control.Concurrent
import Control.Monad
import Game.NovelMonad
import Text.Read

-- fore color

data Color = Red | Blue deriving (Show, Read, Eq)

sex2Color :: SIConfig -> Sex -> Color
sex2Color conf Girl = siGirlsColor conf
sex2Color conf Boy = siBoysColor conf

-- config

data SIConfig = SIConfig 
  { siDelayiMilliSec :: Int
  , siGirlsColor :: Color
  , siBoysColor :: Color
  } deriving (Show, Read, Eq)

defaultConfig :: SIConfig  
defaultConfig = SIConfig  
  { siDelayiMilliSec = 500
  , siGirlsColor = Red
  , siBoysColor = Blue
  }


-- interpret

simpleInterpret :: SIConfig -> Novel a -> IO a
simpleInterpret conf novel = putStr "\x1b[2J\x1b[0;0H" >> runNovel conf novel

runNovel :: SIConfig -> Novel a -> IO a
runNovel conf novel = interpret advent novel
  where
    advent :: NovelBase x -> IO x
    advent (Talk actor serif) = runTalk conf actor serif >> threadDelay (siDelayiMilliSec conf * 1000)
    advent TurnOverThePage = putStrLn "▼" >> getLine >> putStr "\x1b[2J\x1b[0;0H"
    advent (SelectChoices question) = getChoices conf question
    advent (GetStrLn question) = runNovel conf question >> getLine

runTalk :: SIConfig -> Actor -> String -> IO ()
runTalk conf Narrator serif = putStrLn serif
runTalk conf (Actor name sex) serif = putStrLn . colorling (sex2Color conf sex) $ name ++ "「" ++ serif

colorling :: Color -> String -> String
colorling Blue str = "\x1b[34m" ++ str ++ "\x1b[m"
colorling Red str = "\x1b[31m" ++ str ++ "\x1b[m"

-- select choices

getChoices :: forall a. Choices a => SIConfig -> Novel () -> IO a
getChoices conf question = do
  tlist <- return $ zip [0..] ([minBound..maxBound] :: [a])
  -- show
  runNovel conf question
  putStrLn "----------"
  forM_ tlist $ \(i, val) -> putStrLn (show i ++ " - " ++ showItem val)
  putStrLn "----------"
  -- get
  (choice :: Maybe a) <- getChoice
  putStr "\x1b[2J\x1b[0;0H"
  case choice of
    Just x -> return x
    Nothing -> getChoices conf question

getChoice :: forall a. Choices a => IO (Maybe a)
getChoice = do
  (idx :: Maybe Int) <- return . readMaybe =<< getLine
  return $ idx >>= safeToEnum 

-- helper

safeToEnum :: forall a. Choices a => Int -> Maybe a
safeToEnum idx = do
  max <- return $ fromEnum (maxBound :: a)
  if 0 <= idx && idx <= max
    then Just $ toEnum idx
    else Nothing
