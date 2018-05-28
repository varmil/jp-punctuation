require "json"
require "./zch_sentence"
require 'pp'

# 読み込むJSONスクリプトの相対パス
JSON_PATH = "json/003.json"

# 生台本を処理するクラス
class ScriptReader
  KEY_PARAGRAPHS = 'paragraphs'
  KEY_CUES = 'cues'
  KEY_TEXT = 'text'
  KEY_TIME = 'time'

  # read JSON file
  def initialize(filePath)
    File.open(filePath) do |file|
      @rawJson = JSON.load(file)
    end
  end

  # trim linebreak and whitespace which is not needed
  # return array of array （cuesごとの配列＋textごとの配列）
  def parseText
    @rawJson[KEY_PARAGRAPHS].map { |para|
      para[KEY_CUES].map { |v| v[KEY_TEXT].gsub(/([\r\n]|\s)/, "") }
    }
  end

  # return array (the first time of each cue)
  def parseTime
    @rawJson[KEY_PARAGRAPHS].map { |para|
      para[KEY_CUES].map { |v| v[KEY_TIME] }.first
    }
  end
end

class Punctuator
  # ScriptReaderが処理したテキスト（2次元配列）を受け取る
  def initialize(texts)
    @texts = texts
  end

  # 適切に句読点を付与し、（joined string :array）を返却する
  def execute
    @texts.map { |cues|
      pre = cues.map { |v| v << "\n" }.join
      ZchSentence.emend(pre).join
    }
  end
end



# 基本戦略：ブロック（cues）ごとに処理をして文章結合
reader = ScriptReader.new(JSON_PATH)
# create time array
times = reader.parseTime()
# create text array
punctuator = Punctuator.new(reader.parseText())
texts = punctuator.execute()

# check
if times.length != texts.length
  raise "the length of times:#{times.length} and texts:#{texts.length} is NOT matched"
end

# merge two arrays (times, texts) into a hash
result = []
times.each.with_index do |time, i|
  result << { :time => times[i], :text => texts[i] }
end

# debug
pp result
# p result.map { |v| v[:time] }
# p result.map { |v| v[:text] }
