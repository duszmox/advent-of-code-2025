import Algorithms
import Foundation

struct Day07: AdventDay {

  init(data: String) {
    self.data = data
   
    self.mx = data.split(separator: "\n").lazy.map(Array.init)
    
  }
  var data: String
  
  var mx: [[Character]]

  var entities: Any? { nil }
  

  func part1() -> Any {
    var counter = 0
    var mx = mx
    self.calcRowLaser(1, mx: &mx, counter: &counter)
    return counter
  }
  
  func calcRowLaser(_ row: Int, mx:inout [[Character]], counter: inout Int) {
    guard row > 0 && row < mx.count else { return }
    let lastRowPositions = mx[row-1].enumerated().filter { (_, char) in
      char == "|" || char == "S"
    }
    for (idx, _) in lastRowPositions {
      var split = false
      switch mx[row][idx] {
      case ".":
        mx[row][idx] = "|"
      case "^":
        if idx > 0 && mx[row][idx-1] == "." {
          mx[row][idx-1] = "|"
          split = true
        }
        if idx < mx[row].count-1 && mx[row][idx+1] == "." {
          mx[row][idx+1] = "|"
          split = true
        }
      default:
        break;
      }
      if split {
        counter += 1
      }
    }
    
    calcRowLaser(row+1, mx: &mx, counter: &counter)
  }

  func part2() -> Any {
    guard !mx.isEmpty, !mx[0].isEmpty else { return 0 }

    let cols = mx[0].count
    guard let startCol = mx[0].firstIndex(of: "S") else { return 0 }

    var current = Array(repeating: 0, count: cols)
    current[startCol] = 1

    for row in 1..<mx.count {
      var next = Array(repeating: 0, count: cols)

      for col in 0..<cols {
        let count = current[col]
        if count == 0 { continue }

        let cell = mx[row][col]
        switch cell {
        case ".":
          next[col] += count

        case "^":
          if col > 0 {
            next[col - 1] += count
          }
          if col + 1 < cols {
            next[col + 1] += count
          }

        default:
          next[col] += count
        }
      }

      current = next
    }
    return current.reduce(0, +)
  }
}
