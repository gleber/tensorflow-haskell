-- Copyright 2016 TensorFlow authors.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

{-# LANGUAGE OverloadedLists #-}
module Main where

import Control.Monad.IO.Class (liftIO)
import Google.Test (googleTest)
import Test.Framework.Providers.HUnit (testCase)
import Test.HUnit ((@=?))
import qualified Data.Vector as V

import qualified TensorFlow.Ops as TF
import qualified TensorFlow.Session as TF
import qualified TensorFlow.GenOps.Core as CoreOps

-- | Test split and concat are inverses.
testSplit = testCase "testSplit" $ TF.runSession $ do
    let original = TF.constant [2, 3] [0..5 :: Float]
        splitList = CoreOps.split 3 dim original
        restored = CoreOps.concat dim splitList
        dim = 1  -- dimension to split along (with size of 3 in original)
    liftIO $ 3 @=? length splitList
    (x, y, z) <-
        TF.buildAnd TF.run $ return (original, restored, splitList !! 1)
    liftIO $ x @=? (y :: V.Vector Float)
    liftIO $ V.fromList [1, 4] @=? z

main :: IO ()
main = googleTest [ testSplit
                  ]
