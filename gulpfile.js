// ------------------------------------------------------------ //
// --- Modules ---

var gulp     = require('gulp'),
    gutil    = require('gulp-util'),
    connect  = require('gulp-connect'),
    filter   = require('gulp-filter'),
    plumber  = require('gulp-plumber'),
    sass     = require('gulp-ruby-sass'),
    tsc      = require('gulp-tsc'),
    uglify   = require('gulp-uglifyjs'),
    watch    = require('gulp-watch'),
    rsync    = require('rsyncwrapper').rsync,
    extend   = require('util')._extend;

var settings;

try{
    settings = require('./conf/gulpfile.settings.json');
}catch(e){
    throw "gulpfile.settings.json is not found."
}

// ------------------------------------------------------------ //
// --- Task ---

// ------------ ------------
// watch
// ------------ ------------

gulp.task("watch:sass",function(){
    if( !settings.sass ){
        throw "No Settings for sass";
    }
    var _conf = settings.sass.default;
    gulp.watch([_conf.srcDir],["scss"]);
});

gulp.task("watch:ts",function(){
    if( !settings.tsc ){
        throw "No Settings for tsc";
    }
    var _conf = settings.tsc.default;
    gulp.watch([_conf.srcDir,"!**/*.d.ts","!**/d.ts"],["tsc"]);
});

// ------------ ------------
// sass
// ------------ ------------

gulp.task("sass",function(){

    if( !settings.sass ){
        throw "No Settings for tsc";
    }

    var _conf = settings.sass.default;
    //var _filter = new filter(["*","!*.css"]);

    return gulp.src([_conf.srcDir+'/**/*.scss'])
        .pipe(plumber())
        .pipe(sass({

        }))
        .pipe(gulp.dest(_conf.destDir));

});

// ------------ ------------
// tsc
// ------------ ------------

gulp.task("tsc",function(){

    if( !settings.tsc ){
        throw "No Settings for tsc";
    }

    var _conf   = settings.tsc.default;
    var _filter = new filter(["*","!*.d.ts"]);

    return gulp.src([_conf.srcDir+'/**/*.ts','!**/*.d.ts','!**/d.ts'])
        .pipe(plumber())
        .pipe(tsc({
            declaration : true,
            out         : _conf.output + ".js",
            tmpDir      : _conf.srcDir
        }))
        .pipe(gulp.dest(_conf.srcDir))
        .pipe(_filter)
        .pipe(gulp.dest(_conf.destDir))
        .pipe(uglify(_conf.output+".min.js",{ outSourceMap : true, basePath : _conf.destDir } ))
        .pipe(gulp.dest(_conf.destDir));

});

// ------------ ------------
// livereload
// ------------ ------------

gulp.task('connect',function(){
    if( !settings.connect ){
        throw "No Settings for connect";
    }
    return connect.server(settings.connect);
});

gulp.task('livereload',['connect'],function(){
    if( !settings.connect || !settings.livereload ){
        throw "No settings for livereload";
    }
    return gulp.watch(settings.connect.watch)
        .on('change',function(file){
            gulp.src(file.path).pipe(connect.reload());
        });
});

// ------------ ------------
// rsync
// ------------ ------------

gulp.task('rsync', function() {

    if( !settings || !settings.rsync ){
        throw "No settings for rsync";
    }

    var conf = extend({},settings.rsync);

    if( !conf.args ){
        conf.args = ["--verbose"];
    }else if( conf.args.join(" ").indexOf("--verbose") < 0 ){
        conf.args.push("--verbose");
    }

    rsync(conf,function(error, stdout, stderr, cmd) {
        gutil.log(error,stdout,stderr,cmd);
    });

});

gulp.task('rsync:watch', function() {

    if( !settings || !settings.rsync ){
        throw "No settings for rsync";
    }

    var conf = extend({},settings.rsync);

    if( !conf.args ){
        conf.args = ["--verbose"];
    }else if( conf.args.join(" ").indexOf("--verbose") < 0 ){
        conf.args.push("--verbose");
    }

    var src = conf.src + "/**/*.*"
    src.replace(/\/\//ig,"/");

    gulp.src(src).pipe(plumber()).pipe(
        watch(src,function(){
            rsync(conf,function(error, stdout, stderr, cmd) {
                gutil.log(error,stdout,stderr,cmd);
            });
        })
    );

});