package;
import js.node.Http;
import js.node.net.Socket;
import js.npm.Express;
import js.npm.Request;
import js.npm.express.Response;
import js.npm.socketio.Server;

/**
 * ...
 * @author Urs Stutz
 */
class MainServer {

	static var PORT = 3000;
	var socketServer:Server;
	var userNumber:Int;
	
    static public function main() {
        var mainServer = new MainServer();
	}
	
	public function new() {
		
		userNumber = 0;
		var expressApp:Dynamic = new Express();
		var httpServer = Http.createServer( expressApp );
		socketServer = new Server( httpServer );
		
		expressApp.get( "/", sendIndex );
		expressApp.get( "/client.js", sendClientJS );
		
		socketServer.on( "connection", onConnection );
		
		trace( "Listening on port " + PORT );
		httpServer.listen( PORT );
	}
	
	function sendIndex( request:Request, response:Response ) {
		response.sendfile( "index.html" );
	}
	
	function sendClientJS( request:Request, response:Response ) {
		response.sendfile( "client.js" );
	}
	
	function onConnection( socket:Socket ):Void {
		userNumber++;
		onConnect( socket );
		
		socket.on( "chat message", onChatMessage );
		socket.on( "disconnect", onDisconnect );
	}
	
	function onConnect( socket:Socket ):Void {
		var connectMessage = "User " + userNumber + " connected.";
		trace( connectMessage );
		socketServer.emit( "user connected", connectMessage );
	}
	
	function onDisconnect( socket:Socket ):Void {
		var disconnectMessage = "A User disconnected.";
		trace( disconnectMessage );
		socketServer.emit( "user disconnected", disconnectMessage );
	}
	
	function onChatMessage( message:String ):Void {
		trace( "onChatMessage " + message );
		socketServer.emit( "chat message", message );
	}
}