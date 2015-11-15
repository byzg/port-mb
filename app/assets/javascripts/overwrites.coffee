$ ->
  $('body').bind 'DOMSubtreeModified', ->
    if ($body = $('body.mfp-zoom-out-cur')).length > 0
      $body.find('button.mfp-close').attr('title', 'Закрыть (Esc)')

      $('body').unbind 'DOMSubtreeModified'