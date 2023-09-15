(function () {
  "use strict";

  var metas = document.getElementsByTagName('meta'),
      meta,
      shareData = {};
  
  for (var i = 0; i < metas.length; i += 1) {
    meta = metas[i];

    if (meta.getAttribute('property') === 'og:title') {
      shareData.title = meta.getAttribute('content');
    } else if (meta.getAttribute('property') === 'og:description') {
      shareData.text = meta.getAttribute('content').substring(0, 150);
    } else if (meta.getAttribute('property') === 'og:url') {
      shareData.url = meta.getAttribute('content');
    }
  }

  var shareButton = document.getElementById('share-button');

  if (navigator.share && shareButton) {
    shareButton.className = 'active';
    shareButton.addEventListener('click', function () {
      try {
        navigator.share(shareData);
      } catch (e) {}
    }, false);
  }


}());
