class Question < ApplicationRecord
  belongs_to :survey
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank

  # Удалили rating: 3
  enum :question_type, { single_choice: 0, multiple_choice: 1, text_input: 2 }

  validates :content, presence: true

  before_save :clear_options_if_not_needed

  def options_list
    options.pluck(:content)
  end

  def requires_options?
    single_choice? || multiple_choice?
  end

  private

  def clear_options_if_not_needed
    unless requires_options?
      options.destroy_all
    end
  end
end
