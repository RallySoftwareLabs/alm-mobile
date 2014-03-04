<html>
<head>
  <meta charset="utf-8">
  <title>Mocha Tests</title>
  <link rel="stylesheet" href="node_modules/mocha/mocha.css" />
</head>
<body>
  <div id="mocha"></div>
  <script type="text/javascript">
    (function() {

    var Ap = Array.prototype;
    var slice = Ap.slice;
    var Fp = Function.prototype;

    if (!Fp.bind) {
      // PhantomJS doesn't support Function.prototype.bind natively, so
      // polyfill it whenever this module is required.
      Fp.bind = function(context) {
        var func = this;
        var args = slice.call(arguments, 1);

        function bound() {
          var invokedAsConstructor = func.prototype && (this instanceof func);
          return func.apply(
            // Ignore the context parameter when invoking the bound function
            // as a constructor. Note that this includes not only constructor
            // invocations using the new keyword but also calls to base class
            // constructors such as BaseClass.call(this, ...) or super(...).
            !invokedAsConstructor && context || this,
            args.concat(slice.call(arguments))
          );
        }

        // The bound function must share the .prototype of the unbound
        // function so that any object created by one constructor will count
        // as an instance of both constructors.
        bound.prototype = func.prototype;

        return bound;
      };
    }

    })();
  </script>
  <script type="text/javascript" src="node_modules/requirejs/require.js"></script>
  <script type="text/javascript">
    require.config({
      baseUrl: "",
      paths: {
        "jqueryBase64": "/client/dist/js/jquery.base64.min",
        "bootstrap": "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min",
        "backbone": "//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.0/backbone",
        "spin": "//cdnjs.cloudflare.com/ajax/libs/spin.js/1.3.3/spin.min",
        "moment": "//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment.min",
        "pagedown": "//cdnjs.cloudflare.com/ajax/libs/pagedown/1.0/Markdown.Converter.min",
        "react": "//cdnjs.cloudflare.com/ajax/libs/react/0.9.0/react",
        "chai": "/node_modules/chai/chai",
        "sinon": "/node_modules/sinon/pkg/sinon",
        "sinon-chai": "/node_modules/sinon-chai/lib/sinon-chai"
      },
      shim: {
        sinon: {
          exports: "sinon"
        },
        jquery: {
          exports: "$"
        },
        backbone: {
          deps: ["underscore", "jquery"],
          exports: "Backbone"
        },
        bootstrap: {
          deps: ["jquery"]
        },
        jqueryBase64: {
          deps: ["jquery"]
        },
        spin: {
          deps: ["jquery"]
        },
        moment: {
          exports: "moment"
        },
        md: {
          exports: "md"
        },
        pagedown: {
          exports: "Markdown"
        }
      },
      waitSeconds: 15
    });

    define('appConfig', function() {
      return {
      };
    });
  </script>

  <script src="node_modules/jquery/dist/jquery.js"></script>
  <script src="node_modules/mocha/mocha.js"></script>
  <script>
    mocha.setup('bdd');
    mocha.checkLeaks();
    mocha.globals(['jQuery']);
  </script>

  <!-- Src files -->
  <script src="client/dist/js/app.js"></script>
  
  <script>
    <!-- Test files -->
    require([
      'client/test/helpers/spec_helper',
      __testFiles__
    ], function() {
      mocha.run();
    });
  </script>
</body>
</html>