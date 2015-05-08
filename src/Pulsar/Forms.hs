{-# LANGUAGE OverloadedStrings #-}
module Pulsar.Forms where

import           Data.Text      (Text)
import qualified Data.Text      as T (null)
import           Pulsar.Types   (Blog (..))
import           Text.Digestive (Form, check, text, (.:))

isNotEmpty :: Text -> Bool
isNotEmpty = not . T.null

blogErrMsg :: Text
blogErrMsg = "Microblog can not be empty"

blogForm :: (Monad m) => Form Text m Blog
blogForm = Blog
  <$> "blog" .: check blogErrMsg isNotEmpty (text Nothing)
