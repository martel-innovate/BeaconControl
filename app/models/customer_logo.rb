class CustomerLogo < ActiveRecord::Base
  belongs_to :contact

  mount_uploader :file, CustomerLogoUploader
  delegate :url, to: :file, allow_blank: true
end
