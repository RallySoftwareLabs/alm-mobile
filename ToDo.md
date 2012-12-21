### To Do

- Modularize routes and have routes.coffee build itself from said modules
- Search for artifacts
- Allow logout
- Fix redirect to login page on failed WS call (conditional redirect on 401 in backbone_mods) I broke this in b479209d5b8eefa79dccdd5e3b202d1b3a7594e7
- Remember which home page tab we were on when we come back
- Determine who we are: request user info - Detail page claim
- Dispose of old views - evident when navigating to more than one detail page then trying to inline edit