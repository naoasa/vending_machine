# 自動販売機の責務
class VendingMachine
  # 外部からカップ在庫数を読み書き可能にする
  attr_accessor :cups

  # オブジェクト生成時に自動販売機のメーカー名を記録
  def initialize(name)
    @manufacturer_name = name
    # 自動販売機内の預かり金
    @deposit = 0
    # カップの在庫数
    @cups = 0
  end

  # 投入されたお金が100円コインの場合のみ受け入れ、自動販売機に金額を貯める
  def deposit_coin(coin)
    coin = coin.to_i
    # 100円コインであるか否か
    if coin == 100
      @deposit += 100
    end
  end

  # 預り金がアイテム金額以上である場合にボタンを押すと、アイテムを出力する
  def press_button(item)
    # アイテムがカップコーヒーの場合と、そうでない場合
    if item.class == PapercupCoffee
      # カップ在庫数が1以上あり、かつ、預り金が商品価格以上である場合
      if @cups >= 1 && @deposit >= item.price
        # 預り金を減らす
        @deposit -= item.price
        # カップ数を減らす
        @cups -= 1
        # アイテムを返す
        item.name
      elsif @deposit < item.price
        "[残高不足] 預り金:#{@deposit}円, 商品:#{item.price}円"
      elsif @cups < 1
        "[カップ不足] カップの在庫がありません"
      end
    else
      if @deposit >= item.price
        # 預り金を減らす
        @deposit -= item.price
        # アイテムを返す
        item.name
      else
        "[残高不足] 預り金:#{@deposit}円, 商品:#{item.price}円"
      end
    end
  end

  # カップを追加する
  def add_cup(num)
    num = num.to_i
    # カップの在庫数が100より少ない場合、カップの在庫数を加算
    if @cups < 100
      @cups += num
    end
    # カップの在庫数が100を超えた場合、100に調整する
    if @cups > 100
      @cups = 100
    end
  end

  private
    # 自動販売機のメーカー名を出力(非公開)
    def press_manufacturer_name
      @manufacturer_name
    end
end

# アイテムの責務
class Item
  # 外部からアイテム名と価格を参照できるようにする
  attr_reader :name, :price
  # オブジェクト生成時にアイテム名を受け取り、格納する
  def initialize(name)
    @name = name # Ex. 'cola', 'hot'
    @price = 0 # 初期化
  end
end

# 飲み物の責務
class Drink < Item
  # アイテム名と価格を紐づけする
  def initialize(name)
    @name = name # Ex. 'cola'
    # アイテム名と価格を紐づけする
    case @name
    when 'cider' then
      @price = 100
    when 'cola' then
      @price = 150
    else
      "名前が一致するアイテムが見つかりません"
    end
  end
end

# カップコーヒーの責務
class PapercupCoffee < Item
  # 初期化メソッド
  def initialize(name)
    # カップコーヒーの価格
    @price = 100
    # 引数とアイテム名を紐づけする
    case name
    when 'ice' then
      @name = 'ice cup coffee'
    when 'hot' then
      @name = 'hot cup coffee'
    end
  end
end

# スナック菓子の責務
class Snack < Item
  # 初期化メソッド
  def initialize # 引数は受け取らない
    @name = 'potato chips'
    @price = 150
  end
end

# 実行
hot_cup_coffee = PapercupCoffee.new('hot');
cider = Drink.new('cider')
snack = Snack.new
vending_machine = VendingMachine.new('サントリー')

vending_machine.deposit_coin(100) #=> (100円を投入)
vending_machine.deposit_coin(100) #=> (100円を投入)
puts vending_machine.press_button(cider) #=> cider

puts vending_machine.press_button(hot_cup_coffee) #=> (カップ不足)
vending_machine.add_cup(1) #=> (カップを追加)
puts vending_machine.press_button(hot_cup_coffee) #=> hot cup coffee

puts vending_machine.press_button(snack) #=> (残高不足)
vending_machine.deposit_coin(100) #=> (100円を投入)
vending_machine.deposit_coin(100) #=> (100円を投入)
puts vending_machine.press_button(snack) #=> potato chips