declare variable $publishedOnly := "false";
declare variable $ns := "http://www.w3.org/1999/xhtml";

element {QName($ns, 'html')}{
    attribute xml:lang{"en"},
    element {QName($ns, 'head')}{
        element {QName($ns, 'meta')}{
            attribute http-equiv{"Content-Type"},
            attribute content{"text/html; charset=UTF-8"}
        },
        element {QName($ns, 'meta')}{
            attribute name{"language"},
            attribute content{"en"}
        },
        element {QName($ns, 'meta')}{
            attribute name{"author"},
            attribute content{"Alessandro Portale"}
        },
        element {QName($ns, 'meta')}{
            attribute name{"description"},
            attribute content{"Qtorials - The bite sized Qt tutorial screencasts. First steps, fundamentals, and more, all in a not-too-boring fashion. Enjoy :)"}
        },
        element {QName($ns, 'meta')}{
            attribute name{"keywords"},
            attribute content{"Tutorials, Qtorials, Qt, Software, Development, Screen casts, Open source, Nokia"}
        },
        element {QName($ns, 'link')}{
            attribute rel{"stylesheet"},
            attribute type{"text/css"},
            attribute href{"style.css"},
            attribute media{"screen"}
        },
        element {QName($ns, 'title')}{"Qtorials - Bite sized Qt tutorials"}
    },

    element {QName($ns, 'body')}{
        element {QName($ns, 'ul')}{
            attribute id{"qtorials"},
            for $category in doc("qtorials.mm")/map/node/node
                let $categoryTitle := data($category/@TEXT)
                let $clipsWithYoutubeIdCount := count($category/node/attribute[@NAME = "youtube_id"])
            return
                if ($clipsWithYoutubeIdCount = 0 and $publishedOnly = "true") then () else
                element {QName($ns, 'li')}{
                    element {QName($ns, 'h2')}{$categoryTitle},
                    (: element {QName($ns, 'p')}{normalize-space(data($category/richcontent/html/body/p))}, :)
                    element {QName($ns, 'ul')}{
                        for $clip in ($category/node)
                            let $clipShortTitle := data($clip/@TEXT)
                            let $formattedClipIndex := concat(if(index-of($category/node, $clip) < 10) then 0 else "", index-of($category/node, $clip))
                            let $clipLongTitle := concat("Qtorials - ", $categoryTitle, " - ", $formattedClipIndex, " ", $clipShortTitle)
                            let $youtubeId := data($clip/attribute[@NAME = "youtube_id"]/@VALUE)
                            let $youtubeUrl := concat("http://www.youtube.com/watch?v=", $youtubeId)
                            let $blipTv_fileName := data($clip/attribute[@NAME = "blipTv_fileName"]/@VALUE)
                            let $blipTv_clipMB := data($clip/attribute[@NAME = "blipTv_clipMB"]/@VALUE)
                            let $clip_length := data($clip/attribute[@NAME = "clip_length"]/@VALUE)
                            let $clip_notPublishable :=
                                boolean(string($youtubeId) = "" or string($blipTv_fileName) = "" or string($blipTv_clipMB) = "" or string($clip_length) = "")
                            let $clipDataBlock := element {QName($ns, 'dl')}{
                                element {QName($ns, 'dt')}{"Clip title"},
                                element {QName($ns, 'dd')}{$clipLongTitle},
                                element {QName($ns, 'dt')}{"Clip tags"},
                                element {QName($ns, 'dd')}{string-join(reverse(data($clip/ancestor-or-self::element()/attribute[@NAME = "clip_tags"]/@VALUE)), ', ')},
                                element {QName($ns, 'dt')}{"Clip description"},
                                element {QName($ns, 'dd')}{
                                    element {QName($ns, 'p')}{normalize-space(data($clip/richcontent/html/body/p))},
                                    for $paragraph in ($clip/../../richcontent/html/body/*) return
                                        element {QName($ns, 'p')}{normalize-space(data($paragraph))}
                                }
                            }
                            let $clipListItem := element {QName($ns, 'li')}{
                                element {QName($ns, 'a')}{
                                    attribute href{$youtubeUrl},
                                    element {QName($ns, 'img')}{
                                        attribute src{concat("http://i3.ytimg.com/vi/", $youtubeId, "/default.jpg")},
                                        attribute width{120},
                                        attribute height{90},
                                        attribute alt{$clipShortTitle}
                                    }
                                },
                                element {QName($ns, 'h3')}{$clipShortTitle},
                                element {QName($ns, 'p')}{normalize-space(data($clip/richcontent/html/body/p))},
                                element {QName($ns, 'ul')}{
                                    element {QName($ns, 'li')}{
                                        concat("Length: ", $clip_length)
                                    },
                                    element {QName($ns, 'li')}{
                                        element {QName($ns, 'a')}{
                                            attribute href{$youtubeUrl},
                                            string("View on YouTube")
                                        }
                                    },
                                    element {QName($ns, 'li')}{
                                        element {QName($ns, 'a')}{
                                            attribute href{concat("http://blip.tv/file/get/", $blipTv_fileName)},
                                            concat("Download .ogv (", $blipTv_clipMB, "MB)")
                                        }
                                    }
                                }
                            }

                        return
                            if ($clip_notPublishable and $publishedOnly = "true") then () else $clipListItem
                    }
                }
        }
    }
}
