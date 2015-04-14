{-# LANGUAGE OverloadedStrings #-}
module Odoo.Forms where

import           Control.Applicative  ((<$>), (<*>))
import           Data.Text            (Text)
import qualified Data.Text            as T (append, null, pack)
import           Odoo.Types           (Blog (..), ToPGMicroblog (..),
                                       Username (..))
import           Snap                 (Handler, writeText)
import           Text.Digestive
import           Text.Digestive.Heist
import           Text.Digestive.Snap

isNotEmpty :: Text -> Bool
isNotEmpty = not . T.null

toPGMicroblogForm :: (Monad m) => Form Text m ToPGMicroblog
toPGMicroblogForm = ToPGMicroblog
  <$> "blog" .: blogForm
  <*> "user" .: usernameForm

blogForm :: (Monad m) => Form Text m Blog
blogForm = Blog
  <$> "blog" .: check "blog cannot be empty" isNotEmpty (text Nothing)

usernameForm :: (Monad m) => Form Text m Username
usernameForm = Username
  <$> "username" .: check "username cannot be empty" isNotEmpty (text Nothing)

formHandler :: Handler b v ()
formHandler = do
            (view, result) <- runForm "pg-microblog" toPGMicroblogForm
            case result of
              Just (ToPGMicroblog (Blog b) (Username u)) -> writeText (T.append u b)
              Nothing -> writeText "Nothing"
