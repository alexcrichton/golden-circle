class Setting
  include Mongoid::Document

  field :var
  field :value

  def value
    YAML.load self[:value]
  end

  def value= new_value
    self[:value] = new_value.to_yaml
  end

end
