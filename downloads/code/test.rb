class User < ActiveRecord::Base
  before_save :generate_slug
  .
  # rest of the code omitted for brevity
  .
  def generate_slug
    self.slug = self.username
  end

  def to_param
    self.slug # overrides the default self.id
  end

end
