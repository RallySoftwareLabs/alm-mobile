define [
  'views/base/view'
  'hbsTemplate'
], (View, hbs) ->

  # Site view is a top-level view which is bound to body.
  class SiteView extends View
    container: 'body'
    id: 'site-container'
    regions:
      '#header': 'header'
      '#navigation': 'navigation'
      '#content': 'main'
    template: hbs['templates/site']