class Visit < ActiveRecord::Base

  belongs_to(
    :user,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'
  )

  belongs_to(
    :shortened_url,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: 'ShortenedUrl'
  )

  def self.record_visit!(user, shortened_url)
    self.create!(user_id: user.id, url_id: shortened_url.id)
  end

end
