class BoardsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource
  
  
  def index
    @boards = Board.where(board_private: false).order(created_at: :DESC).page(params[:page]).per(6)
    
    # .where(board_private: :false)
    
    # GroupUser.where(GroupUser.arel_table[:user_id].not_eq(me))
  end

  def new
    @board = Board.new
  end

  def show
    @board = Board.find(params[:id])
  end
  
  def create
    
    if user_signed_in?
      @makeBoard = Board.new(board_params)
      @makeBoard.user_id = current_user.id
      @makeBoard.boardUser = current_user.email
      @makeBoard.boardUserBGID = current_user.bgid
      @makeBoard.boardCategory = params[:board]["boardCategory"]
      @makeBoard.board_create_time = Time.now.to_i
      @makeBoard.board_private = false
      @makeBoard.save
      # if @makeBoard.save
        # flash[:success] = "성공적으로 저장되셨습니다."
        redirect_to '/boards'
      # else
      #   flash[:error] = "사진이 업로드 되지 않으셨습니다. 사진을 다시 올려주세요."
      #   redirect_to '/boards/new'
      # end
      
    end

    # redirect_to '/boards' #method는 자동으로 get

  end
  
  def save_private
    @makeBoard2 = Board.find(params[:id])
    @makeBoard2.board_private = params[:private_value]
    @makeBoard2.save
    
    redirect_to '/boards'
    
    authorize! :save_private, @makeBoard2
  end
  
  private
  
  def board_params
      params.require(:board).permit(:boardCategory, :boardContent, :board_image_url)
  end
  
  # def is_user?
  #   unless current_user == true
  #     redirect_to new_user_session_path
  #   end
  # end
  
end
