class CommentsController < ApplicationController

  def ssl_required?
    true
  end

  # Login Code
  # before_filter :admin, :except => [ :index, :show, :edit, :update ]
  
  
  # GET /comments
  # GET /comments.xml
  

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@comment.wall, :notice => 'Comment was successfully created.') }
      else
        format.html { redirect_to(@comment.wall, :notice => 'Error creating comment: #{@comment.errors}') }
      end
    end
  end
  

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@comment.wall) }
      format.xml  { head :ok }
    end
  end
  
	def comment_params
	  params.require(:comment).permit(:content, :signature, :wall_id)
	end
end
