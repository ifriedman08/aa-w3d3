class User < ActiveRecord::Base

  has_many(
    :submitted_urls,
    class_name: 'ShortenedUrl',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Visit'
  )

  has_many(
    :visited_urls,
    through: :visits,
    source: :shortened_url
  )

  validates :email, presence: true, uniqueness: true


  def num_urls_in_five_mins
    self.submitted_urls.where(created_at: (5.minutes.ago..Time.now)).count
  end

  def status_change
    self.premium = !self.premium
    self.save!
  end

end
