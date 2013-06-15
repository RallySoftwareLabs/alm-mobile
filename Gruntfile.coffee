module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-compile-handlebars'
  grunt.loadNpmTasks 'grunt-s3'

  grunt.registerTask 'default', ['clean','coffee','less','handlebars','compile-handlebars','requirejs','copy','concat','uglify']

  grunt.registerTask 'test', ['clean', 'coffee', 'simplemocha']

  grunt.registerTask 'heroku', ['clean','coffee','less','handlebars','compile-handlebars','requirejs','copy','concat','uglify']

  grunt.initConfig

    clean: ['client/gen/*', 'sever/gen/*']

    #watch and compile all folders separately for the quickest compile time
    watch:
      clientSrc:
        files: 'client/src/**/*.coffee'
        tasks: ['coffee:clientSrc', 'requirejs:compile', 'copy:js', 'uglify:js']

      clientStyles:
        files: 'client/styles/**/*.less'
        tasks: ['less:client', 'concat:css']

      clientTemplates:
        files: 'client/src/views/**/templates/**/*.hbs'
        tasks: ['handlebars', 'requirejs:compile', 'uglify:hbs']

      clientIndexHtml:
        files: ['config.json', 'client/src/*.hbs']
        tasks: ['compile-handlebars']

      clientTest:
        files: 'client/test/**/*.coffee'
        tasks: ['coffee:clientTest']

      serverSrc:
        files: 'server/src/**/*.coffee'
        tasks: ['coffee:serverSrc']

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

    requirejs:
      compile:
        options:
          name: 'initialize'
          paths:
            jquery: "empty:"
            bootstrap: "empty:"
            spin: "empty:"
            jqueryCookie: "empty:"
            underscore: "../../../../vendor/scripts/lodash-1.3.1"
            backbone: "empty:"
            chaplin: "../../../../vendor/scripts/chaplin-0.9.0"
            handlebars: "empty:"
            hbsTemplate: "../../../dist/js/hbs"
            appConfig: "empty:"
          shim:
            hbsTemplate:
              deps: ["backbone"]
            appConfig:
              exports: "AppConfig"
          out: 'client/dist/js/app.js'
          baseUrl: 'client/gen/js/src'
          optimize: "none"
          preserveLicenseComments: false
          findNestedDependencies: true
          useStrict: true
          wrap: true

    handlebars:
      compile:
        options:
          amd: true
          processName: (filePath, x) ->
            filePath
            pieces = filePath.split("/")
            path = pieces.splice(3).join("/")
            path.replace(/\.hbs$/, '')
        files:
          "client/dist/js/hbs.js": ["client/src/views/**/*.hbs"]
          "server/gen/templates/hbs.js": ["server/src/views/**/*.hbs"]

    'compile-handlebars':
      allStatic:
        template: 'client/src/index.hbs'
        templateData: 'config.json'
        output: 'client/dist/index.html'

    less:
      client:
        options:
          yuicompress: false

        files:
          "client/gen/styles/app.css": ["client/styles/main.less"]

    concat:

      css:
        src: ['client/gen/styles/*.css']
        dest: 'client/dist/css/app.css'

    copy:
      js:
        files:
          'client/dist/js/initialize.js': 'client/gen/js/src/initialize.js'
          'client/dist/js/bootstrap-2.3.2.js': 'vendor/scripts/bootstrap-2.3.2.js'
          'client/dist/js/lodash-1.3.1.js': 'vendor/scripts/lodash-1.3.1.js'
          'client/dist/js/require-2.1.6.js': 'vendor/scripts/require-2.1.6.js'
      assets:
        files: [
          {expand: true, dest: 'client/dist/', cwd: 'client/assets/', src: '**', filter: 'isFile'}
        ]
    uglify:
      js:
        files:
          'client/dist/js/app.min.js' : 'client/dist/js/app.js'
          'client/dist/js/initialize.min.js' : 'client/dist/js/initialize.js'
      hbs:
        files:
          'client/dist/js/hbs.min.js' : 'client/dist/js/hbs.js'

    simplemocha:
      options:
        globals: ['expect']
        ignoreLeaks: true
        timeout: 3000
        ui: 'bdd'
        reporter: 'tap'
      all:
        src: [
          'node_modules/chai/chai.js'
          'client/gen/js/test/**/*.js'
        ]

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
