class SurveysController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @my_surveys = current_user ? current_user.surveys : []
    if current_user
      @public_surveys = Survey.where.not(user_id: current_user.id).order(created_at: :desc)
    else
      @public_surveys = Survey.all.order(created_at: :desc)
    end
    @surveys = Survey.all
  end

  def new
    @survey = current_user.surveys.build
    q = @survey.questions.build
    q.options.build
  end

  def edit
    @survey = current_user.surveys.find(params[:id])
    render :new
  end

  def build_form
    @survey = if params[:id].present? && params[:id] != "build_form"
                current_user.surveys.find(params[:id])
    else
                current_user.surveys.build
    end

    @survey.assign_attributes(survey_params)

    if params[:add_question]
      new_q = @survey.questions.build
      new_q.options.build
      render :new, status: :unprocessable_entity

    elsif params[:add_option]
      q_idx = params[:add_option].to_i

      target_q = @survey.questions.reject(&:marked_for_destruction?)[q_idx]
      target_q.options.build if target_q

      render :new, status: :unprocessable_entity

    elsif params[:remove_question]
      q_idx = params[:remove_question].to_i
      target_q = @survey.questions.reject(&:marked_for_destruction?)[q_idx]
      target_q.mark_for_destruction if target_q

      render :new, status: :unprocessable_entity

    elsif params[:remove_option]
      q_idx, o_idx = params[:remove_option].split(":").map(&:to_i)
      target_q = @survey.questions.reject(&:marked_for_destruction?)[q_idx]

      if target_q
        target_o = target_q.options.reject(&:marked_for_destruction?)[o_idx]
        target_o.mark_for_destruction if target_o
      end

      render :new, status: :unprocessable_entity

    else
      if @survey.save
        redirect_to surveys_path, notice: "Опрос успешно сохранен!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
    redirect_to new_survey_path and return if params[:id] == "build_form"
    @survey = Survey.find(params[:id])
  end

  def stats
    @survey = current_user.surveys.includes(questions: [ :answers, :options ]).find(params[:id])
    @submission_count = @survey.submissions.count
  end

  def destroy
    @survey = current_user.surveys.find(params[:id])
    @survey.destroy
    redirect_to surveys_path, notice: "Опрос удален."
  end

  private

  def survey_params
    params.require(:survey).permit(
      :title, :description,
      questions_attributes: [
        :id, :content, :question_type, :_destroy,
        options_attributes: [ :id, :content, :_destroy ]
      ]
    )
  end
end
