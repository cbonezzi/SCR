$(function () {
    var jsonSongs = $("#json-songs").data("variable");
    var songs = [];
    for (var i = 0; i < jsonSongs.length; i++) {
        songs[i] = JSON.parse(jsonSongs[i]);
    }

    if (songs) {
        var currentIndex = -1;
        var nextIndex = 0;
        var colorUnselected = "black";
        var colorSelected = "#ff3a00";

        function updateSong() {
            if (++currentIndex >= songs.length) {
                currentIndex = 0;
            }
            if (++nextIndex >= songs.length) {
                nextIndex = 0;
            }
            document.getElementById("current-artwork").src = songs[currentIndex].artwork;
            document.getElementById("current-title").innerHTML = songs[currentIndex].title;
            document.getElementById("current-link").href = songs[currentIndex].url;

            document.getElementById("next-artwork").src = songs[nextIndex].artwork;
            document.getElementById("next-title").innerHTML = songs[nextIndex].title;

            for (i = 0; i < songs.length; i++) {
                document.getElementById("song_" + i).style.color = colorUnselected;
            }
            document.getElementById("song_" + currentIndex).style.color = colorSelected;

            audio.load(songs[currentIndex].stream_url);
        }

        // Setup the player to autoplay the next track
        var a = audiojs.createAll({
            trackEnded: function () {
                updateSong();
                audio.play();
                document.getElementById("play-pause").className = "glyphicon glyphicon-pause";
            }
        });

        // Load in the first track
        var audio = a[0];
        updateSong();

        $("#play-pause").click(function (e) {
            audio.playPause();
            if (audio.playing) {
                document.getElementById("play-pause").className = "glyphicon glyphicon-pause";
            }
            else {
                document.getElementById("play-pause").className = "glyphicon glyphicon-play";
            }
        });

        $("#skip").click(function (e) {
            audio.trackEnded();
        });
    }
});