var express = require('express');
var mysql = require('./dbcon.js');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});
var bodyParser = require('body-parser');

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 5555);

app.use(bodyParser.urlencoded( {extended: false}));
app.use(bodyParser.json());
app.use(express.static('public'));

var focusFilterID = 1;
//var genreFilterID = "Comedy";


/************************ RENDER HOME PAGE ****************************/
// get info for tables and forms
app.get('/',function(req,res,next){
  var context = {};
  console.log("hello");

//this displays the genres but repeats the movies if there are more than one genre
/*
  var genQuery = "SELECT m.movie_id, m.title, m.release_year, m.description, m.rating, " +
		"d.dir_fname, d.dir_lname, b.gid FROM movies m " +
		 "INNER JOIN directors d ON m.fk_dir_id = d.dir_id " +
		 "INNER JOIN belong b ON b.b_mid = m.movie_id"; 
*/

  /********** SELECT MOVIES *********/
  var genQuery = "SELECT m.movie_id, m.title, m.release_year, m.description, m.rating, " +
		"d.dir_fname, d.dir_lname FROM movies m " +
		"INNER JOIN directors d ON m.fk_dir_id = d.dir_id " +
		"ORDER BY m.title ASC";
  
  mysql.pool.query(genQuery, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var movieList = [];
    var movieCount = rows.length;
    // get each element to display in the table
    for(var mov in rows){
      var movie = { 'movie_id': rows[mov].movie_id,
                    'title': rows[mov].title,
                    'release_year': rows[mov].release_year,
                    'description': rows[mov].description,
                    'rating': rows[mov].rating,
                    'dir_name': rows[mov].dir_fname + " " + rows[mov].dir_lname};
		    //'genre_type': rows[mov].gid};

      movieList.push(movie);
      //console.log(movie);
    } 
    context.movies = movieList;
  //}); //genQuery
//I was trying to get each movies genres to show up...
/*  
  //get movies filtered by genre
  var genreFilterID = 1;
  //var genreFilterID = "Comedy";
  var FilterMovies = "SELECT m.movie_id, m.title, m.release_year, m.description, m.rating, " +
                     "d.dir_fname, d.dir_lname FROM belong b " +
                     "INNER JOIN movies m ON m.movie_id = b.b_mid " +
                     "INNER JOIN directors d ON m.fk_dir_id = d.dir_id " +
                     "WHERE b.gid = " + genreFilterID + ";";

  //var FilterDiets = "SELECT diet_name, diet_type, description FROM diet " +
  //                  "WHERE diet_focus = " + focusFilterID + ";";
  mysql.pool.query(FilterMovies, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var genreFilterMovies = [];
    // get each element we want to display in the table
    for(var m in rows){
        var genFilter = { 'movie_id': rows[m].movie_id,
                          'title': rows[m].title,
                          'release_year': rows[m].release_year,
                          'description': rows[m].description,
                          'rating': rows[m].rating,
                          'dir_name': rows[m].dir_fname + " " + rows[m].dir_lname};

        genreFilterMovies.push(genFilter);
        console.log(genFilter);
    }
    context.genreFilterMovies = genreFilterMovies;
    console.log(context.genreFilterMovies);
  });
*/
  /******** SELECT ACTORS ********/
  var actors = "SELECT * FROM actors;";
  mysql.pool.query(actors, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var actorsList = [];
    // get each element to display in the table
    for(var a in rows){
        var actor = { 'actor_id': rows[a].actor_id,
                      'actor_name': rows[a].actor_fname + " " + rows[a].actor_lname,
		      'actor_gender': rows[a].actor_gender,
		      'actor_dob': rows[a].actor_dob};
        actorsList.push(actor);
    }
    context.actors = actorsList;
    //console.log(context.actorsList);
  //});

  /******** SELECT DIRECTORS *********/
  var directors = "SELECT * FROM directors;";
  mysql.pool.query(directors, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var dirList = [];
    // get each element to display in the table
    for(var d in rows){
        var director = { 'dir_id': rows[d].dir_id,
                      	 'dir_name': rows[d].dir_fname + " " + rows[d].dir_lname,
		      	 'dir_gender': rows[d].dir_gender,
		      	 'dir_dob': rows[d].dir_dob};
        dirList.push(director);
    }
    context.directors = dirList;
    //console.log(context.dirList);
  //});

  /******** SELECT GENRES ********/
  var genres = "SELECT *  FROM genres;";
  mysql.pool.query(genres, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var allGenres = [];
    // get each element to display in the table
    for(var gen in rows){
        var genre = { 'genre_type': rows[gen].genre_type};
        allGenres.push(genre);
    }
    context.genres = allGenres;
    //console.log(context.genres);

    /******** RENDER HOME PAGE ********/
    console.log("home page stuff...");
    console.log(context);
    
    res.render('home', context);
  })})})})  //CALLBACK HELL!!!!!! Without nesting the functions the tables don't populate
	    //everytime bc the page renders before the function returns...
	    //Next time be smarter and put these in separate functions 
    
    //res.render('home', context);
  //});
});

