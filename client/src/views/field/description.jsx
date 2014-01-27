/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      React = require('react'),
      Markdown = require('pagedown'),
      utils = require('lib/utils'),
      ReactView = require('views/base/react_view'),
      FieldMixin = require('views/field/field_mixin');

  return ReactView.createBackboneClass({
    mixins: [FieldMixin],
    getDefaultProps: function() {
      return {
        field: 'Description',
        label: 'Description'
      };
    },
    render: function() {
      var fieldValue = utils.fixImageSrcs(this.getFieldValue()),
          editMode = this.isEditMode();
      return (
        <div className={ editMode ? "edit" : "display" }>
          <div className="well-title control-label">
            { this.props.label} (Edit using <a href="http://daringfireball.net/projects/markdown/syntax" target="_blank">Markdown</a>)
          </div>
          <div className="well well-sm">
            { editMode ?
              <textarea className={ "editor " + this.props.field }
                        placeholder={ this.props.field }
                        defaultValue={ utils.md(fieldValue) }
                        onBlur={ this.endEdit }
                        onKeyDown={ this._onKeyDown }/>
              :
              <div className="html-field" dangerouslySetInnerHTML={{__html: (fieldValue || '') + '&nbsp;'}} onClick={ this.startEdit }/>
            }
          </div>
        </div>
      );
    },

    _onKeyDown: function(event) {
      if (event.which === this.keyCodes.ESCAPE_KEY) {
        this._switchToViewMode();
      }
    },

    parseValue: function(value) {
      return new Markdown.Converter().makeHtml(value).replace(/(\r\n|\n|\r)/gm,"");
    }
  });
});