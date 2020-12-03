/* global $ ClipboardJS */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('@fortawesome/fontawesome-free/js/all')
require('bootstrap/dist/js/bootstrap')

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

document.addEventListener('turbolinks:load', function () {
  $('[data-toggle="tooltip"]').tooltip()

  function setTooltip (e, message) {
    $(e.trigger).tooltip('hide')
      .tooltip({
        trigger: 'manual',
        placement: 'bottom',
        title: message
      })
      .tooltip('show')
  }

  function hideTooltip (e) {
    setTimeout(function () {
      $(e.trigger).tooltip('hide')
    }, 1000)
  }

  const clipboard = new ClipboardJS('.btn')
  clipboard.on('success', function (e) {
    e.clearSelection()
    setTooltip(e, 'Copied!')
    hideTooltip(e)
  })

  clipboard.on('error', function (e) {
    setTooltip(e, 'Failed!')
    hideTooltip(e)
  })

  window.addServer = function (name, ip) {
    window.location = 'minecraft://?addExternalServer=' + encodeURIComponent(name) + '|' + ip
  }
})
