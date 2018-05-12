class CleanExpiredUrlPairsWorker
  include Sidekiq::Worker

  def perform
    UrlPair.where("created_at < ?", 14.days.ago).destroy_all
  end
  
end
