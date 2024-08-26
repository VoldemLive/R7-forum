class ForumsController < ApplicationController
  before_action :set_forum, only: %i[ show edit update destroy ]

  # GET /forums or /forums.json
  def index
    @forums = Forum.all
  end

  # GET /forums/1 or /forums/1.json
  def show
  end

  # GET /forums/new
  def new
    @forum = Forum.new
  end

  # GET /forums/1/edit
  def edit
  end

  # POST /forums or /forums.json
  def create
    @forum = Forum.new(forum_params)
    if !@current_user
      redirect_to root_path, notice: "You can't add, modify, or delete forum before logon."
      return
    end
    respond_to do |format|
      if @forum.save
        format.html { redirect_to forum_url(@forum), notice: "Forum was successfully created." and return }
        format.json { render :show, status: :created, location: @forum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forums/1 or /forums/1.json
  def update
    if !@current_user
      redirect_to forums_path, notice: "You can't add, modify, or delete forum before logon."
      return
    end
    respond_to do |format|
      if @forum.update(forum_params)
        format.html { redirect_to forum_url(@forum), notice: "Forum was successfully updated."}
        format.json { render :show, status: :ok, location: @forum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1 or /forums/1.json
  def destroy
    if !@current_user
      redirect_to forums_path, notice: "You can't add, modify, or delete forum before logon."
      return
    end
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to forums_url, notice: "Forum was successfully destroyed."}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum
      begin
        @forum = Forum.find(params[:id])
      rescue
        redirect_to forums_url, notice: "forum with id:#{params[:id]} was not found"
      end
    end

    # Only allow a list of trusted parameters through.
    def forum_params
      # my previous code was with a error, here I lost name, because saved just a descripsion
      # params.require(:forum).permit(:forum_name)
      # params.require(:forum).permit(:description)
      params.require(:forum).permit(:forum_name, :description)
    end
end
