module MaybeT
( MaybeT(..)
) where

import Control.Monad
import Control.Monad.Trans

newtype MaybeT m a = MaybeT {
      runMaybeT :: m (Maybe a)
    }

bindMT :: (Monad m) => MaybeT m a -> (a -> MaybeT m b) -> MaybeT m b
bindMT x f = MaybeT $ do
                 unwrapped <- runMaybeT x
                 case unwrapped of
                   Nothing -> return Nothing
                   Just y -> runMaybeT (f y)

-- QUESTION
-- any diff between declaring functions as infix/prefix 

returnMT :: (Monad m) => a -> MaybeT m a
returnMT a = MaybeT $ return (Just a)

failMT :: (Monad m) => t -> MaybeT m a
failMT _ = MaybeT $ return Nothing
 
instance (Monad m) => Monad (MaybeT m) where
  return = returnMT
  (>>=) = bindMT
  fail = failMT

instance MonadTrans MaybeT where
    lift m = MaybeT (Just `liftM` m)


