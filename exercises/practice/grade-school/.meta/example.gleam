import gleam/dict.{type Dict}
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleam/list
import gleam/pair
import gleam/int

pub type School {
  School(grades: Dict(Int, List(String)))
}

pub fn create() -> School {
  School(dict.new())
}

pub fn roster(school: School) -> List(String) {
  school.grades
  |> dict.to_list()
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.map(pair.second)
  |> list.map(list.sort(_, string.compare))
  |> list.flatten()
}

pub fn add(
  to school: School,
  student student: String,
  grade grade: Int,
) -> Result(School, Nil) {
  case list.contains(roster(school), student) {
    True -> Error(Nil)
    False ->
      dict.update(in: school.grades, update: grade, with: fn(existing_students) {
        case existing_students {
          Some(students) -> [student, ..students]
          None -> [student]
        }
      })
      |> School
      |> Ok
  }
}

pub fn grade(school: School, desired_grade: Int) -> List(String) {
  dict.get(school.grades, desired_grade)
  |> result.unwrap([])
  |> list.sort(string.compare)
}
