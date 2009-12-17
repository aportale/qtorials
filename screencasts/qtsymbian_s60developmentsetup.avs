# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "qtsymbian_s60developmentsetup_narration.wav")
global gAudioNoiseStart = 1029400 / 44100.0
global gAudioNoiseEnd = 1039584 / 44100.0
global gClipWidth = 640
global gClipHeight = 360
global gTextClipFramesPerCharacter = 4

function intro
{
    Dissolve(
        \   textClip("Mobile development with\nQt for the Symbian Platform", 75)
        \ , textClip("Setting up a\nSymbian development environment", 75)
        \ , gDissolveLength)
}

function videoWelcome_960x720
{
    DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, gClipHeight, 400, 0, 1280, 960)
}

function videoWelcome_640x360
{
    DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, gClipHeight, 200, 40, 1568, 880)
}

function welcome
{
    AudioDub(videoWithClipSize("videoWelcome"), WAVSource(gMediaDir + "qtsymbian_s60developmentsetup.wav"))
        \ .DelayAudio(4.37)
        \ .Trim(115, 715)
}

function audioOverview
{
    audioNoise(1)
\[*
    #n A Symbian development environment usually consists of...
    #n ...The Nokia Ovi Suite for easy application installation to our phone...
    #n ...Carbide.c++, which is an Eclipse based IDE for Symbian development. We install it for the sake of completeness. In the following, we will use the IDE QtCreator with it's preliminary Symbian support...
    #n ...ActivePerl-5.6.1, build 635...
*]
        \ + audioClip(2.043, 18.065, 0)
\[*
    #n ...An S60 SDK. It contains the Symbian platform specific tools, header files, libraries, and the cross compiling toolchain for the phone...
    #n ...We also want the an updated "Open C" Plugin. It will be installed on top of the S60 SDK, and later also on our phone...
    #n ...And last but not least, we want to install the 'Application TRK' on our phone. That is needed for on-device debugging and automated deployment...
    #  Slide with components
*]
        \ + audioClip(23.614, 49.273, 1)

        \ + audioNoise(10)
}

function videoOverview
{
    Dissolve(
        \   textClip("", 110)
        \ , textClip("Nokia Ovi Suite\n\n\n\n\n", 110)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\n\n\n\n", 120)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 635\n\n\n", 100)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 635\nS60 Platform SDK\n\n", 260)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 635\nS60 Platform SDK\nOpen C/C++\n", 200)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 635\nS60 Platform SDK\nOpen C/C++\nApplication TRK", 250)
        \ , textClip("", 40)
        \ , gDissolveLength)
}

function overview
{
    AudioDub(videoOverview, audioOverview).converttorgb32
}

function audioNokiaOviSuite
{
    audioNoise(1)
\[*
    #n We visit the Nokia Ovi Suite download page.
    #t bit.ly/ovisuite
*]
        \ + audioClip(53.870, 57.168, 1.5)
\[*
    #n There, we click "Download"...
*]
        \ + audioClip(57.597, 59.164, 0.5)
\[*
    #n ...and and install it.
*]
        \ + audioClip(59.141, 60.302, 2.5)
\[*
    #n If after the installation, we see such an icon, the Nokia Ovi Suite is connected to our device.
*]
        \ + audioClip(60.778, 66.920, 1)

        \ + audioNoise(10)
}

function videoNokiaOviSuite_960x720
{
    install = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_ovisuiteinstallation.avi")
    install_cut =
        \   install.trim(30, 108)                                        [* Entering Url *]
        \ + install.trim(150, 300)                                       [* click download *]
        \ + install.trim(300, 2700).selectevery(40).assumefps(25)        [* time lapse installation *]
    connected = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_ovisuiteconnected.avi")
    connected_cut =
        \   connected.trim(20, 140)                                      [* Phone is Connected *]
        \ + connected.trim(140, 140).loop(60)                            [* Phone is Connected *]
    Dissolve(install_cut, connected_cut, gDissolveLength)
}

function videoNokiaOviSuite_640x360
{
    setDetailClip(videoNokiaOviSuite_960x720)
    setDetail(0, 0)
    showDetail(75, 0, 0)                                                 [* Entering Url *]
        \ + showDetail(150, -140, 0, 1240, 720)                          [* Page loads *]
        \ + showDetail(230, 60, 290)                                     [* Starting Download *]
        \ + showDetail(340, -140, 0, 1240, 720)                          [* Installation *]
        \ + showDetail(466, 0, 360)                                      [* Phone connected *]
}

