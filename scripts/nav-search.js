function toggleNavSearch(delay) {
    if (!toggleNavSearch.timerId) {
        toggleNavSearch.timerId = setTimeout(function () {
            var t = document.getElementById('search-form').getBoundingClientRect().top;
            if (t <= 0 || t >= 500) {
                document.getElementById('nav-search').style.visibility = 'visible';
            } else {
                document.getElementById('nav-search').style.visibility = 'hidden';
            }
            toggleNavSearch.timerId = null;
        }, parseInt(delay) || 200);
    }
}
  window.addEventListener('scroll', toggleNavSearch, false);
  window.addEventListener('resize', toggleNavSearch, false);
  toggleNavSearch(5);
        
