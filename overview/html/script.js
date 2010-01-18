var youtubePlayer;
$(document).ready(function(){
    $("#qtorials").after('<div style="display:none" id="youtubeplayer"></div>');
    youtubePlayer = $("#youtubeplayer");
    var clipLis = $("#qtorials > li > ul > li");
    $(clipLis).each(function(i){
        addViewLinks(this, i);
    });
});

function addClipFancyBoxToViewLink(linkElement, clipWidth, clipHeight, clipId, hd)
{
    var hdParam = hd ? "&hd=1" : "";
    var embedUrl = 'http://www.youtube.com/v/' + clipId + hdParam + '&autoplay=1';
    var objectString =
        '<object width="' + clipWidth + '" height="' + clipHeight + '">'
        + '<param name="movie" value="' + embedUrl + '"></param>'
        + '<param name="allowFullScreen" value="true"></param>'
        + '<param name="allowscriptaccess" value="always"></param>'
        + '<embed src="' + embedUrl + '" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true"'
        + 'width="' + clipWidth + '" height="' + clipHeight + '"></embed></object>';
    $(linkElement).attr("href", "#youtubeplayer");
    $(linkElement).fancybox({
        'callbackOnStart' : function()
            {
                $("#youtubeplayer").append(objectString);
                var huhu = 1;
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
    var commentClipId;
    $(firstAnchor).removeAttr("href");
    var clipDataSet = qtorialsData["clips"][i];
    if ("youtube_id" in clipDataSet) {
        var clipWidth = clipDataSet["clip_width"];
        var clipHeight = clipDataSet["clip_height"] + 25;
        var clipId = clipDataSet["youtube_id"];
        commentClipId = clipId;
        var link = $("ul > li.watchclip:first > a", clipLi)[0];
        addClipFancyBoxToViewLink(link, clipWidth, clipHeight, clipId, false);
    }
    if ("youtube_id_hd" in clipDataSet) {
        var clipWidth = clipDataSet["clip_width_hd"];
        var clipHeight = clipDataSet["clip_height_hd"] + 25;
        var clipId = clipDataSet["youtube_id_hd"];
        var link = $("ul > li.watchclip:last > a", clipLi)[0];
        if (!commentClipId)
            commentClipId = clipId;
        addClipFancyBoxToViewLink(link, clipWidth, clipHeight, clipId, true);
    }

    if (commentClipId)
        $("ul > li:last", clipLi).after('<li class=\"commentclip\"><a href="http://youtube.com/comment_servlet?all_comments&v=' + commentClipId + '">Comment</a></li>');
}
