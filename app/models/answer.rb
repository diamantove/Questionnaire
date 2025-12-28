class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  validates :content, presence: true

  # Обработка входящих данных: превращаем массив из чекбоксов в строку
  def content=(value)
    if value.is_a?(Array)
      super(value.reject(&:blank?).join(", "))
    else
      super(value)
    end
  end
end
