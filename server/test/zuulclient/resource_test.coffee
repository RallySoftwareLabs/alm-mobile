require '../../../server/src/zuulclient/resource'

describe 'zuulclient.resource', ->
  it 'parses a valid resource', ->
    expectedType = 'key'
    expectedId = 'abc123'
    resource = new Resource(
      _ref: "/#{expectedType}/#{expectedId}.js"
    )
    expect(resource.getType()).to.be expectedType
    expect(resource.getId()).to.be expectedId