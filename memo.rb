require "csv"

MEMO_TYPE_WRITE  = "1"
MEMO_TYPE_APPEND = "2"
MEMO_FILE_NAME   = "memo.csv"

MESSAGE_INVALID_MEMO_TYPE = "1もしくは2を指定してください．"
MESSAGE_ASKMTYPE = "1(新規でメモを作成) 2(既存のメモを編集する)"
MESSAGE_ASKFNAME = "拡張子を除いたファイル名を入力してください．"
MESSAGE_START    = "メモしたい内容を記入してください．\n完了したら[Ctrl]+Dを押します．"

MESSAGE_INVALID_FNAME = "ファイル名は半角英数字とアンダースコア(_)のみを使用して10文字以内で指定してください．"
VALID_FNAME_PATTERN   = /^[a-zA-Z0-9_]{,10}$/

MESSAGE_OVERRWITE = "指定されたファイルはすでに存在します．"

def get_csv_path(file_name)
  if VALID_FNAME_PATTERN.match(file_name)
    File.join(__dir__, "#{file_name}.csv")
  else
    nil
  end
end

def get_file_mode(memo_type)
  case memo_type
  when MEMO_TYPE_WRITE  then "w"
  when MEMO_TYPE_APPEND then "a"
  else nil
  end
end

# ask memo type
puts MESSAGE_ASKMTYPE
memo_type = gets.chomp

# get file mode from memo type
file_mode = get_file_mode(memo_type)
if file_mode.nil?
  puts MESSAGE_INVALID_MEMO_TYPE
  exit
end

# ask file name
puts MESSAGE_ASKFNAME
file_name = gets.chomp

# get file path from file name
file_path = get_csv_path(file_name)
if file_path.nil?
  puts MESSAGE_INVALID_FNAME
  exit
end

# check file existence
if File.exist?(file_path) && file_mode == "w"
  puts MESSAGE_OVERRWITE
  exit
end

# ask csv file imput
puts MESSAGE_START
inputs = readlines.map(&:chomp)

# write csv file
if inputs.length == 0 then exit end

begin
  f = File.open(file_path, file_mode)
  f.write(inputs.join(",") + "\n")
rescue => e
  puts "処理中にエラーが発生しました:#{e.message}"
ensure
  f.close if !f.nil?
end


