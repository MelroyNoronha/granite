# frozen_string_literal: true

class User < ApplicationRecord
  MAX_NAME_LENGTH = 255
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  MAX_EMAIL_LENGTH = 255

  with_options class_name: "Task" do |user|
    user.has_many :created_tasks, foreign_key: :task_owner_id
    user.has_many :assigned_tasks, foreign_key: :assigned_user_id
  end

  with_options dependent: :destroy do |user|
    user.has_many :comments
    user.has_many :user_notifications, foreign_key: :user_id
    user.has_one :preference, foreign_key: :user_id
  end

  has_secure_password
  has_secure_token :authentication_token

  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: MAX_EMAIL_LENGTH },
    format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :password_confirmation, presence: true, on: :create

  before_save :email_to_lowercase
  before_create :build_default_preference
  before_destroy :reassign_tasks_whose_owner_is_not_current_user

  private

    def email_to_lowercase
      email.downcase!
    end

    def build_default_preference
      self.build_preference(notification_delivery_hour: Constants::DEFAULT_NOTIFICATION_DELIVERY_HOUR)
    end

    def reassign_tasks_whose_owner_is_not_current_user
      tasks_whose_owner_is_not_current_user = assigned_tasks.select { |task| task.task_owner_id != id }
      tasks_whose_owner_is_not_current_user.each do |task|
        task.update(assigned_user_id: task.task_owner_id)
      end
    end
end
