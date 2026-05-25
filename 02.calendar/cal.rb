require 'date'

# ===考え方
# 日付を取得
# 月始めまで空白を出力。曜日の日付の前まで
# 日付出力

# === ★時期設定 
year = 2026
month = 5
# ===

# その月の最初の曜日/最後の日を取得
firstday = Date.new(year, month, 1)
lastday = Date.new(year, month, -1).day #数値

title = "#{year}年 #{month}月"
weekday = " 日  月  火  水  木  金  土" #表示用
S
# まず、１行目の空白を作る
brank = firstday.wday #最初の日付

# ===== 描画
puts title
puts weekday

# 空白ループ
brank.times do
  print " " + " ".rjust(2," ")+" ";
end

#２行目以降、続く　ループ
(1..lastday).each do | day |
  print " " + day.to_s.rjust(2) +" "

  if (Date.new(year,month,day).wday == 6)
    print "\n"
  end
end

# 最後の行のあとのスペースうめ
(6 - Date.new(year,month,lastday).wday).times do
  print "    "
end

print "\n"