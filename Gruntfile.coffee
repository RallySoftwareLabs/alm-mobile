path = require 'path'
util = require 'util'
_ = require 'lodash'

module.exports = (grunt) ->

  serverPort = grunt.option('port') || 8900
  inlinePort = grunt.option('port') || 8901
  debug = grunt.option('verbose') || false

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
  grunt.loadNpmTasks 'grunt-debug-task'
  grunt.loadNpmTasks 'grunt-webpack'

  grunt.registerTask 'default', ['clean','less','indexHtml', 'copy:js', 'webpack:app', 'replace:js', 'copy:assets', 'concat']

  grunt.registerTask 'test', ['test:conf', 'express:inline', 'mocha']
  grunt.registerTask 'test:fast', ['replace:testPage', 'express:inline', 'mocha']
  grunt.registerTask 'test:conf', ['default', 'replace:test', 'replace:testPage']
  grunt.registerTask 'test:server', "Starts a test server at localhost:#{serverPort}, specify a different port with --port=<port>", ['express:server', 'express-keepalive']

  grunt.registerTask 'indexHtml', "Generates the index.html page", ['compile-handlebars:allStatic']
  grunt.registerTask 'heroku', ['clean','less','indexHtml', 'copy:js','replace:js','copy','concat']

  srcFiles = grunt.file.expand ['client/src/**/*.js', 'client/src/**/*.coffee', 'client/src/**/*.jsx']
  testFiles = grunt.file.expand ['client/test/**/*_spec.js']

  variableReplacements = [{
    from: '@@WSAPI_VERSION'
    to: 'v2.0'
  }, {
    from: '@@config'
    to: JSON.stringify(grunt.file.readJSON(path.resolve(__dirname, 'config.json')).config)
  }]

  grunt.initConfig

    clean:
      generated: ['client/gen/', 'client/dist/', 'server/gen/']

    #watch and compile all folders separately for the quickest compile time
    watch:
      clientSrc:
        files: ['client/src/**/*.js', 'client/src/**/*.coffee', 'client/src/views/**/*.jsx']
        tasks: ['webpack:app', 'replace:js', 'copy:js']

      clientTest:
        files: testFiles.concat(['client/test/helpers/**/*.js'])
        tasks: ['replace:test', 'replace:testPage']

      clientStyles:
        files: 'client/styles/**/*.less'
        tasks: ['less:client']

      clientIndexHtml:
        files: ['client/src/*.hbs']
        tasks: ['indexHtml']

      clientConfig:
        files: ['config.json']
        tasks: ['replace:js']

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

    webpack:
      app: require('./webpack.config.js')
      
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
          "client/dist/css/app.css": ["client/styles/main.less"]

    concat:
      js:
        src: [
          'vendor/scripts/reconnecting-websocket.js'
          'node_modules/html-md/dist/md.min.js'
          'node_modules/rallymetrics/builds/rallymetrics.js'
          'node_modules/fluxxor/build/fluxxor.js'
        ]
        dest: 'client/dist/js/app-deps.js'

    copy:
      js:
        files:
          'client/dist/js/jquery.base64.min.js': 'vendor/scripts/jquery.base64.min.js'

      assets:
        files: [
          {expand: true, dest: 'client/dist/', cwd: 'client/assets/', src: '**', filter: 'isFile'},
          {expand: true, dest: 'client/dist/', cwd: 'client/assets/img', src: 'favicon.ico', filter: 'isFile'}
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
          'client/dist/css/app.min.css' : 'client/dist/css/app.css'
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
