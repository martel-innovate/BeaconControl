class Address < ActiveRecord::Base
  belongs_to :adressable, polymorphic: true
end
