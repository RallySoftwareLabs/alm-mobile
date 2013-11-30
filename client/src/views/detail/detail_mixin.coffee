define ->

  return {
    componentDidMount: ->
      @subscribeEvent 'startEdit', @onStartEdit
      @subscribeEvent 'endEdit', @onEndEdit
    onStartEdit: (view, field) ->
      view.setState editMode: true
    onEndEdit: (view, field) ->
      view.setState editMode: false if @props.model.get('ObjectID')
    onSave: -> @trigger('save', @props.model)
    onCancel: -> @trigger('cancel')
    showError: (resp, options) ->
      respObj = resp.responseJSON
      return unless respObj
      errors = (respObj.CreateResult || respObj.OperationResult)?.Errors
      $('#saveFailureModal').remove()
      $(document.body).append("""
        <div class="save-failure modal" id="saveFailureModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">An Error Occurred saving your changes</h4>
              </div>
              <div class="modal-body">
                #{errors.join("<br/>")}
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
              </div>
            </div>
          </div>
        </div>
      """)
      $('#saveFailureModal').modal('show')
  }