require "json"
require "./zch_sentence"

# f = File.open("raw_text/002.txt")
# s = f.read
# f.close
# puts ZchSentence.emend(s)


# TODO: ブロック（cues）ごとに処理をして、文章結合（改行させない）。
# linebreak_remover.rb | punc_flatten.rb

# linebreak_remover.rb
# 入力、出力はjson。textのlinebreakのみを削除して上書きする

# punc_flatten.rb
# 出力は文字列の配列。cuesごとに配列にする。 [ "block1", "block2", ... ]
# このときpunctuationをかける。ブロックはlinebreakを含まないように注意。



class LinebreakRemover
  KEY_PARAGRAPHS = 'paragraphs'
  KEY_CUES = 'cues'
  KEY_TEXT = 'text'

  # read JSON file
  def initialize(filePath)
    File.open(filePath) do |file|
      @rawJson = JSON.load(file)
    end
  end

  # trim linebreak and whitespace which is not needed
  def execute
    @rawJson[KEY_PARAGRAPHS].map { |para|
      para[KEY_CUES].map { |v| v[KEY_TEXT].gsub(/([\r\n]|\s)/, "") }
    }
  end
end

# [ ] 一次元配列を受け取る
# 適切に句読点を付与し、（joined string | array）を返却する
class Punctuator
  def initialize(input)
    @input = input
  end

  def execute
    @input.map { |cues|
      pre = cues.map { |v| v << "\n" }.join
      [ ZchSentence.emend(pre).join ]
    }
  end
end


linebreakRemover = LinebreakRemover.new("json/002.json")
output = linebreakRemover.execute()

punctuator = Punctuator.new(output)
p punctuator.execute()
