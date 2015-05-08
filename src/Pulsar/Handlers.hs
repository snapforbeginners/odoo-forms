{-# LANGUAGE OverloadedStrings #-}
module Pulsar.Handlers where

import qualified Data.Text                     as T (pack)
import           Pulsar.Forms
import           Pulsar.Microblog              (getAllMicroblogs, getMicroblog,
                                                insertMicroblog)
import           Pulsar.Types                  (Blog (..), MicroblogID (..),
                                                ToPGMicroblog (..),
                                                Username (..))
import           Snap                          (Handler, writeText)
import           Snap.Snaplet.Heist            (HasHeist (..), heistLocal,
                                                render)
 import           Snap.Snaplet.PostgresqlSimple (Postgres)
import           Text.Digestive.Heist          (bindDigestiveSplices)
import           Text.Digestive.Snap           (runForm)

microblog :: ToPGMicroblog
microblog = ToPGMicroblog (Blog "My awesome microblog!") (Username "biscarch")

handleInsert :: Handler b Postgres ()
handleInsert = do
  rowsAffected <- insertMicroblog microblog
  writeText $ T.pack $ show rowsAffected

getAllTest :: Handler b Postgres ()
getAllTest = do
           mblogs <- getAllMicroblogs
           writeText $ T.pack $ show mblogs

getOneTest :: Handler b Postgres ()
getOneTest = do
           mblog <- getMicroblog (MicroblogID 1)
           case mblog of
             Nothing -> writeText "No Blog"
             Just b -> writeText $ T.pack $ show b

formHandler :: Handler b v ()
formHandler = do
            (view, result) <- runForm "microblog" blogForm
            case result of
              Just (Blog b) -> writeText b
              Nothing -> writeText "Nothing"

insertTest = undefined

blogFormHandler :: (HasHeist b) => Handler b v ()
blogFormHandler = do
  (view, result) <- runForm "microblog" blogForm
  case result of
    Just x  -> writeText $ T.pack $ show x
    Nothing -> heistLocal (bindDigestiveSplices view) $ render "blog_form"
