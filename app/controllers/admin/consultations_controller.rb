class Admin::ConsultationsController < ApplicationController
  before_action :admin_user

  def index
    if params[:sort] == "new" || params[:sort] == nil                                   #新しい順
      @consultations = Consultation.all.page(params[:page]).per(30)
    elsif params[:sort] == "old"                                                        #古い順
      @consultations = Consultation.order(id: "DESC").page(params[:page]).per(30)
    elsif params[:sort] == "look"                                                     #閲覧数多い順
      @consultations = Consultation.order(impressions_count: "DESC").page(params[:page]).per(30)
    elsif params[:sort] == "comment"                                                     #コメント多い順
      @consultations = Consultation.joins(:consultation_answers).group(:id).order("count(consultation_answers.id)DESC").page(params[:page]).per(30)
    elsif params[:sort] == "helpfulness"                                                     #役に立った！多い順
      @consultations = Consultation.joins(consultation_answers: :helpfulnesses).group(:id)
                                   .order("count(helpfulnesses.id) DESC").page(params[:page]).per(30)
    end
  end

  def search
    @consultations = Consultation.search(params[:keyword]).page(params[:page]).per(30)
    @keyword = params[:keyword]
  end

  private

  def admin_user
    if user_signed_in?
      if current_user.admin == false
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end



end
