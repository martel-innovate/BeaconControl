class Toilet < ActiveRecord::Base
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address

  scope :with_toilet_name, ->(name) {
    if name.present?
      where('toilets.name LIKE :name', {name: "%#{name}%"})
    end
  }


  KINDS = [
    'Öffentliche Toiletten mit internationalen Schließsystem',
    'Öffentliche Toiletten',
    'Toiletten in Kaufhäusern und Cafés'
  ]

  ACCESSIBLES = [
    'Behindertengerecht',
    'Behindertenfreundlich'
  ]

  def kind_text
    kind.present? ? KINDS[kind] : ''
  end

  def accessible_text
    accessible.present? ? ACCESSIBLES[accessible] : ''
  end
end
