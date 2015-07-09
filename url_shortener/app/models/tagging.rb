class Tagging < ActiveRecord::Base

  belongs_to(
    :tag_topic,
    foreign_key: :tag_id,
    primary_key: :id,
    class_name: 'TagTopic'
  )

  belongs_to(
    :url,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: 'ShortenedUrl'
  )

end
