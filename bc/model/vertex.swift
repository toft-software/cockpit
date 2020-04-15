import Foundation


public class Vertex : NSObject {

    var id : Int
    var neighbors : LinkedList<Vertex>?
    public var isSearched : Bool
    var predecessor  : Vertex?

    
    init(id : Int) {
        self.id = id;
        self.neighbors = LinkedList<Vertex>();
        self.isSearched = false;
   
    }
       

    func addNeighbor( vertex : Vertex) {
        self.neighbors!.append(vertex);
    }

    func setId(id : Int ) {
        self.id = id;
    }

    func getNeighbors()  -> LinkedList<Vertex>? {
        return self.neighbors!;
    }

    func setNeighbors(neighbors : LinkedList<Vertex> ) {
        self.neighbors = neighbors;
    }

    func setSerched(isSearched : Bool ) {
        self.isSearched = isSearched;
    }

    func getPredecessor() -> Vertex? {
        return predecessor;
    }

    func setPredecessor(predecessor : Vertex ) {
        self.predecessor = predecessor;
    }

}
