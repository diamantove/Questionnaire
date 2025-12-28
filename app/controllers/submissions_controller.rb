class SubmissionsController < ApplicationController
  def new
    @survey = Survey.find(params[:id] || params[:survey_id])
    @submission = @survey.submissions.build

    @survey.questions.each do |q|
      @submission.answers.build(question_id: q.id)
    end
  end

  def create
    @submission = Submission.new(submission_params)
    @submission.user = current_user

    if @submission.save
      redirect_to surveys_path, notice: "Ваш ответ успешно сохранен!"
    else
      @survey = Survey.find(params[:submission][:survey_id])
      render :new, status: :unprocessable_entity
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:survey_id, answers_attributes: [ :question_id, :content, content: [] ])
  end
end
