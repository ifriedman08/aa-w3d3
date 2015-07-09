class ShortenedUrl < ActiveRecord::Base

  validates :long_url, length: { maximum: 1024 }

  validate :max_five_per_min

  belongs_to(
    :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: 'User'
  )

  has_many(
    :visits,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: 'Visit'
  )

  has_many(
    :visitors,
    -> { distinct },
    through: :visits,
    source: :user
  )

  has_many(
    :taggings,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: 'Tagging'
  )

  has_many(
    :tags,
    -> { distinct },
    through: :taggings,
    source: :tag
  )

  def max_five_per_min
    if submitter.num_urls_in_five_mins > 5 && submitter.premium == false
      errors[:max] << "Too Many, Calm Down"
    end
  end

  # def self.num_urls_in_five_mins_by(user)
  #   self.select(submitter: user.id).where(created_at: (5.minutes.ago..Time.now)).count
  # end

  def self.random_code
    random = SecureRandom::urlsafe_base64
    return random unless self.exists?(short_url: random)

    self.random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    random_string = self.random_code
    self.create!(submitter_id: user.id, long_url: long_url, short_url: random_string)
  end

  def num_clicks
    self.visitors.count
  end

  def num_uniques
    self.visitors.distinct.count
  end

  def num_recent_uniques
    self.visitors.where(created_at: (10.minutes.ago..Time.now)).count
  end
end
