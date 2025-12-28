class Survey < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy, inverse_of: :survey

  has_many :submissions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true

  validate :must_have_at_least_one_question

  private

  def must_have_at_least_one_question
    active_questions = questions.reject(&:marked_for_destruction?)
    if active_questions.empty?
      errors.add(:base, "Опрос не может быть пустым. Добавьте хотя бы один вопрос.")
    end
  end
end
