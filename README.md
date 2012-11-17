# Numeron

ヌメロンの解の探索プログラム (Ruby版) (作成中)

Androidアプリ ... https://play.google.com/store/apps/details?id=com.jpn.gemstone.numer0n.android
iPhoneアプリ  ... https://itunes.apple.com/jp/app/numer0n-numeron/id512484171?mt=8

## Usage

基本

```
calc = Numeron::Calculator.new
calc.input('123', 0, 1) # callした番号, Eatの数, Biteの数
p calc.possibilities # 答えの可能性の一覧がでてくる

# 続いて以下のように245をcallして 2Eat, 0Biteだった場合 11個に絞りこまれる
calc.input('245', 2, 0)
p calc.possibilities
# => ["240", "246", "247", "248", "249", "205", "265", "275", "285", "295", "345"]
```

Shuffle対応(ほとんどテストはしていない)

```
calc = Numeron::Calculator.new
calc.input('123', 0, 3)
calc.shuffle # シャッフルされた
p calc.possibilities.size
# => 6

calc = Numeron::Calculator.new
calc.input('123', 1, 1)
p calc.possibilities.size
# => 42
calc.shuffle
p calc.possibilities.size
# => 126
```

## Numeron::Calculator

ヌメロンの解の可能性として考えられるものを計算する部分。

以下の2つの変数を用いている

`@mays`

@mays[0]が左側の数値の可能性リスト(初期値0-9)<br>
@mays[1]が真ん中の数値の可能性リスト(初期値0-9)<br>
@mays[2]が右側の数値の可能性リスト(初期値0-9)<br>

`@possibilities`

解の可能性リスト

## Numeron::Analyzer

作成途中

やりたいこと ... 次の1手の計算をできるようにする(解の可能性リストが最小になる1手)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
