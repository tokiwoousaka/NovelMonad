module Main where
import Game.NovelMonad
import Game.NovelMonad.SimpleInterpreter

main :: IO ()
main = simpleInterpret defaultConfig $ do 
  talk Narrator ""
  talk Narrator "Novel Monad"
  talk Narrator ""
  trunOverThePage

  talk Narrator "ナレーションサンプル"
  talk Narrator "SimpleInterpreterでは"
  talk Narrator "デフォルトの文字色で表示される"
  trunOverThePage

  talk boy "男の子の発言"
  talk boy "SimpleInterpreterでは"
  talk boy "青色で表示される"
  talk girl "女の子の発言"
  talk girl "SimpleInterpreterでは"
  talk girl "赤色で表示される"
  trunOverThePage

  talk Narrator "入力用の命令：サンプル"
  ans <- selectChoices (talk Narrator "YesまたはNoを選択")
  talk Narrator $ case ans of
    Yes -> "Yesが入力された"
    No -> "Noが入力された"
  talk Narrator ""

  talk Narrator "Choices型クラスのインスタンスにする事で"
  talk Narrator "任意のデータ型を入力値に使う事もできる"
  ans <- selectChoices (talk Narrator "好きな果物を選択")
  talk Narrator $ case ans of 
    Apple -> "りんごが選択された"
    Banana -> "バナナが選択された" 
    Grape -> "ぶどうが選択された"
    Melon -> "メロンが選択された"
  trunOverThePage

  talk Narrator "NovelモナドとSimpleInterpretは"
  talk Narrator "独立した実装となっているため。"
  talk Narrator "一度Novelモナドで作成したシナリオを"
  talk Narrator "よりモダンな環境で実行させる事もできる"
  trunOverThePage

  talk Narrator ""
  talk Narrator " ~ Fin ~"

----

boy :: Actor 
boy = Actor
  { actorName = "男の子"
  , actorSex = Boy
  }

girl :: Actor 
girl = Actor
  { actorName = "女の子"
  , actorSex = Girl
  }

----

-- deriving(Enum, Bounded) 必須
data Fruit = Apple | Banana | Grape | Melon deriving (Enum, Bounded)
-- showItem 関数を実装：選択肢内での表示名を返すようにする
instance Choices Fruit where
  showItem Apple = "りんご"
  showItem Banana = "バナナ"
  showItem Grape = "ぶどう"
  showItem Melon = "メロン"
