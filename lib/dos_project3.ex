defmodule NodeServer do
  use GenServer
  #API Calls
  def updateIdentifier(server_id, identity_value) do
    GenServer.cast(server_id,{:updateIdentifier,identity_value})
  end

  def print(server_id) do
    print  = GenServer.call(server_id,{:print})
    IO.puts " #{inspect(server_id)} ---->#{inspect(print)}"
  end

  def init(name) do
    map = %{
      identifier: 0,
      connections: []
    }
    {:ok,map}
  end

  #Call Functions
  def handle_call({:print},_caller,state) do
#    IO.inspect(state.identifier)
    {:reply,state.identifier,state}
  end

  #Cast Functions
  def handle_cast({:updateIdentifier,identity_value},state) do
    new_state = %{
    identifier: identity_value,
    connections: state.connections
    }
    {:noreply,new_state}
  end

end
"""
This is to test git from IntelliJ
"""
defmodule DOS_PROJECT3 do
  @moduledoc """
  Documentation for DOS_PROJECT3.
  """

  #create Node
  def createNode(nodeNumber) do
    nodeName = String.to_atom("node#{nodeNumber}")
    {:ok, pid} = GenServer.start(NodeServer, name: nodeName)
    pid
  end

  def main(args) do
    numNodes = Enum.at(args,0)
    numRequests = Enum.at(args,1)
    nodeList = Enum.map(1..numNodes, fn(x) ->
#      IO.puts("hello")
            createNode(x)
    end)
    IO.inspect nodeList
    Enum.each(nodeList,fn(x) ->
      NodeServer.updateIdentifier(x,Base.encode16(:crypto.hash(:sha,inspect(x))))
    end)

    Enum.each(nodeList,fn(x) ->
      NodeServer.print(x)
    end)
  end
end
