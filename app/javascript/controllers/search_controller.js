import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  static targets = ["input", "results", "movie"]

  static values = {
    apiKey: String
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
        <li class="movie-item">
            <img src=https://image.tmdb.org/t/p/w500${result.poster_path} style="width: 300px; height: 400px; border-radius: 15px; padding:0.2em; margin: 0.25rem">
            <button class="info-button" data-action="click->search#toggleModal">Learn more</button>
        </li>
        `
        this.resultsTarget.insertAdjacentHTML("beforeend", movieTag)
      })
    })

  }

  toggleModal() {
    console.log("This is connected")
    const modal = document.getElementById("movieModal")
    modal.style.display = "block"
  }
}
