Import("tests.avsi")

initialParameters = """
{
    "text1Text": "foobar",
    "text2FontpixelSize": 50
}
"""

background = ScreenCast
background
\ .QtAviSynthQmlAnimation("qml/test.qmlproject", background.FrameRate, initialParameters).ConvertToRgb24.killaudio
