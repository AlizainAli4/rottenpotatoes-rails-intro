class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    @all_ratings = Movie.select("DISTINCT rating").map(&:rating).sort
    @checked_ratings = params[:ratings] || {}
    
    if @checked_ratings == {}
      @checked_ratings = @all_ratings
    end
    
    if params[:sort] == "title" then
      @title_header = "hilite"
    else
      @title_header = ""
    end
    
    if params[:sort] == "release_date" then
      @release_date_header = "hilite"
    else
      @release_date_header = ""
    end
    
    if @checked_ratings.respond_to?('keys')
        @checked_ratings = @checked_ratings.keys
    end
    
    @movies = Movie.order(params[:sort]).where(rating: @checked_ratings)
  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