/*********************** VIEW A MOVIES' GENRE(S) **************************/
app.get('/movieGenres',function(req,res,next){
  var context = {};
  var movieID = req.query.movieID;
  /*** SELECT MOVIES ***/
  var movQuery = "SELECT m.movie_id, m.title, m.release_year, m.description, m.rating, " +
                "d.dir_fname, d.dir_lname FROM movies m " +
                "INNER JOIN directors d ON m.fk_dir_id = d.dir_id "+
                "WHERE m.movie_id = " + movieID;
  mysql.pool.query(movQuery, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var movList = [];
    var movCount = 0;

   // get each element to display in the table
   for(var mov in rows){
      var movie = { 'movie_id': rows[mov].movie_id,
                    'title': rows[mov].title,
                    'release_year': rows[mov].release_year,
                    'description': rows[mov].description,
                    'rating': rows[mov].rating,
                    'dir_name': rows[mov].dir_fname + " " + rows[mov].dir_lname};
       movList.push(movie);
       movCount++;
    }
    context.movie = movList;

  });
  /*** SELECT GENRES BELONGING TO MOVIE ***/
  var gQuery = "SELECT g.genre_type FROM genres g " +
		"INNER JOIN belong b ON g.genre_type = b.gid " +
		"INNER JOIN movies m ON b.b_mid = m.movie_id " +
		"WHERE m.movie_id = " + movieID + ";";
  mysql.pool.query(gQuery, focusFilterID, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var genres = [];
    for(var g in rows){
        var genre = { 'genre_type': rows[g].genre_type };
        genres.push(genre);
	}
    context.genres = genres;
    console.log(context);
    res.render('movieGenres', context);
  });

});

/******************** VIEW AN ACTOR'S CHARACTERS/ROLES ************************/
app.get('/movieChars',function(req,res,next){
  var context = {};
  var actorID = req.query.actorID;
 /*** SELECT ACTORS ***/
  var movQuery = "SELECT a.actor_id, a.actor_fname, a.actor_lname, a.actor_gender, " +
                "a.actor_dob FROM actors a " +
                "WHERE a.actor_id = " + actorID;
  mysql.pool.query(movQuery, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var actorList = [];
    var actorCount = 0;
   // get each element to display in the table
   for(var a in rows){
      var actor = { 'actor_id': rows[a].actor_id,
                    'actor_name': rows[a].actor_fname + " " + rows[a].actor_lname,
                    'actor_gender': rows[a].actor_gender,
                    'actor_dob': rows[a].actor_dob};
       actorList.push(actor);
       actorCount++;
    }
    context.actor = actorList;

  });

  /*** SELECT MOVIE TITLES AND CHAR NAMES FOR THAT ACTOR ***/
  var cQuery =  "SELECT m.title, c.char_name FROM is_in c " +
                "INNER JOIN actors a ON c.aid = a.actor_id " +
                "INNER JOIN movies m ON c.mid = m.movie_id " +
                "WHERE a.actor_id = " + actorID + ";";
  mysql.pool.query(cQuery, focusFilterID, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }
    var chars = [];
    for(var c in rows){
        var char = { 'movie_title': rows[c].title,
		     'char_name': rows[c].char_name};
        chars.push(char);
        }
    context.chars = chars;
    console.log(context);
    res.render('movieChars', context);
  });

});

