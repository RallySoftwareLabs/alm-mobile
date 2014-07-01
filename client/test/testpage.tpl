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
  
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"></script>
  <script type="text/javascript" src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.2/backbone.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/react/0.10.0/react-with-addons.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/pagedown/1.0/Markdown.Converter.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/spin.js/1.3.3/spin.min.js"></script>
  <script type="text/javascript" src="client/dist/js/jquery.base64.min.js"></script>

  <script src="node_modules/mocha/mocha.js"></script>
  <script>
    mocha.setup('bdd');
    mocha.checkLeaks();
    mocha.globals(['jQuery']);
  </script>

  <script type="text/javascript" src="client/dist/js/app-deps.js"></script>
  <script type="text/javascript" src="client/dist/js/app.js"></script>
  <script type="text/javascript" src="client/test/test_code.js"></script>

  <script type="text/javascript">
    $(document).ready(function() {
      mocha.run();
    });
  </script>
</body>
</html>