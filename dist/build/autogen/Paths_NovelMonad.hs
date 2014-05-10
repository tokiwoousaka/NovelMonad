module Paths_NovelMonad (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/tune/.cabal/bin"
libdir     = "/home/tune/.cabal/lib/i386-linux-ghc-7.6.3/NovelMonad-0.1.0.0"
datadir    = "/home/tune/.cabal/share/i386-linux-ghc-7.6.3/NovelMonad-0.1.0.0"
libexecdir = "/home/tune/.cabal/libexec"
sysconfdir = "/home/tune/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "NovelMonad_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "NovelMonad_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "NovelMonad_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "NovelMonad_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "NovelMonad_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
