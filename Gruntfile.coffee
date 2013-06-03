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

  grunt.registerTask 'default', ['clean','coffee','less','handlebars','requirejs','copy','concat','uglify']

  grunt.registerTask 'test', ['clean', 'coffee', 'simplemocha']

  grunt.registerTask 'heroku', ['clean','coffee','less','handlebars','requirejs','copy','concat','uglify']

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
        files: 'client/views/**/templates/*.hbs'
        tasks: ['handlebars', 'uglify:hbs']

      clientTest:
        files: 'client/test/**/*.coffee'
        tasks: ['coffee:clientTest']

      serverSrc:
        files: 'server/src/**/*.coffee'
        tasks: ['coffee:serverSrc']

      serverTest:
        files: 'server/test/**/*.coffee'
        tasks: ['coffee:serverTest']


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

      serverTest:
        expand: true
        cwd: 'server/test/'
        src: ['**/*.coffee']
        dest: 'server/gen/js/test'
        ext: '.js'
      
    requirejs:
      compile:
        # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
        options:
          name: 'initialize'
          shim:
            backbone:
              deps: ["underscore", "jquery"]
              exports: "Backbone"
            underscore:
              exports: "_"
          paths:
            spin: "../../../../vendor/scripts/spin-1.2.7"
            jquery: "../../../../vendor/scripts/jquery-2.0.2"
            underscore: "../../../../vendor/scripts/lodash-1.2.1"
            backbone: "../../../../vendor/scripts/backbone-1.0.0"
          out: 'client/dist/js/app.js'
          baseUrl: 'client/gen/js/src'
          optimize: "none"
          preserveLicenseComments: false
          useStrict: true
          wrap: true

    handlebars:
      compile:
        options:
          processName: (filePath, x) ->
            # console.log(JSON.stringify(filePath, x))
            filePath
            pieces = filePath.split("/")
            path = pieces.splice(3).join("/")
            path.replace(/\.hbs$/, '')
        files:
          "client/dist/js/hbs.js": ["client/src/views/**/*.hbs"]
          "server/gen/js/templates/hbs.js": ["server/src/views/**/*.hbs"]

    less:
      client:
        options:
          yuicompress: false

        files:
          "client/gen/styles/app.css": [
            "vendor/styles/bootstrap/bootstrap.less"
            "client/styles/main.less"
          ]

    concat:
      vendor:
        src: [
          'vendor/scripts/require-2.1.6.js',
          'vendor/scripts/jquery-2.0.2.js',
          'vendor/scripts/jquery-cookie.js',
          'vendor/scripts/jquery.base64.js',
          # 'vendor/scripts/spin-1.2.7.js', # included in app.js by requirejs
          'vendor/scripts/handlebars.runtime-1.0.0-rc.4.js',
          'vendor/scripts/console-helper.js',
          # 'vendor/scripts/lodash-1.2.1.js',
          'vendor/scripts/backbone-1.0.0.js',
          'vendor/scripts/chaplin-0.9.0.js',
          'vendor/scripts/backbone-before-all-filter.js',
          # 'vendor/scripts/backbone-mediator.js',

          # Twitter Bootstrap jquery plugins
          'vendor/scripts/bootstrap/bootstrap-transition.js',
          'vendor/scripts/bootstrap/bootstrap-alert.js',
          'vendor/scripts/bootstrap/bootstrap-button.js',
          'vendor/scripts/bootstrap/bootstrap-carousel.js',
          'vendor/scripts/bootstrap/bootstrap-collapse.js',
          'vendor/scripts/bootstrap/bootstrap-dropdown.js',
          'vendor/scripts/bootstrap/bootstrap-modal.js',
          'vendor/scripts/bootstrap/bootstrap-scrollspy.js',
          'vendor/scripts/bootstrap/bootstrap-tooltip.js',
          'vendor/scripts/bootstrap/bootstrap-popover.js',
          'vendor/scripts/bootstrap/bootstrap-tab.js',
          'vendor/scripts/bootstrap/bootstrap-typeahed.js',
          'vendor/scripts/bootstrap/bootstrap-affix.js'
        ]
        dest: 'client/dist/js/vendor.js'

      css:
        src: ['client/gen/styles/*.css']
        dest: 'client/dist/css/app.css'

    copy:
      js:
        files:
          'client/dist/js/initialize.js': 'client/gen/js/src/initialize.js'
          'client/dist/js/lodash-1.2.1.js': 'vendor/scripts/lodash-1.2.1.js'
      assets:
        files: [
          {expand: true, dest: 'client/dist/', cwd: 'client/assets/', src: '**', filter: 'isFile'}
        ]
    uglify:
      js:
        files:
          'client/dist/js/vendor.min.js' : 'client/dist/js/vendor.js'
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
          'server/gen/js/test/**/*.js'
        ]
