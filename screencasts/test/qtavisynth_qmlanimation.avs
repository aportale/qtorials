Import("tests.avsi")

initialParameters = """
{
    "text1Text": "foobar",
    "text2FontpixelSize": 50
}
"""

ScreenCast
\ .QtAviSynthQmlAnimation("qml\main.qml", initialParameters, true).ConvertToRgb24.killaudio
