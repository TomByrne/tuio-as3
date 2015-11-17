package org.tuio.connectors.udp
{
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.tuio.osc.OSCEvent;
	
	/**
	 * A simple class for receiving and sending OSCPackets via UDP.
	 */
	public class OSCDatagramSocket extends DatagramSocket
	{
		private var Debug:Boolean = true;
		private var Buffer:ByteArray = new ByteArray();
		private var PartialRecord:Boolean = false;
		private var AutoReconnect:Boolean = true;
		private var Host:String;
		private var Port:int;
		private var Bind:Boolean = true;
		
		public function OSCDatagramSocket(host:String = "127.0.0.1", port:int = 3333, bind:Boolean = true, autoReconnect:Boolean = true)
		{
			this.AutoReconnect = autoReconnect;
			this.Host = host;
			this.Port = port;
			this.Bind = bind;
			
			configureListeners();
			doConnect();
		}
		
		private function configureListeners():void {
	        addEventListener(Event.CLOSE, closeHandler);
	        addEventListener(Event.CONNECT, connectHandler);
	        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	        addEventListener(DatagramSocketDataEvent.DATA, dataReceived);
	    }
		
		private function doConnect():void 
		{
			try {
				if(Bind) this.bind(Port, Host);	
				else this.connect(Host, Port);
				receive();
			}
			catch (e:Error) {
				trace("OSCDatagramSocket error: " + e);
			}
		}
	    
		private function dataReceived(event:DatagramSocketDataEvent):void {
	    	this.dispatchEvent(new OSCEvent(event.data));
	    }
	    
	    private function closeHandler(event:Event):void {
	        if (Debug) trace("Connection Closed");
			if (AutoReconnect) {
				doConnect();
			}
	    }
	
	    private function connectHandler(event:Event):void {
	        if(Debug)trace("Connected");
	    }
	
	    private function ioErrorHandler(event:IOErrorEvent):void {
	        if(Debug)trace("ioErrorHandler: " + event);
	    }
	
	    private function securityErrorHandler(event:SecurityErrorEvent):void {
	        if(Debug)trace("securityErrorHandler: " + event);
	    }
	    
	}
}