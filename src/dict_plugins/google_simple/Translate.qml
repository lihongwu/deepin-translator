import QtQuick 2.1
import QtQuick.Window 2.1
import Deepin.Locale 1.0
import QtMultimedia 5.0
import "../../../src"

TranslateWindow {
	id: container
    
    property variant dsslocale: DLocale {
        id: dsslocale
        dirname: "../../../locale"
        domain: "deepin-translator"
    }
    
    function dsTr(s){
        return dsslocale.dsTr(s)
    }
    
    function showTranslate(x, y, text) {
		mouseX = x
		mouseY = y
		
		/* Move window out of screen before adjust position */
		windowView.x = 100000
		windowView.y = 100000
		windowView.showNormal()
		windowView.get_translate(text)
		
		adjustTranslateSize()
        speechPlayer.autoplayAudio()
    }
	
    function adjustTranslateSize() {
		var maxWidth = Math.max(100, trans.paintedWidth) + (borderMargin + container.blurRadius) * 2
        var maxHeight = trans.paintedHeight + voice.height + cornerHeight + (borderMargin + container.blurRadius) * 2 
        
        windowView.width = maxWidth
        windowView.height = maxHeight
        
        container.rectWidth = maxWidth
        container.rectHeight = maxHeight
        container.width = maxWidth
        container.height = maxHeight
		
		adjustPosition()
    }    
    
	Connections {
		target: windowView
		onVisibleChanged: {
			if (!arg) {
                speechPlayer.stopAudio()
			}
		}
	}
    
    Player {
        id: speechPlayer
        voices: translateInfo.voices
    }
	
	Rectangle {
        id: border
        radius: 6
	    anchors.fill: parent
        anchors.topMargin: cornerDirection == "up" ? borderMargin + container.cornerHeight : borderMargin
		anchors.bottomMargin: borderMargin
		anchors.leftMargin: borderMargin
		anchors.rightMargin: borderMargin
        color: Qt.rgba(0, 0, 0, 0)
        
	    Column {
		    spacing: 10
		    anchors.fill: parent
		    anchors.margins: textMargin
		    
			Speech { 
                id: voice
				text: dsTr("Read")
				visible: translateInfo.voices.length > 0
                
				onClicked: {
                    speechPlayer.playAudio()
				}
            }

		    TextEdit { 
                id: trans
			    text: translateInfo.translate
                textFormat: TextEdit.RichText
			    wrapMode: TextEdit.WordWrap
			    selectByMouse: true
			    font { pixelSize: 12 }
			    color: "#FFFFFF"
				selectionColor: "#11ffffff"
				selectedTextColor: "#5da6ce"
                width: parent.width
                
                onTextChanged: {
                    cursorPosition: 0
                    cursorVislble: false
                }
		    }		
	    }        
	}
}
