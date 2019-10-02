// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

// show field for singer 2 and 3 upon button press
document.getElementById("singer2button").addEventListener("click", function(){
    document.getElementById("singer2").style.display = "flex";
    this.style.visibility = "hidden";
}); 
document.getElementById("singer3button").addEventListener("click", function(){
    document.getElementById("singer3").style.display = "flex";
    this.style.visibility = "hidden";
}); 