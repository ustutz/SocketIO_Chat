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
	var socketIO:Server;
	
    static public function main() {
        var mainServer = new MainServer();
	}
	
	public function new() {
		
		var expressApp:Dynamic = new Express();
		var server = Http.createServer( expressApp );
		socketIO = new Server( server );
		
		expressApp.get( "/", sendIndex );
		expressApp.get( "/client.js", sendClientJS );
		
		socketIO.on( "connection", onConnection );
		
		trace( "Listening on port " + PORT );
		server.listen( PORT );
	}
	
	function sendIndex( request:Request, response:Response ) {
		response.sendfile( "index.html" );
	}
	
	function sendClientJS( request:Request, response:Response ) {
		response.sendfile( "client.js" );
	}
	
	function onConnection( socket:Socket ):Void {
		socket.on( "chat message", onChatMessage );
	}
	
	function onChatMessage( message:String ):Void {
		trace( "onChatMessage " + message );
		socketIO.emit( "chat message", message );
	}
}