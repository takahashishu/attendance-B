class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後ログイン
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params) # update_attributesメソッドはカラムと値のハッシュを引数として受け取り、更新に成功する場合に保存を同時に実行する。
      flash[:success] = "ユーザー情報を編集しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
  
  # beforeフィルター
  
  # paramsハッシュからユーザーを取得
  def set_user
    @user = User.find(params[:id])
  end
  
  
  # ログイン済みのユーザーか確認
    def logged_in_user
      unless logged_in? # 条件式がfalseの場合実行
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
  
  
    # アクセスしたユーザーが現在ログインしているユーザーか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end

