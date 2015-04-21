class ArticlesController < ApplicationController
  
#KA: The show action expects an id parameter that needs to be passed. Run rake routes to see the route patters.

 
  def index
#KA: The name Article is the same as the one defined in /app/models/article.rb
    @articles = Article.all
  end


  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end


  def edit
    @article = Article.find(params[:id])
  end

  def create
	#KA: Inspect the parameters entered in the form
	#render plain: params[:article].inspect

	#KA: Save the values entered in the form in the database table articles

	#KA: All the values in the form can be accessed by this method below but it poses security risks.
	#@article = Article.new(params[:article])

	#Hence the safest way to do this is:
	 @article = Article.new(article_params)

	#KA: If Block with check for validation and if true saves the records, else goes to new action
	if @article.save
		redirect_to @article
	else
		render 'new'
	end
  end


def update
  @article = Article.find(params[:id])
 
  if @article.update(article_params)
    redirect_to @article
  else
    render 'edit'
  end
end

def destroy
  @article = Article.find(params[:id])
  @article.destroy
 
  redirect_to articles_path
end



	#KA: By explicitly defining the fields in the form, we can control any malicious code from being entered in the form.
	# Also putting this into its own method will help us reuse it for multiple actions (create, update etc)
	private
  		def article_params
    			params.require(:article).permit(:title, :text)
  		end
	
end
