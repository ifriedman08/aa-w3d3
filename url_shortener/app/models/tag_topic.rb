class TagTopic < ActiveRecord::Base

  validate :tag, presence: true, uniqueness: true

  has_many(
    :taggings,
    foreign_key: :tag_id,
    primary_key: :id,
    class_name: 'Tagging'
  )

  has_many(
    :urls,
    through: :taggings,
    source: :url
  )

end
