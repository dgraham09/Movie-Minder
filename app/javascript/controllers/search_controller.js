import { Controller } from '@hotwired/stimulus'



export default class extends Controller {

  static targets = ["input", "results", "movie"]

  static values = {
    apiKey: String,
    movieName: String,
  }

  connect() {
  }

  searchMovies() {
    const searchTitle = document.getElementById("search-result-title")
    searchTitle.style.display = "block";
    fetch(`https://api.themoviedb.org/3/search/movie?query=${this.inputTarget.value}&api_key=${this.apiKeyValue}`)
    .then(response => response.json())
    .then((data) =>{
      this.resultsTarget.innerHTML = ''
      data.results.forEach((result) => {
        const movieTag = `
        <li class="movie-item" data-movie-name="${result.title}" data-movie-overview="${result.overview}" data-rating="${result.vote_average}">
            <img src=https://image.tmdb.org/t/p/w500${result.poster_path} style="width: 300px; height: 400px; border-radius: 15px; padding:0.2em; margin: 0.25rem">
            <button class="info-button" data-action="click->search#openModal">Learn more</button>
            </li>
            `
            this.resultsTarget.insertAdjacentHTML("beforeend", movieTag)
          })
        })

      }

  openModal() {
    const modal = document.getElementById("movieModal")
    const movieItem = document.querySelector(".movie-item")
    const typed = new Typed(modal.querySelector(".modal-body"), {
      strings:[`"${movieItem.dataset.movieOverview}`],
      typeSpeed: 15,
      showCursor: false,
    })
    modal.querySelector(".modal-title").textContent = movieItem.dataset.movieName
    modal.querySelector(".modal-rating").textContent = Math.round(movieItem.dataset.rating)
    modal.style.display = "block"
  }

  closeModal() {
    const modal = document.getElementById("movieModal")
    modal.style.display = "none"

  }
}
