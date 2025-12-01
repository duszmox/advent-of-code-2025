import Algorithms
import Foundation

struct Day01: AdventDay {
  var data: String

  let sizeOfDial = 100

  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }

  func runDial(
    start: Int,
    onUpdate:
      @escaping (_ old: Int, _ new: inout Int, _ hitZero: inout Int, _ dir: String, _ val: Int) ->
      Void
  ) -> Int {
    var zeroCount = 0
    var dialCurr = start

    for instruction in entities {
      let dir = instruction.prefix(1)
      let val = Int(instruction.dropFirst())!

      let old = dialCurr
      switch dir {
      case "R": dialCurr += val
      case "L": dialCurr -= val
      default: fatalError("Unknown char")
      }

      onUpdate(old, &dialCurr, &zeroCount, String(dir), val)
    }

    return zeroCount
  }

  func part1() -> Any {
    runDial(start: 50) { _, new, zeroCount, _, _ in
      new = new % sizeOfDial
      if new == 0 { zeroCount += 1 }
    }
  }

  func part2() -> Any {
    runDial(start: 50) { old, new, zeroCount, dir, steps in
      let n = sizeOfDial

      switch dir {
      case "R":
        let hits = (old + steps) / n
        zeroCount += hits

      case "L":
        let s = old

        if s == 0 {
          zeroCount += steps / n
        } else {
          if steps >= s {
            zeroCount += 1 + (steps - s) / n
          }
        }

      default:
        fatalError("Unknown char")
      }

      new = mod(new, n)
    }
  }

  func mod(_ a: Int, _ n: Int) -> Int {
    let r = a % n
    return r >= 0 ? r : r + n
  }
}
