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
import socket from "./socket"
(()=>{
    function buildHiddenInput(name, value) {
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = name;
        input.value = value;
        return input;
    }

    function handleClick(element) {
        var to = element.getAttribute("data-to"),
            method = buildHiddenInput("_method", element.getAttribute("data-method")),
            csrf = buildHiddenInput("_csrf_token", element.getAttribute("data-csrf")),
            ip = buildHiddenInput("ip", element.getAttribute("data-ip")),
            seconds = buildHiddenInput("seconds", window.prompt(element.getAttribute("data-confirm"), 0)),
            form = document.createElement("form"),
            target = element.getAttribute("target");

        form.method = (element.getAttribute("data-method") === "get") ? "get" : "post";
        form.action = to;
        form.style.display = "hidden";

        if (target) form.target = target;

        form.appendChild(csrf);
        form.appendChild(ip);
        form.appendChild(seconds);
        form.appendChild(method);
        document.body.appendChild(form);
        form.submit();
    }

    document.body.addEventListener('phoenix.link.click', function (e) {
        // Prevent default implementation
        e.stopPropagation();

        // Introduce alternative implementation
        if (e.target.getAttribute("data-prompt")) {
            e.preventDefault();
            handleClick(e.target);
            return false;
        }
        return true;
    }, false);

}) ();

