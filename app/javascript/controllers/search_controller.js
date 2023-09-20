import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  static targets = ["input", "results"]

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
        <li>
            <img src=https://image.tmdb.org/t/p/w500${result.poster_path} style="width: 300px; height: 400px; border-radius: 15px; padding:0.2em; margin: 0.25rem">
        </li>
        `
        this.resultsTarget.insertAdjacentHTML("beforeend", movieTag)
      })
    })

  }
}
