class TutorialsController < ApplicationController

	before_filter :authenticate_user!, only: [:new, :create]

	def new 
		@tutorial = Tutorial.new
	end

	def edit
		@tutorial = Tutorial.find(params[:id])
		get_tags_string(@tutorial)
	end

	def index
		@search = Tutorial.search(params[:q])
		@tutorials = @search.result	
	end

	def update
		@tutorial = Tutorial.find(params[:id])
		if @tutorial.update_attributes(params[:tutorial])
			@tutorial.tags.clear
			@tutorial.create_tags(params[:tag])
			redirect_to @tutorial, notice: "Update successful!"
		else
			debugger
      redirect_to :back, notice: "Something went wrong"
    end
	end


	def destroy
		@tutorial = Tutorial.find(params[:id]).destroy
		redirect_to '/profile'
	end

	
	def create 
		p params[:tutorial]
		puts '*' * 400
		@tutorial = Tutorial.new(params[:tutorial])
		@tutorial.user_id = current_user.id
		if @tutorial.save 
		  @tutorial.create_tags(params[:tag])
			redirect_to @tutorial, notice: "Thanks for creating a tutorial"
		else
			render :new
		end
	end

	def show 
		@tutorial = Tutorial.includes(:category).find(params[:id])
		@markdown = MARKDOWN.render(@tutorial.content) if @tutorial.content
		@tags = @tutorial.tags
    @comments = @tutorial.comments.includes(:user)
    @comment = @tutorial.comments.new
	end


	
end
