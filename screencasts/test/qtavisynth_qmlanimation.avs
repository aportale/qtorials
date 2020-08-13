Import("tests.avsi")

initialParameters = """
{
    "text1Text": "foobar",
    "text2FontpixelSize": 50
}
"""

ScreenCast
\ .QtAviSynthQmlAnimation("qml\test.qmlproject", 60, initialParameters).ConvertToRgb24.killaudio
