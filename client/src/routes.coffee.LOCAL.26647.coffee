define ->
  return (match) ->
    match '', 'board#index'
    match 'board', 'board#index'
    match 'board/:column', 'board#column'
    match 'board/:column/userstory/new', 'user_story_detail#storyForColumn'

    match 'wall', 'wall#index'
    
    match 'userstories', 'home#userstories'
    match 'defects', 'home#defects'
    match 'tasks', 'home#tasks'

    match 'userstory/:id', 'user_story_detail#show'
    match 'userstory/:id/children', 'associations#childrenForStory'
    match 'userstory/:id/children/new', 'user_story_detail#childForStory'
    match 'userstory/:id/defects', 'associations#defectsForStory'
    match 'userstory/:id/defects/new', 'defect_detail#defectForStory'
    match 'userstory/:id/tasks', 'associations#tasksForStory'
    match 'userstory/:id/tasks/new', 'task_detail#taskForStory'
    match 'defect/:id', 'defect_detail#show'
    match 'defect/:id/tasks', 'associations#tasksForDefect'
    match 'defect/:id/tasks/new', 'task_detail#taskForDefect'
    match 'task/:id', 'task_detail#show'

    match 'new/userstory', 'user_story_detail#create'
    match 'new/task', 'task_detail#create'
    match 'new/defect', 'defect_detail#create'

    match 'login', 'auth#login'
    match 'logout', 'auth#logout'
    match 'labsNotice', 'auth#labsNotice'

    match 'navigation', 'navigation#show'

    match 'settings', 'settings#show'
    match 'settings/board', 'settings#board'

    match ':type/:id/discussion', 'discussion#show'

    match 'recentActivity', 'recent_activity#show'

    match 'search', 'search#search'
    match 'search/:keywords', 'search#search'