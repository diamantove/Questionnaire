class Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :user # Без optional: true это поле теперь обязательно

  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  # Валидация, чтобы один юзер не спамил в один и тот же опрос (по желанию)
  validates :user_id, uniqueness: { scope: :survey_id, message: "вы уже проходили этот опрос" }
end
