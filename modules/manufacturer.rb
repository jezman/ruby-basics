module Manufacturer
  NAME_FORMAT = /^[a-zа-я0-9\s]{2,}$/i

  attr_reader :manufacturer

  def manufacturer=(name)
    @manufacturer = name
    validation!
  end

  private

  def validation!
    raise 'Не указан производитель' if @manufacturer.nil?
    raise 'Укажите минимум 2 символа' if @manufacturer !~ NAME_FORMAT
  end
end
