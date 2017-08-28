###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

class Admin < ActiveRecord::Base
  extend UuidField
  include HasCorrelationId
  include Searchable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  if AppConfig.registerable
    devise :database_authenticatable, :registerable,
           :rememberable, :trackable, :validatable,
           :confirmable, :recoverable, :password_archivable
  else
    devise :database_authenticatable,
           :rememberable, :trackable, :validatable,
           :confirmable, :recoverable, :password_archivable
  end

  attr_accessor :login
  validates :username,
    :uniqueness => {
      :case_sensitive => false
    }

  enum role: [:admin, :beacon_manager, :customer]

  validates :role,
    presence: true,
    inclusion: { in: Admin.roles }

  belongs_to :account
  has_many :zones,   foreign_key: :manager_id, dependent: :nullify
  has_many :beacons, foreign_key: :manager_id, dependent: :nullify
  has_one :contact, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy

  has_many :access_tokens, -> { where(scopes: 'admin') },
    class_name:  'Doorkeeper::AccessToken',
    foreign_key: 'resource_owner_id',
    dependent:   :destroy

  has_many :customers_applications, foreign_key: :customer_id, class_name: 'ApplicationsCustomer', dependent: :destroy
  has_many :customer_applications, through: :customers_applications, source: :application

  # newly added data
  has_many :geofences, foreign_key: :customer_id
  has_many :schedules, foreign_key: :customer_id
  has_many :bus_stops, foreign_key: :customer_id
  has_many :toilets, foreign_key: :customer_id
  has_many :notifications, foreign_key: :customer_id
  has_many :places, foreign_key: :customer_id
  has_many :advertisments, foreign_key: :customer_id
  has_many :home_sliders, foreign_key: :customer_id

  delegate :applications, :test_application, :triggers, :activities, to: :account


  #
  # Includes UuidField module functionality.
  #
  uuid_field :default_beacon_uuid

  scope :beacon_managers, -> { where(role: roles[:beacon_manager]) }

  scope :sorted, -> (column, direction) do
    sorted_column = %w(admins.email admins.role).include?(column) ?
                      column :
                      'admins.email'
    direction = %w[asc desc].include?(direction) ?
                  direction :
                  'asc'
    order("#{sorted_column} #{direction}")
  end

  scope :with_email, ->(email) { where('email LIKE ?', "%#{email}%") }

  after_create do
    confirm! if !confirmed?
  end

  validates :password, confirmation: true, on: :update, if: -> { password.present? }

  def account_managers
    account.admins.beacon_managers
  end

  def after_database_authentication
    update_correlation_id_from_current_thread
    save
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

  def to_customer_json
    self.to_json(include: [:address, :customers_applications, contact: { include: :logo }])
  end

  def self.generate_password
    (0...8).map { (65 + rand(26)).chr }.join
  end

  protected

  def password_required?
    persisted? && encrypted_password.blank?
  end
end