/********************** FILTER MOVIES BY GENRE ****************************/
app.get('/moviesByGenre',function(req,res,next){
  var context = {};
  var genreFilterID = req.query.genreFilter;
  context.genreFilterID = genreFilterID;   

  /*** SELECT GENRES ***/
  var allgenres = "SELECT * FROM genres;";
  mysql.pool.query(allgenres, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var genres = [];
    for(var g in rows){
        var gen = { 'genre_type': rows[g].genre_type};
        genres.push(gen);
    }
    context.genres = genres;
    console.log(context.genres);
  });

  /*** SELECT MOVIES IN THAT GENRE ***/
  var FilterMovies = "SELECT m.movie_id, m.title, m.release_year, m.description, m.rating, " +
		     "d.dir_fname, d.dir_lname FROM belong b " +
                     "INNER JOIN movies m ON m.movie_id = b.b_mid " +
		     "INNER JOIN directors d ON m.fk_dir_id = d.dir_id " +
                     "WHERE b.gid = " + "'" + genreFilterID + "'" + ";";
  mysql.pool.query(FilterMovies, function(err, rows, fields){
    if(err){
      next(err);
      return;
    }

    var genreFilterMovies = [];
    for(var m in rows){
      var genFilter = { 'movie_id': rows[m].movie_id,
                    	'title': rows[m].title,
                    	'release_year': rows[m].release_year,
                    	'description': rows[m].description,
                    	'rating': rows[m].rating,
                    	'dir_name': rows[m].dir_fname + " " + rows[m].dir_lname};

        genreFilterMovies.push(genFilter);
        console.log(genFilter);
    }
    context.genreFilterMovies = genreFilterMovies;
    console.log(context.genreFilterMovies);
  //});
    //res.redirect('back');
    res.render('genreFilter', context);
  });
});


/********************** ADD MOVIE TO DATABASE *****************************/
app.get('/insertMovie',function(req,res,next){
  var context = {};
  var addAthQuery = "INSERT INTO movies (title, release_year, description, rating, " +
                    "fk_dir_id) " + "VALUES (?, ?, ?, ?, ?)"
  mysql.pool.query(addAthQuery, [req.query.title, req.query.release_year, req.query.description,
                                 req.query.rating, req.query.fk_dir_id], function(err, result){
    if(err){
      next(err);
      return;
    }

    //res.redirect('back');
    setTimeout(function() {res.redirect('/');},50);
    //res.render('home');
    //res.render('home', context);
  });
});

/******************  ADD GENRE(S) TO MOVIE (ADD TO BELONG RELATIONSHIP) *******************/
app.get('/addBelong', function(req,res,next){
  var context = {};
  var belongquery = "INSERT INTO belong (b_mid, gid) VALUES (?, ?)";
  mysql.pool.query(belongquery, [req.query.movieTitle, req.query.movieGenre], function (err, result) {
    if(err) {
      next(err);
      return;
    }
    res.redirect('back');
  });
});

/************************* ADD GENRE TO DATABASE ****************************/
app.get('/insertGenre',function(req,res,next){
  var context = {};
  var genreQuery = "INSERT INTO genres (genre_type) VALUES (?)"
  mysql.pool.query(genreQuery, [req.query.genre_type], function(err, result){
    if(err){
      next(err);
      return;
    }
    res.redirect('back');
  });
});


