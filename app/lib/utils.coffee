
NAVIGATION_MODEL_TYPES =
  'hierarchicalrequirement': 'userstory'
  'defect': 'defect'
  'task': 'task'

module.exports =
  getDetailHash: (model) ->
    attributes = model.attributes || model
    "#{NAVIGATION_MODEL_TYPES[attributes._type.toLowerCase()]}/#{attributes.ObjectID}"