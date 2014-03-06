path = require 'path'
_ = require 'lodash'

module.exports = (grunt) ->

  serverPort = grunt.option('port') || 8900
  inlinePort = grunt.option('port') || 8901
  debug = grunt.option('verbose') || false

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-compile-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-mocha'
  grunt.loadNpmTasks 'grunt-react'
  grunt.loadNpmTasks 'grunt-replace'
  grunt.loadNpmTasks 'grunt-s3'

  grunt.registerTask 'default', ['clean','coffee','react','less','compile-handlebars:allStatic', 'copy:js','requirejs','replace:js','copy:assets','concat']

  grunt.registerTask 'test', ['test:conf', 'express:inline', 'mocha']
  grunt.registerTask 'test:conf', ['clean', 'coffee', 'react', 'less', 'copy','requirejs', 'replace']
  grunt.registerTask 'test:server', "Starts a test server at localhost:#{serverPort}, specify a different port with --port=<port>", ['express:server', 'express-keepalive']

  grunt.registerTask 'heroku', ['clean','coffee','less','compile-handlebars:allStatic', 'copy:js','requirejs','replace:js','copy','concat']

  testFiles = grunt.file.expand ['client/test/**/*_spec.js']

  grunt.initConfig

    clean: ['client/gen/*', 'client/dist/*', 'sever/gen/*']

    #watch and compile all folders separately for the quickest compile time
    watch:
      clientSrc:
        files: 'client/src/**/*.coffee'
        tasks: ['coffee:clientSrc', 'requirejs:compile', 'replace:js', 'copy:js']

      reactSrc:
        files: 'client/src/views/**/*.jsx'
        tasks: ['react:clientSrc', 'requirejs:compile', 'replace:js', 'copy:js']

      clientStyles:
        files: 'client/styles/**/*.less'
        tasks: ['less:client', 'concat:css']

      clientIndexHtml:
        files: ['config.json', 'client/src/*.hbs']
        tasks: ['compile-handlebars:allStatic']

      clientTest:
        files: 'client/test/**/*.coffee'
        tasks: ['coffee:clientTest']

      serverSrc:
        files: 'server/src/**/*.coffee'
        tasks: ['coffee:serverSrc']

    replace:
      js:
        options:
          variables:
            'WSAPI_VERSION': 'v2.0'
          prefix: '@@'
          force: true
        files: [
         expand: true, flatten: true, src: ['client/gen/js/app.js'], dest: 'client/dist/js'
        ]

      testPage:
        options:
          prefix: ""
          variables: '__testFiles__': _.map(testFiles, (file) ->
            "'#{file.substring(0, file.length - 3)}'"
          ).join(',\n')
        files: [
          src: ['client/test/testpage.tpl']
          dest: 'testpage.html'
        ]

    coffee:
      clientSrc:
        expand: true
        cwd: 'client/src/'
        src: ['**/*.coffee']
        dest: 'client/gen/js/src'
        ext: '.js'

      clientTest:
        expand: true
        cwd: 'client/test/'
        src: ['**/*.coffee']
        dest: 'client/gen/js/test'
        ext: '.js'

      serverSrc:
        expand: true
        cwd: 'server/src/'
        src: ['**/*.coffee']
        dest: 'server/gen/js/src'
        ext: '.js'

    react:
      clientSrc:
        files: [
          expand: true
          ext: '.js'
          cwd: 'client/src/views'
          src: ['**/*.jsx']
          dest: 'client/gen/js/src/views'
        ]

    requirejs:
      compile:
        options:
          name: 'initialize'
          paths:
            appConfig: "empty:"
            backbone: "empty:"
            bootstrap: "empty:"
            handlebars: "empty:"
            jquery: "empty:"
            jqueryBase64: "empty:"
            md: "../../../../node_modules/html-md/dist/md.min"
            moment: "empty:"
            pagedown: "empty:"
            rallymetrics: "../../../../node_modules/rallymetrics/builds/rallymetrics"
            react: "empty:"
            spin: "empty:"
            underscore: "../../../../node_modules/lodash/dist/lodash"
          shim:
            appConfig:
              exports: "AppConfig"
          out: 'client/gen/js/app.js'
          baseUrl: 'client/gen/js/src'
          optimize: "none"
          preserveLicenseComments: false
          findNestedDependencies: true
          useStrict: true
          wrap: true

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
        src: ['client/gen/styles/*.css']
        dest: 'client/dist/css/app.css'

    copy:
      js:
        files:
          'client/dist/js/jquery.base64.min.js': 'vendor/scripts/jquery.base64.min.js'
      assets:
        files: [
          {expand: true, dest: 'client/dist/', cwd: 'client/assets/', src: '**', filter: 'isFile'}
        ]
    uglify:
      js:
        files:
          'client/dist/js/app.min.js' : 'client/dist/js/app.js'

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
        urls: ["http://localhost:#{inlinePort}/testpage.html"]
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