function nokiaOviSuite
{
    AudioDub(videoWithClipSize("videoNokiaOviSuite").urlSubTitle("bit.ly/ovisuite"), audioNokiaOviSuite).converttorgb32
}

function audioCarbide
{
    audioNoise(1)
\[*
    #n We visit the Carbide.c++ download page at Forum Nokia.
    #t bit.ly/carbidecpp
*]
        \ + audioClip(68.116, 71.622, 1.3)
\[*
    #n There, we click on "Download now"...
*]
        \ + audioClip(71.924, 74.014, 2)
\[*
    #n ...and 'oops', we need to login into Forum Nokia. If you do not have an account yet, you can get it through the registration form.
*]
        \ + audioClip(74.048, 82.268, 3)
\[*
    #n During the installation we can leave all settings as they are.
*]
        \ + audioClip(88.410, 92.137, 2)
\[*
    #n After the installation, we start the shortcut called 'Configure environment for WINSCW command line' in order to add s few required environment variables to our system.
*]
        \ + audioClip(92.740, 102.992, 1)

        \ + audioNoise(10)
}

function videoCarbide_960x720
{
    beforelogin = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_carbide_beforelogin.avi")
    beforelogin_cut =
        \   beforelogin.trim(60, 202)                                     [* Entering Url *]
        \ + beforelogin.trim(220, 300).selectevery(2).assumefps(25)       [* Fast forwarding slow mouse move *]
        \ + beforelogin.trim(300, 340)                                    [* Clicked Download *]
        \ + beforelogin.trim(436, 522)                                    [* Login page *]
        \ + beforelogin.trim(522, 522).loop(165)                          [* Login page *]
    afterlogin = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_carbide_afterlogin.avi")
    afterlogin_cut =
        \   afterlogin.trim(1, 4800).selectevery(120).assumefps(25)       [* Fast forward to Edition type step *]
        \ + afterlogin.trim(4800, 4800).loop(60)                          [* Edition type step *]
        \ + afterlogin.trim(4800, 4860)                                   [* Setup *]
        \ + afterlogin.trim(4860, 6400).selectevery(80).assumefps(25)     [* Fast forward to WINSCW shortcut warning *]
        \ + afterlogin.trim(6400, 6500)                                   [* hovering WINSCW shortcut *]
        \ + afterlogin.trim(6500, 6500).loop(80)                          [* hovering WINSCW shortcut *]
        \ + afterlogin.trim(6500, 6690)                                   [* launching WINSCW shortcut *]
    Dissolve(beforelogin_cut, afterlogin_cut, gDissolveLength)
}

function videoCarbide_640x360
{
    setDetailClip(videoCarbide_960x720)
    setDetail(0, 0)
    showDetail(85, 0, 0)                                                 [* Entering Url *]
        \ + showDetail(165, -140, 0, 1240, 720)                          [* Page loads *]
        \ + showDetail(210, 60, 290)                                     [* Starting Download *]
        \ + showDetail(320, -140, 0, 1240, 720)                          [* Oops *]
        \ + showDetail(430, 0, 236)                                      [* How to login *]
        \ + showDetail(510, -140, 0, 1240, 720)                          [* Downloading *]
        \ + showDetail(650, 160, 188)                                    [* Leave installation options untouched *]
        \ + showDetail(850, 0, 360)                                      [* Launch WINSCW shortcut *]
        \ + showDetail(960, 16, 19)                                      [* Executing WINSCW shortcut *]
        \ + showDetail(1024, -140, 0, 1240, 720)                         [* End *]
}

function carbide
{
    AudioDub(videoWithClipSize("videoCarbide").urlSubTitle("bit.ly/carbidecpp"), audioCarbide).converttorgb32
}

function audioActivePerl
{
    audioNoise(1.5)
\[*
    #n We visit the ActiveState Download page of Active Perl 5.6.
    #t bit.ly/activeperl56
*]
        \ + audioClip(103.991, 108.495, 1.5)
\[*
    #n There, we chose the version 5.6.1, build 635...
    #n This is the recommended version by Forum Nokia. Any other perl version might deter the Symbain toolchain from working properly.
*]
        \ + audioClip(108.681, 121.197, 2)
\[*
    #n When installing it, we make sure that Perl is added to the PATH environment variable.
*]
        \ + audioClip(121.916, 126.363, 1)

        \ + audioNoise(10)
}

