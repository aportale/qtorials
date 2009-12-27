var youtubePlayer;
$(document).ready(function(){
    $("#qtorials").after('<div style="display:none" id="youtubeplayer"></div>');
    youtubePlayer = $("#youtubeplayer");
    var clipLis = $("#qtorials > li > ul > li");
    $(clipLis).each(function(i){
        addViewLinks(this, i);
    });
});

function addClipFancyBoxToViewLink(linkElement, clipWidth, clipHeight, clipId)
{
    $(linkElement).fancybox({
        'callbackOnStart' : function()
            {
                var objectString =
                    '<object width="' + clipWidth + '" height="' + clipHeight + '">'
                    + '<param name="movie" value="http://www.youtube.com/v/' + clipId + '&hl=en_GB&fs=1&"></param>'
                    + '<param name="allowFullScreen" value="true"></param>'
                    + '<param name="allowscriptaccess" value="always"></param>'
                    + '<embed src="http://www.youtube.com/v/' + clipId + '&hl=en_GB&fs=1&autoplay=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true"'
                    + 'width="' + clipWidth + '" height="' + clipHeight + '"></embed></object>';
                $(youtubePlayer).width(clipWidth);
                $(youtubePlayer).height(clipHeight);
                $(youtubePlayer).append(objectString);
            },
        'callbackOnClose' : function()
            {
                $("#youtubeplayer").empty();
            },
        'frameWidth' : clipWidth,
        'frameHeight' : clipHeight,
        'overlayOpacity' : 0.6,
        'centerOnScroll' : false,
        'zoomOpacity' : false,
        'zoomSpeedChange' : 0
    });
}

function addViewLinks(clipLi, i)
{
    var firstAnchor = $(clipLi).find("a:first");
    $(firstAnchor).removeAttr("href");
    var clipLength = $(clipLi).find(".cliplength:first");
    var clipDataSet = qtorialsData["clips"][i];
    if ("youtube_id" in clipDataSet) {
        var clipId = qtorialsData["clips"][i]["youtube_id"];
        var clipWidth = qtorialsData["clips"][i]["clip_width"];
        var clipHeight = qtorialsData["clips"][i]["clip_height"] + 25;
        var youTubeHref = "http://www.youtube.com/watch?v=" + clipId;
        $(clipLength).before('<li><a href="#youtubeplayer">View Qtorial</a></li>');
    }

    $(clipLength).before('<li><a href="' + youTubeHref + '">YouTube Page</a></li>');
}
