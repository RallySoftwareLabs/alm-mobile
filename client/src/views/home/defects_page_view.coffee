define ->
  HomeView = require 'views/home/home_view'
  DefectsView = require 'views/home/defects_view'

  class DefectsPageView extends HomeView
    listView: DefectsView
    createRoute: 'new/defect'