function videoActivePerl_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_activeperl.avi")
    footage.trim(1, 141)                                                [* Entering Url *]
        \ + footage.trim(200, 224)                                      [* Finish loading page *]
        \ + footage.trim(224, 370).selectevery(2).assumefps(25)         [* Timelapse Scrolling and clicking *]
        \ + footage.trim(370, 370).loop(275)                            [* Explaining version *]
        \ + footage.trim(370, 1060).selectevery(12).assumefps(25)       [* Timelapse Installation *]
        \ + footage.trim(1060, 1165)                                    [* Add to PATH environment variable *]
        \ + footage.trim(1165, 2363).selectevery(20).assumefps(25)      [* Fast forward to end *]
}

function videoActivePerl_640x360
{
    setDetailClip(videoActivePerl_960x720)
    setDetail(0, 0)
    showDetail(120, 0, 0)                                                [* Entering Url *]
        \ + showDetail(210, -140, 0, 1240, 720)                          [* Page loads *]
        \ + showDetail(440, 152, 294)                                    [* Clicking link *]
        \ + showDetail(570, -140, 0, 1240, 720)                          [* Downloading, Installing *]
        \ + showDetail(570, -140, 0, 1240, 720)                          [* Downloading, Installing *]
        \ + showDetail(670, 160, 188)                                    [* Add to PATH environment variable *]
        \ + showDetail(739, -140, 0, 1240, 720)                          [* End *]
}

function activePerl
{
    AudioDub(videoWithClipSize("videoActivePerl").urlSubTitle("bit.ly/activeperl56"), audioActivePerl).converttorgb32
}

function audioS60Sdk
{
    audioNoise(1)
\[*
    #n We visit the S60 SDK download page at Forum Nokia.
    #t bit.ly/s60sdk
*]
        \ + audioClip(127.222, 130.798, 2)
\[*
    #n We have the choice between three SDKs... Now, which is the one for us?
*]
        \ + audioClip(131.030, 136.440, 1)
\[*
    #n Normally, we use a specific S60 SDK, for example third edition... feature pack 2 to build our application.
    #n And that application would run on a S60 third edition, feature pack 2 based phone.
    #n Or we would use the S60 SDK fifth edition to build our application and run that on a phone with S60 fifth edition.
    #n But in effect, since we will use the Qt Api, all those version differences do not matter. Our Qt application can be built with any S60 SDK since the third edition featurepack 1.
    #n And we can run our application on any S60 phone with at least the 3rd edition feature pack 1.
*]
        \ + audioClip(136.348, 172.756, 1)
\[*
    #n That means that we have a free choice, here. I simply chose the fifth edition and click on Download.
*]
        \ + audioClip(173.082, 179.049, 2)
\[*
    #n If the installer complains about a missing Java Runtime Environment, we don't care.
*]
        \ + audioClip(186.108, 190.566, 1)
\[*
    #n We need to make sure that we have enough space on the drive where we install the SDK. Qt has to be installed on the same drive, later on.
*]
        \ + audioClip(191.193, 198.647, 3)
\[*
    #n The installer offers to install the 'CSL Arm Toolchain', which we accept. It is needed to build our applications for the phone.
*]
        \ + audioClip(200.110, 207.935, 1)

        \ + audioNoise(10)
}

function videoS60Sdk1_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_s60sdk.avi")
    footage.trim(1, 130)                                                [* Entering Url *]
        \ + footage.trim(130, 202).selectevery(2).assumefps(25)         [* Fast forwarding slow mouse move *]
        \ + footage.trim(202, 249)                                      [* Open version choice *]
        \ + footage.trim(249, 249).loop(100)                            [* Which version? *]
}

function videoS60Sdk1_640x360
{
    setDetailClip(videoS60Sdk1_960x720)
    setDetail(0, 0)
    showDetail(85, 0, 0)                                                [* Entering Url *]
        \ + showDetail(145, -140, 0, 1240, 720)                         [* Page loads *]
        \ + showDetail(315, 200, 360)                                   [* Which version? *]
}

