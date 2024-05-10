class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
    @list = List.find(params[:list_id])
    @movies = Movie.where.not(id: @list.movies)
  end

  def create
    # We need to add this movie to a specific list, so we first find the list,
    # which in this case is coming from the URL parameters
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new(bookmark_params)
    # The bookmark we create needs to know which list it belong to, so we give it
    # the one we found in the URL params
    @bookmark.list = @list
    if @bookmark.save
      # If the bookmark is saved, take us back to its associated list, rather than
      # the bookmark itself
      redirect_to list_path(@list)
    else
      # Reset the current instance of movies to show only those which are not
      # already present in the current list
      @movies = Movie.where.not(id: @list.movies)
      render 'new', status: :unprocessable_entity
    end
  end

  private
  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id)
  end
end
