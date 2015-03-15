class Page < ActiveRecord::Base
  validates :slug, uniqueness: true, presence: true, exclusion: {in: %w[signup login]}

  acts_as_tree

  #has_ancestry

  before_validation :generate_slug

  def to_param
    slug
  end

  def generate_slug
    slug.present? ? slug : self.slug = name.parameterize
  end

end
