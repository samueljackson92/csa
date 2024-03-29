class Image < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, styles: { large: '124x124#',
                                      medium: '80x80#',
                                      small: '50x50#',
                                      tiny: '30x30#' }
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]                                    
end
