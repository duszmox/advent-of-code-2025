import Algorithms
import Foundation

//Thanks ChatGPT for the data structure hint :D
struct Box: Hashable {
  let x: Int
  let y: Int
  let z: Int
}

private struct Edge {
  let i: Int
  let j: Int
  let dist2: Int64
}

private final class DSU {
  private var parent: [Int]
  private var size: [Int]
  private var components: Int

  init(_ n: Int) {
    self.parent = Array(0..<n)
    self.size = Array(repeating: 1, count: n)
    self.components = n
  }

  private func find(_ x: Int) -> Int {
    var x = x
    while parent[x] != x {
      parent[x] = parent[parent[x]]
      x = parent[x]
    }
    return x
  }

  func union(_ a: Int, _ b: Int) {
    var ra = find(a)
    var rb = find(b)
    if ra == rb { return }
    if size[ra] < size[rb] {
      swap(&ra, &rb)
    }
    parent[rb] = ra
    size[ra] += size[rb]
    components -= 1
  }

  func componentSizes() -> [Int] {
    var counts: [Int: Int] = [:]
    for i in 0..<parent.count {
      let r = find(i)
      counts[r, default: 0] += 1
    }
    return Array(counts.values)
  }
  
  func componentCount() -> Int {
    return components
  }
}

struct Day08: AdventDay {

  var data: String
  var boxes: [Box]

  init(data: String) {
    self.data = data

    self.boxes = data
      .split(separator: "\n").lazy
      .compactMap { line -> Box? in
        let parts = line.split(separator: ",")
        guard parts.count == 3,
              let x = Int(parts[0]),
              let y = Int(parts[1]),
              let z = Int(parts[2])
        else { return nil }
        return Box(x: x, y: y, z: z)
      }
  }

  var entities: Any? { nil }

  func part1() -> Any {
    let n = boxes.count
    guard n > 0 else { return 0 }

    var edges: [Edge] = []
    edges.reserveCapacity(n * (n - 1) / 2)

    for i in 0..<n {
      let a = boxes[i]
      for j in (i + 1)..<n {
        let b = boxes[j]
        let dx = Int64(a.x - b.x)
        let dy = Int64(a.y - b.y)
        let dz = Int64(a.z - b.z)
        let dist2 = dx * dx + dy * dy + dz * dz
        edges.append(Edge(i: i, j: j, dist2: dist2))
      }
    }

    edges.sort { $0.dist2 < $1.dist2 }

    let dsu = DSU(n)
    let k = min(1000, edges.count)
    for idx in 0..<k {
      let e = edges[idx]
      dsu.union(e.i, e.j)
    }

    var sizes = dsu.componentSizes()
    sizes.sort(by: >)

    guard sizes.count >= 3 else {
      return sizes.reduce(1, *)
    }

    let product = sizes.prefix(3).reduce(1, *)
    return product
  }

  func part2() -> Any {
    let n = boxes.count
    guard n > 1 else { return 0 }

    var edges: [Edge] = []
    edges.reserveCapacity(n * (n - 1) / 2)

    for i in 0..<n {
      let a = boxes[i]
      for j in (i + 1)..<n {
        let b = boxes[j]
        let dx = Int64(a.x - b.x)
        let dy = Int64(a.y - b.y)
        let dz = Int64(a.z - b.z)
        let dist2 = dx * dx + dy * dy + dz * dz
        edges.append(Edge(i: i, j: j, dist2: dist2))
      }
    }

    edges.sort { $0.dist2 < $1.dist2 }

    let dsu = DSU(n)
    var lastConnectingEdge: Edge?

    for e in edges {
      let before = dsu.componentCount()
      dsu.union(e.i, e.j)
      let after = dsu.componentCount()
      if after < before {
        lastConnectingEdge = e
        if after == 1 {
          break
        }
      }
    }

    guard let finalEdge = lastConnectingEdge else {
      return 0
    }

    let x1 = boxes[finalEdge.i].x
    let x2 = boxes[finalEdge.j].x
    return x1 * x2
  }
}
