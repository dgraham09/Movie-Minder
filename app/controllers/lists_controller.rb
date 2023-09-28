require 'json'
require 'open-uri'
require 'net/http'
require 'date'

class ListsController < ApplicationController
  def index
    today = Time.new
    api_key = "5eb2852848f013dccdd6edab04d61358"
    url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&language=en-US&page=1&primary_release_date.gte=#{today.strftime("20%y-%m-%d")}&primary_release_date.lte=#{today.year}-12-31")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZWIyODUyODQ4ZjAxM2RjY2RkNmVkYWIwNGQ2MTM1OCIsInN1YiI6IjYyZTIyZGZjMDIxY2VlMDA1NTAyYzhjNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.O0bbqdpLmsohFuhBo1Mtmb28xDpO4GP6Jutbbqv0f6Q'
    response = http.request(request)
    parsedData = JSON.parse(response.read_body)
    dataArray = parsedData["results"]
    movie_titles = []
      dataArray.each { |element| movie_titles.push({ title: element["title"], date: convert_date(element["release_date"]), poster: element["poster_path"]}) }
    @upcoming_movies = movie_titles.sort_by { |i| Date.parse i[:date] }.last(20).uniq
    @lists = List.all
    @lists.each do |list|
      list.average_rating = calculate_average_rating(list.id)
    end
  end

  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
    @movies = Movie.all
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.save
    redirect_to lists_path
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    redirect_to lists_path
  end

  def calculate_average_rating(list_id)
    ((Bookmark.joins(:movie).where(list_id: list_id).pluck(:rating).sum) / (Bookmark.joins(:movie).where(list_id: list_id).pluck(:rating).size)).round
  end

  def list_params
    params.require(:list).permit(:name, :photo)
  end

  private

  def convert_date(arr)
    date_arr = arr.split("-")
    "#{date_arr[2]}/#{date_arr[1]}/#{date_arr[0]}"
  end
end