function svgSnippet(string elementsCsv, int frames)
{
    clip =
        \ QtorialsSvg("qtsymbian_s60developmentsetup.svg", elementsCsv, gClipWidth, gClipHeight, frames)
    overlayRgbClip(BlankClip(clip, color = gBackgroundColor), clip)
}

function videoS60Sdk2
{
    Dissolve(
        \   svgSnippet("", 60)
        \ , svgSnippet("s60logo32", 70)
        \ , svgSnippet("s60logo32, sdk3", 40)
        \ , svgSnippet("s60logo32, sdk3, fp2", 40)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60", 45)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32", 130)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32, s60sdk50, division", 55)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32, s60sdk50, division, myapp50, myapp50s60", 50)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32, s60sdk50, division, myapp50, myapp50s60, phonearrow50, phone50", 120)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32qt, phonearrow32, phone32, s60sdk50, division, myapp50, myapp50qt, phonearrow50, phone50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal", 140)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal, phonearrowsuniversal", 180)
        \ , gDissolveLength)
}

function videoS60Sdk3_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_s60sdk.avi")
    footage.trim(230, 380)                                                  [* Selecting and downloading 5.0 *]
        \ + footage.trim(380, 643).selectevery(12).assumefps(25)            [* Fast forwardig to download *]
        \ + footage.trim(643, 13120).selectevery(400).assumefps(25)         [* downloading *]
        \ + footage.trim(13120, 16970).selectevery(120).assumefps(25)       [* Forwardig to JRE warning *]
        \ + footage.trim(16970, 17040)                                      [* Clicking JRE warning *]
        \ + footage.trim(17040, 17180).selectevery(8).assumefps(25)         [* Fast forwarding to target directory *]
        \ + footage.trim(17180, 17180).loop(220)                            [* Drive space considerations *]
        \ + footage.trim(17180, 36600).selectevery(600).assumefps(25)       [* Fast forwarding to CSL Toolchain installer *]
        \ + footage.trim(36600, 36800)                                      [* CSL Toolchain installer *]
        \ + footage.trim(36800, 37200).selectevery(8).assumefps(25)         [* Fast forwarding to End *]
}

function videoS60Sdk3_640x360
{
    setDetailClip(videoS60Sdk3_960x720)
    setDetail(200, 360)
    showDetail(140, 200, 360)                                           [* Choosing 5th edition *]
        \ + showDetail(237, -140, 0, 1240, 720)                         [* Installing *]
        \ + showDetail(300, 165, 200)                                   [* JRE warning *]
        \ + showDetail(400, 8, 92, 952, 536)                            [* Installing *]
        \ + showDetail(500, 192, 270)                                   [* Destination Path *]
        \ + showDetail(580, -140, 0, 1240, 720)                         [* Installing *]
        \ + showDetail(700, 161, 202)                                   [* CSL Tool chain *]
        \ + showDetail(832, -140, 0, 1240, 720)                         [* End *]
}

function S60Sdk
{
    AudioDub(
        \  Dissolve(
            \  videoWithClipSize("videoS60Sdk1").converttorgb32
            \ ,videoS60Sdk2
            \ ,videoWithClipSize("videoS60Sdk3").converttorgb32
            \ ,gDissolveLength).urlSubTitle("bit.ly/s60sdk")
        \ ,audioS60Sdk)
}

function audioOpenC
{
    audioNoise(2)
\[*
    #n We visit the Open C Plugin download page at Forum Nokia.
    #t bit.ly/openc
*]
        \ + audioClip(208.446, 211.929, 4)
\[*
    #n The installer will ask us for the S60 SDK on top of which we want to install the Open C plugin.
*]
        \ + audioClip(218.291, 223.887, 0.5)
\[*
    #n The preselected one should be fine.
*]
        \ + audioClip(224.676, 226.627, 1)

        \ + audioNoise(10)
}

function videoOpenC_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_openc.avi")
    footage.trim(1, 136)                                                [* Entering Url *]
        \ + footage.trim(137, 347).selectevery(12).assumefps(25)        [* Fast forward to Download *]
        \ + footage.trim(347, 974).selectevery(24).assumefps(25)        [* Downloading *]
        \ + footage.trim(974, 1701).selectevery(12).assumefps(25)       [* Fast forward to S60 Sdk Wizard page *]
        \ + footage.trim(1701, 1701).loop(200)                          [* S60 Sdk Wizard page *]
        \ + footage.trim(1701, 3556).selectevery(40).assumefps(25)      [* Fast forward to end *]
}

