class BookmarksController < ApplicationController
  def new
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new; @bookmark.build_movie
  end

  def create
    @list = List.find(params[:list_id])
    @movie = Movie.new(title: bookmark_params[:movie_attributes][:title], overview: bookmark_params[:movie_attributes][:overview], rating: bookmark_params[:movie_attributes][:rating])
    @movie.save!
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    @bookmark.movie = @movie
    @bookmark.save!
    redirect_to lists_path
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to lists_path
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:list_id, :comment, movie_attributes: [:overview, :rating, :title])
  end
end
