define ->
  return (match) ->
    match '', 'home#show'
    match 'userstories', 'home#userstories'
    match 'defects', 'home#defects'
    match 'tasks', 'home#tasks'

    match 'login', 'auth#login'
    match 'logout', 'auth#logout'
    match 'labsNotice', 'auth#labsNotice'

    match 'navigation', 'navigation#show'
    match 'settings', 'settings#show'
    match 'settings/board', 'settings#board'
    match ':type/:id/discussion', 'discussion#show'
    match 'userstory/:id', 'user_story_detail#show'
    match 'defect/:id', 'defect_detail#show'
    match 'task/:id', 'task_detail#show'
    match 'new/userstory', 'user_story_detail#create'
    match 'new/task', 'task_detail#create'
    match 'new/defect', 'defect_detail#create'
    match 'board', 'board#index'
    match 'board/:column', 'board#column'
    match 'recentActivity', 'recent_activity#show'
