class Contact < ActiveRecord::Base
  belongs_to :admin
  has_one :logo, class_name: "CustomerLogo", dependent: :destroy

  mount_uploader :file, CustomerLogoUploader
  delegate :url, to: :file, allow_blank: true
end
