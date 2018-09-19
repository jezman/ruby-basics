module Validate
  def valid?
    validation!
    true
  rescue
    false
  end
end
