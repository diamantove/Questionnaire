class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  validates :content, presence: true

  def content=(value)
    if value.is_a?(Array)
      super(value.reject(&:blank?).join(", "))
    else
      super(value)
    end
  end
end