/************* ADD ACTOR AND THEIR ROLE TO MOVIE (ADD TO "IS IN" RELATIONSHIP) ***************/
app.get('/addIsIn', function(req,res,next){
  var context = {};
  var is_in_query = "INSERT INTO is_in (mid, aid, char_name) VALUES (?, ?, ?)";
  mysql.pool.query(is_in_query, [req.query.movieTitle, req.query.movieActor, req.query.movieRole], function (err, result) {
    if(err) {
      next(err);
      return;
    }
    res.redirect('back');
  });
});

/************************* ADD ACTOR TO DATABASE ***************************/
app.get('/insertActor',function(req,res,next){
  var context = {};
  var actorQuery = "INSERT INTO actors (actor_fname, actor_lname, actor_gender, actor_dob) VALUES (?, ?, ?, ?)";
  mysql.pool.query(actorQuery, [req.query.actor_fname, req.query.actor_lname,
                                req.query.actor_gender, req.query.actor_dob], function(err, result){
    if(err){
      next(err);
      return;
    }
    res.redirect('back');
  });
});

/*************** ADD DIRECTOR TO MOVIE (ADD TO "DIR BY" RELATIONSHIP) ****************/
// Do I use this? Adding director to movie done when movie is added...
app.get('/addDirBy', function(req,res,next){
  var context = {};
  var is_in_query = "INSERT INTO is_in (mid, aid, char_name) VALUES (?, ?, ?)";
  mysql.pool.query(is_in_query, [req.query.movieTitle, req.query.movieActor, req.query.movieRole], function (err, result) {
    if(err) {
      next(err);
      return;
    }
    res.redirect('back');
  });
});


/************************** ADD DIRECTOR TO DATABASE *****************************/
app.get('/insertDirector',function(req,res,next){
  var context = {};
  var dirQuery = "INSERT INTO directors (dir_fname, dir_lname, dir_gender, dir_dob) VALUES (?, ?, ?, ?)";
  mysql.pool.query(dirQuery, [req.query.director_fname, req.query.director_lname,
                                req.query.director_gender, req.query.director_dob], function(err, result){
    if(err){
      next(err);
      return;
    }
    res.redirect('back');
  });
});

/************************* DELETE MOVIE FROM DATABASE ****************************/
app.get('/deleteMovie',function(req,res,next){
  var context = {};
  mysql.pool.query("DELETE FROM movies WHERE movie_id=?", [req.query.movieID], function(err, result){
    if(err){
      next(err);
      return;
    }
    //refresh the page
    res.redirect('back');
 });
});

/********************** DELETE GENRE FROM MOVIE (REMOVE FROM BELONG RELATIONSHIP) ***********************/
app.get('/deleteBelong',function(req,res,next){
  var context = {};
  mysql.pool.query("DELETE FROM belong WHERE b_mid=? AND gid=?", [req.query.movieID, req.query.genreID], function(err, result){
    if(err){
      next(err);
      return;
    }
    //refresh the page
    res.redirect('back');
  });
});
    
/********************************* UPDATE/EDIT MOVIE ************************************/   
app.get('/updateMovie',function(req,res,next){
  var context = {};
  mysql.pool.query("SELECT * FROM movies WHERE movie_id=?", [req.query.movieID], function(err, result){
    if(err){
      next(err);
      return;
    }
    if(result.length == 1){
      var curVals = result[0];
      mysql.pool.query("UPDATE movies SET title=?, release_year=?, description=?, rating=?, " +
                       "fk_dir_id=? WHERE movie_id=? ",
                       [req.query.title || curVals.title, req.query.release_year || curVals.release_year,
                        req.query.description || curVals.description, req.query.rating || curVals.rating,
                        req.query.fk_dir_id || curVals.fk_dir_id,
                        req.query.movieID], function(err, result){
        if(err){
          next(err);
          return;
        }
      });
    }
    res.redirect('back');
  });
});

function fPause() {
  console.log("pause");
  }


app.get('/goBack', function(req, res, next){
  res.render('home');
  res.refresh('home');
});

app.use(function(req,res){
  res.status(404);
  res.render('404');
});

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.status(500);
  res.render('500');
});

app.listen(app.get('port'), function(){
  console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});




