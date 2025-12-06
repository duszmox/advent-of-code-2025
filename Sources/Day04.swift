import Algorithms

//Brute force, bc I have finals tomorrow xd
struct Day04: AdventDay {
  var data: String

  var entities: [[Bool]] {
    data.split(separator: "\n").map {
      String($0).map { $0 == "@" }
    }
  }

  func part1() -> Any {
    var sum = 0
    let ents = entities

    for y in 0..<ents.count {
      for x in 0..<ents[y].count {
        if ents[y][x] {
          if around((x, y), entities: ents) < 4 {
            sum += 1
          }
        }
      }
    }
    return sum
  }

  func around(_ point: (x: Int, y: Int)) -> Int {
    return around(point, entities: entities)
  }

  func around(_ point: (x: Int, y: Int), entities: [[Bool]]) -> Int {
    var sum = 0
    let offsets: [(Int, Int)] = [
      (-1, 0), (1, 0), (0, -1), (0, 1), (1, 1), (-1, -1), (1, -1), (-1, 1),
    ]

    for offset in offsets {
      if at((point.x + offset.0, point.y + offset.1), entities: entities) {
        sum += 1
      }
    }
    return sum
  }

  func at(_ point: (x: Int, y: Int), entities: [[Bool]]) -> Bool {
    guard point.x >= 0,
      point.y >= 0,
      point.x < entities.first!.count,
      point.y < entities.count
    else { return false }

    return entities[point.y][point.x]
  }

  func part2() -> Any {
    var ents = entities
    var removals = toBeRemoved(entities: ents)
    var sum = removals.count

    while !removals.isEmpty {
      for (x, y) in removals {
        ents[y][x] = false
      }

      removals = toBeRemoved(entities: ents)
      if !removals.isEmpty {
        sum += removals.count
      }
    }

    return sum
  }

  func toBeRemoved(entities: [[Bool]]) -> [(Int, Int)] {
    var result: [(Int, Int)] = []

    for y in 0..<entities.count {
      for x in 0..<entities[y].count {
        if entities[y][x] {
          if around((x, y), entities: entities) < 4 {
            result.append((x, y))
          }
        }
      }
    }

    return result
  }
}