function videoOpenC_640x360
{
    setDetailClip(videoOpenC_960x720)
    setDetail(0, 0)
    showDetail(90, 0, 0)                                                [* Entering Url *]
        \ + showDetail(240, -140, 0, 1240, 720)                         [* Installing *]
        \ + showDetail(415, 166, 188)                                   [* S60 Sdk Wizard page *]
        \ + showDetail(489, -140, 0, 1240, 720)                         [* End *]
}

function openC
{
    AudioDub(videoWithClipSize("videoOpenC").urlSubTitle("bit.ly/openc"), audioOpenC).converttorgb32
}

function audioAppTrk
{
    audioNoise(1)
\[*
    #n We visit the Application TRK download page.
    #t bit.ly/apptrk
*]
        \ + audioClip(227.974, 230.783, 1)
\[*
    #n And choose the app_trk package with the right version for our phone.
    #n Since I have an ExpressMusic 5800 which runs S60 fifth edition, I take the 5 0 version.
*]
        \ + audioClip(230.969, 242.277, 1)
\[*
    #n We simply execute the downloaded .sisx file and the Ovi Suite will start the installation to our connected phone.
*]
        \ + audioClip(242.788, 249.313, 1)

        \ + audioNoise(10)
}

function videoAppTrk_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_apptrk.avi")
    footage.trim(1, 115)                                                [* Entering Url *]
        \ + footage.trim(140, 150)                                      [* Page loaded *]
        \ + footage.trim(150, 225)                                      [* Fast forwarded slow mouse move *]
        \ + footage.trim(225, 225).loop(180)                            [* App trk 5.0 verion *]
        \ + footage.trim(225, 465)                                      [* Opening .sisx *]
}

function videoAppTrk_640x360
{
    setDetailClip(videoAppTrk_960x720)
    setDetail(0, 0)
    showDetail(80, 0, 0)                                                [* Entering Url *]
        \ + showDetail(145, -140, 0, 1240, 720)                         [* Page loads *]
        \ + showDetail(400, 0, 360)                                     [* Click download *]
        \ + showDetail(520, -140, 0, 1240, 720)                         [* Downloading *]
        \ + showDetail(623, 0, 240)                                     [* Nokia App installer starts *]
}

function appTrk
{
    appTrkInstall = 
        \  DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_apptrk.MTS", audio = false)
        \ .trim(220, 380)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(0, 330, 1080, 1280)
        \ .Lanczos4Resize(304, 360)
        \ .addborders(168, 0, 168, 0, $000000)
        \ .converttorgb32
    AudioDub(
        \ Dissolve(
            \  videoWithClipSize("videoAppTrk").converttorgb32
            \ ,appTrkInstall
            \ ,gDissolveLength).urlSubTitle("bit.ly/apptrk")
        \ , audioAppTrk)
}

function audioOutro
{
    audioNoise(1)
\[*
    #n You have now a fully functional Symbian SDK. Now, we can get Qt for Symbian running.
*]
        \ + audioClip(250.908, 257.967, 1)

        \ + audioNoise(10)
}

function videoOutro
{
    simpleQtorialsElements("qtlogobig", 240).converttorgb32
}

function outro
{
    AudioDub(videoOutro, audioOutro)
}

function componenTitle(string title)
{
    AudioDub(textClip(title), audioNoise(10))
}

function completeclip
{
    return
        \ Dissolve(
            \   intro
            \ , welcome.converttorgb32
            \ , overview
            \ , componenTitle("Nokia Ovi Suite"),                nokiaOviSuite
            \ , componenTitle("Carbide.c++"),                    carbide
            \ , componenTitle("ActivePerl-5.6.1, build 635"),    activePerl
            \ , componenTitle("S60 Platform SDK"),               S60Sdk
            \ , componenTitle("Open C/C++"),                     openC
            \ , componenTitle("Application TRK"),                appTrk
            \ , outro
            \ , gDissolveLength)
        \ .overlayQtorialsElements("qtlogosmall, oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
