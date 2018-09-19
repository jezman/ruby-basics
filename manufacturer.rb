module Manufacturer
  attr_reader :manufacturer

  def manufacturer=(name)
    @manufacturer = name
    validation!
  end

  private

  MANUFACTURER_NAME_FORMAT = /^[a-zа-я0-9\s]{2,}$/i

  def validation!
    raise 'Не указан производитель' if @manufacturer.nil?
    raise 'Название производителя должно содержать минимум 2 символа' if @manufacturer !~ MANUFACTURER_NAME_FORMAT
  end

end
