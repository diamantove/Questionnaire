class Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :user

  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  validates :user_id, uniqueness: { scope: :survey_id, message: "вы уже проходили этот опрос" }
end
