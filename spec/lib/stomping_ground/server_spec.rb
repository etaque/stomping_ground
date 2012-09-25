require 'spec_helper'

describe StompingGround do

  let(:stomp_uri) { 'stomp://127.0.0.1:2000' }

  it "should allow client to connect" do
    server_thread = Thread.new do
      StompingGround::Server.new('127.0.0.1','2000').start
    end

    client = OnStomp::Client.new("stomp://127.0.0.1:2000")
    client.connect
    client.connected?.should be_true
    client.disconnect

    server_thread.kill
  end

  it "should allow client to disconnect" do
    puts "starting server"
    server_thread = Thread.new do
      StompingGround::Server.new('127.0.0.1','2000').start
    end
    puts "server started"

    client = OnStomp::Client.new("stomp://127.0.0.1:2000")
    puts "client created"
    client.connect
    puts "client connected"
    client.disconnect
    client.connected?.should be_false

    server_thread.terminate
  end

  it "should allow client to subscribe" do
    server_thread = Thread.new do
      StompingGround::Server.new('127.0.0.1','2000').start
    end

    client = OnStomp::Client.new("stomp://127.0.0.1:2000")
    client.connect
    client.subscribe("queue", :ack => 'client') do |message|
    end
    client.disconnect

    server_thread.terminate
  end

end
