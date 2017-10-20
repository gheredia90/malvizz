// Función que lanzamos al inicio de la carga
function load() {

    // Dataset inicial
  $.get({
    url: '/dataset',
    dataType: 'json',
    success: function(data) {
      paintData(data.samples);
    }
  });

function paintData(samples) {

    function getRandomInt(min, max) {
      return Math.floor(Math.random() * (max - min)) + min;
    }

    var cores = []; // Núcleos de los clusters
    var width = 1000; // Anchura
    var height = 600; // Altura
    var padding = 25; // Padding
    var processed = 0; // Elementos procesados
    var measure = Math.sqrt(2)*14

    var svg = d3.select("#chart").append("svg").attr("width", width + padding * 2).attr("height", height + padding * 2).append("g").attr("transform", "translate(" + padding + "," + padding + ")");
    var xScale = d3.scale.linear().range([0, width]).domain([0, measure]);
    var yScale = d3.scale.linear().range([height, 0]).domain([0, measure]);
    var xAxis = d3.svg.axis().scale(xScale).orient("bottom").tickSize(0).tickFormat("");
    var yAxis = d3.svg.axis().scale(yScale).orient("left").tickSize(0).tickFormat("");
    function brushended() {
      var s = d3.event.selection;
      if (!s) {
        if (!idleTimeout) return idleTimeout = setTimeout(idled, idleDelay);
        x.domain(x0);
        y.domain(y0);
      } else {
        x.domain([s[0][0], s[1][0]].map(x.invert, x));
        y.domain([s[1][1], s[0][1]].map(y.invert, y));
        svg.select(".brush").call(brush.move, null);
      }
      zoom();
    }
    var brush = d3.brush().on("end", brushended),
    idleTimeout,
    idleDelay = 350;


    samples.forEach(function(d, i, a) {
      var label = d.cluster_malheur_id;
      var isCoreCluster = false;
      var point = null;
      var distance = d.distance;
      var prototype = d.prototype;
      var drawLine = false;
      var coreParent = null;

      if (prototype) {
        point = {
          'x': getRandomInt(0, measure - 1),
          'y': getRandomInt(0, measure - 1)
        };

        core = {
          'label': label,
          'x': point.x,
          'y': point.y,
          'children': 0
        };

        cores.push(core);
        isCoreCluster = true;
      } else {
        cores.filter(function(core) {
          if (core.label == label) {
            point = {
              'x': core.x + distance * Math.cos(core.children),
              'y': core.y + distance * Math.sin(core.children)
            };
            core.children++;
            drawLine = true;
            coreParent = {
              'x': core.x,
              'y': core.y
            }
          } else {

          }
        });
      }

      if (drawLine) {
        svg.append("line").attr("x1", xScale(coreParent.x)).attr("y1", yScale(coreParent.y)).attr("x2", xScale(point.x)).attr("y2", yScale(point.y)).attr("stroke-width", 1).attr("stroke", "black");
      }

      var colour = isCoreCluster ?
        'red' :
        'green';
      svg.append("circle").attr("fill", colour).attr("cx", function() {
        return xScale(point.x);
      }).attr("cy", function() {
        return yScale(point.y);
      }).attr("r", 5);

      // Comprobamos si se han procesado todos los datos
      processed++;
      if (processed === a.length) {
        callback();
      }
    });

    // Función para dibujar elementos extras
    function callback() {
      // Preparamos la ruta para la línea del valor neto
      var lineNetWorth = d3.svg.line().x(function(d) {
        return xScale(d[0]);
      }).y(function(d) {
        return yScale(d[0]);
      });

      // Preparamos la ruta para la línea de la experiencia
      var lineExperience = d3.svg.line().x(function(d) {
        return xScale(d[0]);
      }).y(function(d) {
        return yScale(d[0]);
      });
    }

    // Añadimos el eje X
    svg.append("g").attr("class", "axis").attr("transform", "translate(0," + height + ")").call(xAxis);

    // Añadimos el eje Y
    svg.append("g").attr("class", "axis").call(yAxis);
  }

}
