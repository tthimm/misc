# talk to jamcraft from ruby
# http://code.google.com/p/jamcraft/
require 'dbus'

class Jamcraft
  attr_reader :jamcraft

  def initialize
    bus = DBus::SystemBus.instance
    service = bus.service("com.jamcustoms.jamcraft")
    @jamcraft = service.object("/com/jamcustoms/jamcraft/DBusHandler")
    @jamcraft.introspect
    @jamcraft.default_iface = "com.jamcustoms.jamcraft.dbusHandler"
  end

  def list
    @jamcraft.list
  end


end

jc = Jamcraft.new
puts jc.list

