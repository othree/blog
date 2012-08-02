function toggleNavSearch(delay) {
    if (!toggleNavSearch.timerId) {
        toggleNavSearch.timerId = setTimeout(function () {
            if (document.getElementById('search-form').getBoundingClientRect().top <= 0) {
                document.getElementById('nav-search').style.visibility = 'visible';
            } else {
                document.getElementById('nav-search').style.visibility = 'hidden';
            }
            toggleNavSearch.timerId = null;
        }, parseInt(delay) || 200);
    }
}
  window.addEventListener('scroll', toggleNavSearch, false);
  toggleNavSearch(5);
        
