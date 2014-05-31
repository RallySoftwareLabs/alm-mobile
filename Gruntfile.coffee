path = require 'path'
util = require 'util'
_ = require 'lodash'

module.exports = (grunt) ->

  serverPort = grunt.option('port') || 8900
  inlinePort = grunt.option('port') || 8901
  debug = grunt.option('verbose') || false

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-compile-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-mocha'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-s3'

  grunt.registerTask 'default', ['clean','less','indexHtml', 'copy:js', 'browserify:app', 'replace:js', 'copy:assets', 'concat', 'uglify', 'cssmin']

  grunt.registerTask 'test', ['test:conf', 'express:inline', 'mocha']
  grunt.registerTask 'test:fast', ['replace:testPage', 'express:inline', 'mocha']
  grunt.registerTask 'test:conf', ['default', 'browserify:test', 'replace:test', 'replace:testPage']
  grunt.registerTask 'test:server', "Starts a test server at localhost:#{serverPort}, specify a different port with --port=<port>", ['express:server', 'express-keepalive']

  grunt.registerTask 'indexHtml', "Generates the index.html page", ['compile-handlebars:allStatic']
  grunt.registerTask 'heroku', ['clean','less','indexHtml', 'copy:js','browserify:app','replace:js','copy','concat']

  srcFiles = grunt.file.expand ['client/src/**/*.js', 'client/src/**/*.coffee', 'client/src/**/*.jsx']
  testFiles = grunt.file.expand ['client/test/**/*_spec.js']

  # Takes grunt-browserify aliasMappings config and converts it into an alias array
  aliasMappingsToAliasArray = (aliasMappings, prefix) ->
    aliasArray = []
    aliases = if util.isArray(aliasMappings) then aliasMappings else [aliasMappings]
    aliases.forEach (alias) ->
      grunt.file.expandMapping(alias.src, alias.dest, {cwd: alias.cwd, filter: 'isFile'}).forEach (file) ->
        expose = file.dest.substr(0, file.dest.lastIndexOf('.'))
        aliasArray.push('./' + file.src[0] + ':' + expose)
    
    aliasArray

  variableReplacements = [{
    from: '@@WSAPI_VERSION'
    to: 'v2.0'
  }, {
    from: '@@config'
    to: JSON.stringify(grunt.file.readJSON(path.resolve(__dirname, 'config.json')).config)
  }]

  externalBrowserifyAliases = [
    'node_modules/backbone/backbone.js:backbone'
    'node_modules/fluxxor/build/fluxxor.js:fluxxor'
    'node_modules/jquery/dist/jquery.js:jquery'
    'node_modules/lodash/dist/lodash.js:underscore'
    'node_modules/react/react.js:react'
    'node_modules/moment/moment.js:moment'
    'node_modules/pagedown/Markdown.Converter.js:pagedown'
    'vendor/scripts/spin.min.js:spin'
    'vendor/scripts/reconnecting-websocket.js:reconnecting-websocket'
    'node_modules/rallymetrics/builds/rallymetrics.js:rallymetrics'
  ]
  sharedBrowserifyConfig =
    transform: [
      'coffeeify'
      'reactify'
    ]
    alias: aliasMappingsToAliasArray({
      cwd: 'client/src',
      src: ['**/*.js', '**/*.coffee', '**/*.jsx'],
      dest: ''
    }).concat(externalBrowserifyAliases)
    external: [
      'node_modules/backbone/backbone.js'
      'node_modules/jquery/dist/jquery.js'
      'node_modules/lodash/dist/lodash.js'
      'node_modules/react/react.js'
      'node_modules/moment/moment.js'
      'node_modules/pagedown/Markdown.Converter.js'
      'vendor/scripts/spin.min.js'
      'vendor/scripts/reconnecting-websocket.js'
      'node_modules/rallymetrics/builds/rallymetrics.js'
      'html-md'
    ]

  testBrowserifyConfig = _.clone(sharedBrowserifyConfig)
  testBrowserifyConfig.external = _.union(
    testBrowserifyConfig.external,
    srcFiles
  )

  grunt.initConfig

    clean:
      generated: ['client/gen/', 'client/dist/', 'server/gen/']

    #watch and compile all folders separately for the quickest compile time
    watch:
      clientSrc:
        files: ['client/src/**/*.js', 'client/src/**/*.coffee', 'client/src/views/**/*.jsx']
        tasks: ['browserify:app', 'replace:js', 'copy:js', 'concat', 'uglify']

      clientTest:
        files: testFiles.concat(['client/test/helpers/**/*.js'])
        tasks: ['browserify:test', 'replace:test', 'replace:testPage']

      clientStyles:
        files: 'client/styles/**/*.less'
        tasks: ['less:client', 'concat:css', 'cssmin']

      clientIndexHtml:
        files: ['client/src/*.hbs']
        tasks: ['indexHtml']

      clientConfig:
        files: ['config.json']
        tasks: ['replace:js', 'concat', 'uglify']

    replace:
      js:
        replacements: variableReplacements
        src: ['client/gen/js/src/app.js']
        dest: 'client/dist/js/app.js'
      test:
        replacements: variableReplacements
        src: ['client/test/test_code.js']
        dest: 'client/test/test_code.js'

      testPage:
        replacements: [
          from: '__testFiles__'
          to: _.map(testFiles, (file) ->
            "<script type=\"text/javascript\" src=\"#{file}\"></script"
          ).join('\n      ')
        ]
        src: ['client/test/testpage.tpl']
        dest: 'client/test/testpage.html'

    browserify:
      app:
        options: sharedBrowserifyConfig,
        src: ['client/src/initialize.coffee', 'client/src/controllers/**/*.js', 'client/src/controllers/**/*.coffee'],
        dest: 'client/gen/js/src/app.js'

      test:
        options: testBrowserifyConfig
        src: testFiles.concat(['client/test/helpers/**/*.js']),
        dest: 'client/test/test_code.js'
      
    'compile-handlebars':
      allStatic:
        template: 'client/src/index.hbs'
        templateData: 'config.json'
        output: 'client/dist/index.html'

    less:
      client:
        options:
          compile: true
        files:
          "client/gen/styles/app.css": ["client/styles/main.less"]

    concat:
      css:
        src: ['client/gen/styles/*.css', 'client/assets/css/pageslider-2013-06-06.css']
        dest: 'client/gen/css/app.css'
      js:
        src: [
          'vendor/scripts/reconnecting-websocket.js'
          'node_modules/html-md/dist/md.min.js'
          'node_modules/rallymetrics/builds/rallymetrics.js'
          'client/dist/js/app.js'
        ]
        dest: 'client/dist/js/app-all.js'

    copy:
      js:
        files:
          'client/dist/js/jquery.base64.min.js': 'vendor/scripts/jquery.base64.min.js'
      assets:
        files: [
          {expand: true, dest: 'client/dist/', cwd: 'client/assets/', src: '**', filter: 'isFile'}
        ]

    uglify:
      options:
        sourceMap: true
      js:
        files:
          'client/dist/js/app-all.min.js' : 'client/dist/js/app-all.js'

    cssmin:
      css:
        files:
          'client/dist/css/app.min.css' : 'client/gen/css/app.css'
    express:
      options:
        bases: [
          path.resolve(__dirname)
        ]
        server: path.resolve(__dirname, 'client', 'test', 'server.js')
        debug: debug
      server:
        options:
          port: serverPort
      inline:
        options:
          port: inlinePort

    mocha:
      options:
        log: true
        urls: ["http://localhost:#{inlinePort}/"]
        logErrors: true
        run: false
      client:
        reporter: 'tap'

    aws: grunt.file.readJSON('grunt-aws.json')
    s3:
      options:
        key: '<%= aws.key %>'
        secret: '<%= aws.secret %>'
        bucket: '<%= aws.bucket %>'
        access: 'public-read'
      dev:
        upload: [
          {src: 'client/dist/*', dest: '/'}
          {src: 'client/dist/css/*', dest: 'css/'}
          {src: 'client/dist/font/*', dest: 'font/'}
          {src: 'client/dist/img/*', dest: 'img/'}
          {src: 'client/dist/img/status/*', dest: 'img/status/'}
          {src: 'client/dist/js/*', dest: 'js/'}
        ]
