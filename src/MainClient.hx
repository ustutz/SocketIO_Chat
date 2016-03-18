package;
import js.Browser;
import js.browser.socketio.Client;
import js.html.Element;
import js.html.Event;
import js.html.FormElement;
import js.html.InputElement;

/**
 * ...
 * @author Urs Stutz
 */
class MainClient {
	
	var form:FormElement;
	var socket:Client;
	var inputField:InputElement;
	var messages:Element;
	var sendButton:Element;

    static public function main() {
		new MainClient();
	}
	
	public function new() { //trace( "new MainClient" );
		
		socket = new Client( "http://localhost:3000" );
		socket.on( "chat message", onMessage );
		socket.on( "user connected", onConnect );
		socket.on( "user disconnected", onDisconnect );
		
		messages = Browser.document.getElementById( "messages" );
		inputField = cast( Browser.document.getElementById( "input_field" ), InputElement );
		sendButton = Browser.document.getElementById( "send_button" );
		
		sendButton.addEventListener( "click", onSubmit );
	}
	
	function onSubmit( e:Event ):Bool { //trace( "onSubmit" );
		socket.emit( "chat message", inputField.value );
		inputField.value = "";
		return false;
	}
	
	function onConnect( message:String ):Void { //trace( "onConnect" );
		appendChatLine( message );
	}
	
	function onDisconnect( message:String ):Void {
		appendChatLine( message );
	}
	
	function onMessage( message:String ):Void { //trace( "onMessage" );
		appendChatLine( message );
	}
	
	function appendChatLine( text:String ):Void {
		
		var li = Browser.document.createLIElement();
		li.innerHTML = text;
		messages.appendChild( li );
	}
	
}