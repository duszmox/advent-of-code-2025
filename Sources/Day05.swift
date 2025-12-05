import Algorithms

struct Day05: AdventDay {
  
  init(data: String) {
    self.data = data
    let split = data.split(separator: "\n\n")
    let freshString = split[0].split(separator: "\n")
    let ingString = split[1].split(separator: "\n")
    
    freshIngredients = freshString.map({ subStr in
      let split = subStr.split(separator: "-")
      let first = Int(split[0])!
      let last = Int(split[1])!
      return (first, last)
    })
    ingredients = ingString.map({ Int($0)! })
  }
  var data: String

  var entities: Any? {nil}
  
  var freshIngredients: [(start: Int,end: Int)]
  var ingredients: [Int]
  

  func part1() -> Any {
    var sum = 0
    ingredients.forEach { ing in
      for (start, end) in freshIngredients {
        if ing >= start && ing <= end {
          sum += 1
          break
        }
      }
    }
    return sum
  }

  func part2() -> Any {
    let sorted = freshIngredients.sorted { $0.0 < $1.0 }

      var merged: [(Int, Int)] = []
      
      for (start, end) in sorted {
          if let last = merged.last {
              if start <= last.1 + 1 {
                  merged[merged.count - 1].1 = max(last.1, end)
              } else {
                  merged.append((start, end))
              }
          } else {
              merged.append((start, end))
          }
      }
      
      return merged.reduce(0) { $0 + ($1.1 - $1.0 + 1) }
  }
}
