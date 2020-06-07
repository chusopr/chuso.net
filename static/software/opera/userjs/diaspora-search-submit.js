// ==UserScript==
// @name Diaspora Search Submit
// @author Jesus Perez (chuso) 
// @namespace http://userjs.org/
// @version 2.0
// @description  Fixes submit Diaspora search form on Enter key in Opera 11
// @ujs:category site: fixes
// @ujs:documentation http://getsatisfaction.com/diaspora/topics/search_field_not_working
// @ujs:download http://chuso.net/software/opera/userjs/diaspora-search-submit.js
// @include https://joindiaspora.com/*
// ==/UserScript==

function search_submit(evt)
{
  if (evt.keyCode == 13)
    document.getElementById("global_search_form").submit();
}

function diaspora_search_submit_main()
{
  if (document.getElementById("global_search_form") && document.getElementById('q'))
    // keypress is triggered on every autorepeat, we don't want it
    document.getElementById('q').addEventListener("keydown", search_submit, false);
}

if (location.host == "joindiaspora.com")
  window.addEventListener('load', diaspora_search_submit_main, false);
