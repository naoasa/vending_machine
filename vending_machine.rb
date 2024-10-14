# 自動販売機の責務
class VendingMachine
  # オブジェクト生成時に自動販売機のメーカー名を記録
  def initialize(name)
    @manufacturer_name = name
    # 自動販売機内の預かり金
    @deposit = 0
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
    if @deposit >= item.price
      # 預り金を減らす
      @deposit -= item.price
      # アイテムを返す
      item.name
    else
      "[残高不足] 預り金:#{@deposit}円, 商品:#{item.price}円"
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
  # アイテム名を外部から参照可能にする
  attr_reader :name, :price

  # オブジェクト生成時にアイテム名を受け取り、格納する
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

# 実行
cola = Item.new('cola')
vending_machine = VendingMachine.new('サントリー')

vending_machine.deposit_coin(100)
puts vending_machine.press_button(cola) #=> 空文字

vending_machine.deposit_coin(100)
puts vending_machine.press_button(cola) #=> cola