class UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]
  before_action :authorize_user, except: [:index, :new, :create, :show]
  before_action :current_user_redirect_to_root, only: [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Пользователь успешно зарегистрирован!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Данные обновлены'
    else
      render 'edit'
    end
  end

  def show
    @questions = @user.questions.order(created_at: :desc) if @user&.questions
    @new_question = @user.questions.build
    @questions_count = @questions.count
    @answers_count = @questions.where.not(answer: nil).count
    @unanswered_count = @questions_count - @answers_count
  end

  private

  def load_user
    @user ||= User.find params[:id]
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :username, :avatar_url
    )
  end

  def authorize_user
    reject_user unless @user == current_user
  end

  def current_user_redirect_to_root
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?
  end
end
