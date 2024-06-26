// Copyright 2024 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Iterates over each element.
///
/// # Arguments
///
/// - `self`: The array to iterate over.
/// - `f`: The function to apply to each element.
///
/// # Example
///
/// ```
/// [1, 2, 3, 4, 5].iter(fn(x){ print("\(x) ") }) //output: 1 2 3 4 5
/// ```
/// @intrinsic %array.iter
pub fn iter[T](self : Array[T], f : (T) -> Unit) -> Unit {
  for i = 0; i < self.length(); i = i + 1 {
    f(self[i])
  }
}

test "iter" {
  let mut i = 0
  let mut failed = false
  [1, 2, 3, 4, 5].iter(
    fn(elem) {
      if elem != i + 1 {
        failed = true
      }
      i = i + 1
    },
  )
  @assertion.assert_false(failed)?
}

/// Iterates over the array with index. 
///
/// # Arguments
///
/// - `self`: The array to iterate over.
/// - `f`: A function that takes an `Int` representing the index and a `T` representing the element of the array, and returns `Unit`.
///
/// # Example
///
/// ```
/// [1, 2, 3, 4, 5].iteri(fn(index, elem){
///   print("(\(index),\(elem)) ")
/// }) //output: (0,1) (1,2) (2,3) (3,4) (4,5)
/// ```
pub fn iteri[T](self : Array[T], f : (Int, T) -> Unit) -> Unit {
  for i = 0; i < self.length(); i = i + 1 {
    f(i, self[i])
  }
}

test "iteri" {
  let mut i = 0
  let mut failed = false
  [1, 2, 3, 4, 5].iteri(
    fn(index, elem) {
      if index != i || elem != i + 1 {
        failed = true
      }
      i = i + 1
    },
  )
  @assertion.assert_false(failed)?
}

/// Iterates over each element in reversed turn.
///
/// # Arguments
///
/// - `self`: The array to iterate over.
/// - `f`: The function to apply to each element.
///
/// # Example
///
/// ```
/// [1, 2, 3, 4, 5].iter(fn(x){ print("\(x) ") }) //output: 5 4 3 2 1
/// ```
pub fn iter_rev[T](self : Array[T], f : (T) -> Unit) -> Unit {
  for i = self.length() - 1; i >= 0; i = i - 1 {
    f(self[i])
  }
}

test "iter_rev" {
  let mut i = 6
  let mut failed = false
  [1, 2, 3, 4, 5].iter_rev(
    fn(elem) {
      if elem != i - 1 {
        failed = true
      }
      i = i - 1
    },
  )
  @assertion.assert_false(failed)?
}

/// Iterates over the array with index in reversed turn. 
///
/// # Arguments
///
/// - `self`: The array to iterate over.
/// - `f`: A function that takes an `Int` representing the index and a `T` representing the element of the array, and returns `Unit`.
///
/// # Example
///
/// ```
/// [1, 2, 3, 4, 5].iter_revi(fn(index, elem){
///   print("(\(index),\(elem)) ")
/// }) //output: (4,5) (3,4) (2,3) (1,2) (0,1) 
/// ```
pub fn iter_revi[T](self : Array[T], f : (Int, T) -> Unit) -> Unit {
  let len = self.length()
  for i = 0; i < len; i = i + 1 {
    f(i, self[len - i - 1])
  }
}

test "iter_revi" {
  let mut i = 6
  let mut j = 0
  let mut failed = false
  [1, 2, 3, 4, 5].iter_revi(
    fn(index, elem) {
      if index != j || elem != i - 1 {
        failed = true
      }
      i = i - 1
      j = j + 1
    },
  )
  @assertion.assert_false(failed)?
}

/// Applies a function to each element of the array and returns a new array with the results.
///
/// # Example
///
/// ```
/// let arr = [1, 2, 3, 4, 5]
/// let doubled = arr.map(fn(x){ x * 2 })
/// debug(doubled) //output: [2, 4, 6, 8, 10]
/// ```
pub fn map[T, U](self : Array[T], f : (T) -> U) -> Array[U] {
  if self.length() == 0 {
    return []
  }
  let res = Array::make(self.length(), f(self[0]))
  for i = 1; i < self.length(); i = i + 1 {
    res[i] = f(self[i])
  }
  res
}

test "map" {
  let arr = [1, 2, 3, 4, 5]
  let doubled = arr.map(fn(x) { x * 2 })
  let empty : Array[Unit] = Array::default().map(fn(x) { x })
  @assertion.assert_eq(empty, [])?
  @assertion.assert_eq(doubled, [2, 4, 6, 8, 10])?
}

/// Maps a function over the elements of the arr with index.
/// 
/// # Example
/// ```
/// let v = [3, 4, 5]
/// v.mapi(fn (i, x) {x + i}) // [3, 5, 6]
/// ```
pub fn mapi[T, U](self : Array[T], f : (T, Int) -> U) -> Array[U] {
  if self.length() == 0 {
    return []
  }
  let res = Array::make(self.length(), f(self[0], 0))
  for i = 1; i < self.length(); i = i + 1 {
    res[i] = f(self[i], i)
  }
  res
}

test "mapi" {
  let arr = [1, 2, 3, 4, 5]
  let doubled = arr.mapi(fn(x, i) { x * 2 + i })
  let empty : Array[Int] = Array::default().mapi(fn(x, i) { x + i })
  @assertion.assert_eq(empty, [])?
  @assertion.assert_eq(doubled, [2, 5, 8, 11, 14])?
}

pub fn op_equal[T : Eq](self : Array[T], that : Array[T]) -> Bool {
  if self.length() != that.length() {
    return false
  }
  for i = 0; i < self.length(); i = i + 1 {
    if self[i] != that[i] {
      return false
    }
  }
  true
}

/// Create a new array. Values are lazily built.
pub fn new[T](length : Int, value : () -> T) -> Array[T] {
  if length <= 0 {
    []
  } else {
    let array = Array::make(length, value())
    for i = 1; i < length; i = i + 1 {
      array[i] = value()
    }
    array
  }
}

test "new" {
  let arr = new(2, fn() { { val: 1 } })
  @assertion.assert_is_not(arr[0], arr[1])?
}

/// Create a new array. Values are built from indexes.
pub fn new_with_index[T](length : Int, value : (Int) -> T) -> Array[T] {
  if length <= 0 {
    []
  } else {
    let array = Array::make(length, value(0))
    for i = 1; i < length; i = i + 1 {
      array[i] = value(i)
    }
    array
  }
}

test "new_index" {
  let arr = new_with_index(2, fn { i => i })
  @assertion.assert_eq(arr[0], 0)?
  @assertion.assert_eq(arr[1], 1)?
}

/// Create a new array with given values.
pub fn Array::from_array[T](array : Array[T]) -> Array[T] {
  array
}

test "from_array" {
  let array = Array::[1, 2, 3, 4, 5]
  @assertion.assert_eq(array, [1, 2, 3, 4, 5])?
}

/// Fold out values from an array according to certain rules.
/// 
/// # Example
/// ```
/// let sum = [1, 2, 3, 4, 5].fold_left(~init=0, fn { sum, elem => sum + elem })
/// sum // 15
/// ```
pub fn fold_left[T, U](self : Array[T], f : (U, T) -> U, ~init : U) -> U {
  for i = 0, acc = init; i < self.length(); {
    continue i + 1, f(acc, self[i])
  } else {
    acc
  }
}

test "fold_left" {
  let sum = [1, 2, 3, 4, 5].fold_left(~init=0, fn { sum, elem => sum + elem })
  @assertion.assert_eq(sum, 15)?
}

/// Fold out values from an array according to certain rules in reversed turn.
/// 
/// # Example
/// ```
/// let sum = [1, 2, 3, 4, 5].fold_right(~init=0, fn { sum, elem => sum + elem })
/// sum // 15
/// ```
pub fn fold_right[T, U](self : Array[T], f : (U, T) -> U, ~init : U) -> U {
  for i = self.length() - 1, acc = init; i >= 0; {
    continue i - 1, f(acc, self[i])
  } else {
    acc
  }
}

test "fold_right" {
  let sum = [1, 2, 3, 4, 5].fold_right(~init=0, fn { sum, elem => sum + elem })
  @assertion.assert_eq(sum, 15)?
}

/// Fold out values from an array according to certain rules with index.
/// 
/// # Example
/// ```
/// let sum = [1, 2, 3, 4, 5].fold_lefti(~init=0, fn { index, sum, elem => sum + index })
/// sum // 10
/// ```
pub fn fold_lefti[T, U](self : Array[T], f : (Int, U, T) -> U, ~init : U) -> U {
  for i = 0, acc = init; i < self.length(); {
    continue i + 1, f(i, acc, self[i])
  } else {
    acc
  }
}

test "fold_lefti" {
  let sum = [1, 2, 3, 4, 5].fold_lefti(
    ~init=0,
    fn { index, sum, _elem => sum + index },
  )
  @assertion.assert_eq(sum, 10)?
}

/// Fold out values from an array according to certain rules in reversed turn with index.
/// 
/// # Example
/// ```
/// let sum = [1, 2, 3, 4, 5].fold_righti(~init=0, fn { index, sum, elem => sum + index })
/// sum // 10
/// ```
pub fn fold_righti[T, U](self : Array[T], f : (Int, U, T) -> U, ~init : U) -> U {
  let len = self.length()
  for i = len - 1, acc = init; i >= 0; {
    continue i - 1, f(len - i - 1, acc, self[i])
  } else {
    acc
  }
}

test "fold_righti" {
  let sum = [1, 2, 3, 4, 5].fold_righti(
    ~init=0,
    fn { index, sum, _elem => sum + index },
  )
  @assertion.assert_eq(sum, 10)?
}

/// Reverses the order of elements in the slice, in place.
/// 
/// # Example
/// ```
/// let arr = [1, 2, 3, 4, 5]
/// reverse(arr) // [5, 4, 3, 2, 1]
/// ```
pub fn reverse[T](self : Array[T]) -> Unit {
  let mid_len = self.length() / 2
  for i = 0; i < mid_len; i = i + 1 {
    let j = self.length() - i - 1
    self.swap(i, j)
  }
}

test "reverse" {
  {
    let arr = [1, 2]
    arr.reverse()
    @assertion.assert_eq(arr, [2, 1])?
  }
  {
    let arr = [1, 2, 3, 4, 5]
    arr.reverse()
    @assertion.assert_eq(arr, [5, 4, 3, 2, 1])?
  }
  let arr = [1]
  arr.reverse()
  @assertion.assert_eq(arr, [1])?
}

/// Swap two elements in the array.
/// 
/// # Example 
/// 
/// ```
/// let arr = [1, 2, 3, 4, 5]
/// arr.swap(0, 1)
/// debug(arr) //output: [2, 1, 3, 4, 5]
/// ```
pub fn swap[T](self : Array[T], i : Int, j : Int) -> Unit {
  let temp = self[i]
  self[i] = self[j]
  self[j] = temp
}

test "swap" {
  let arr = [1, 2, 3, 4, 5]
  arr.swap(0, 1)
  @assertion.assert_eq(arr, [2, 1, 3, 4, 5])?
}

/// Check if all the elements in the array match the condition.
/// 
/// # Example 
/// 
/// ```
/// let arr = [1, 2, 3, 4, 5]
/// arr.all(fn(ele) { ele < 6 }) // true
/// arr.all(fn(ele) { ele < 5 }) // false
/// ```
pub fn all[T](self : Array[T], f : (T) -> Bool) -> Bool {
  for i = 0; i < self.length(); i = i + 1 {
    if f(self[i]).not() {
      return false
    }
  }
  true
}

test "all" {
  let arr = [1, 2, 3, 4, 5]
  @assertion.assert_eq(arr.all(fn(ele) { ele < 6 }), true)?
  @assertion.assert_eq(arr.all(fn(ele) { ele < 5 }), false)?
}

/// Check if any of the elements in the array match the condition.
/// 
/// # Example 
/// 
/// ```
/// let arr = [1, 2, 3, 4, 5]
/// arr.any(fn(ele) { ele < 6 }) // true
/// arr.any(fn(ele) { ele < 5 }) // true
/// ```
pub fn any[T](self : Array[T], f : (T) -> Bool) -> Bool {
  for i = 0; i < self.length(); i = i + 1 {
    if f(self[i]) {
      return true
    }
  }
  false
}

test "any" {
  let arr = [1, 2, 3, 4, 5]
  @assertion.assert_eq(arr.any(fn(ele) { ele < 6 }), true)?
  @assertion.assert_eq(arr.any(fn(ele) { ele < 5 }), true)?
}

/// Fill the array with a given value.
/// 
/// # Example
/// ```
/// [0, 0, 0, 0, 0].fill(3) // [3, 3, 3, 3, 3]
/// ```
pub fn fill[T](self : Array[T], value : T) -> Unit {
  for i = 0; i < self.length(); i = i + 1 {
    self[i] = value
  }
}

test "fill" {
  let arr = [0, 0, 0, 0, 0]
  arr.fill(3)
  @assertion.assert_eq(arr, [3, 3, 3, 3, 3])?
}

/// Search the array index for a given element.
/// 
/// # Example
/// ```
/// let arr = [3, 4, 5]
/// arr.search(3) // 0
/// ```
pub fn search[T : Eq](self : Array[T], value : T) -> Option[Int] {
  for i = 0; i < self.length(); i = i + 1 {
    if self[i] == value {
      return Some(i)
    }
  }
  None
}

test "search" {
  let arr = [1, 2, 3]
  @assertion.assert_eq(arr.search(3), Some(2))?
  @assertion.assert_eq(arr.search(-1), None)?
}

/// Checks if the array contains an element.
/// 
/// # Example
/// ```
/// let arr = [3, 4, 5]
/// arr.contains(3)
/// ```
pub fn contains[T : Eq](self : Array[T], value : T) -> Bool {
  for i = 0; i < self.length(); i = i + 1 {
    if self[i] == value {
      return true
    }
  }
  false
}

test "contains" {
  let arr = [3, 4, 5]
  @assertion.assert_true(arr.contains(3))?
  @assertion.assert_true(arr.contains(4))?
  @assertion.assert_true(arr.contains(5))?
  @assertion.assert_false(arr.contains(6))?
}

/// Check if the array starts with a given prefix.
/// 
/// # Example
/// ```
/// let arr = [3, 4, 5]
/// arr.starts_with([3, 4]) // true
/// ```
pub fn starts_with[T : Eq](self : Array[T], prefix : Array[T]) -> Bool {
  if prefix.length() > self.length() {
    return false
  }
  for i = 0; i < prefix.length(); i = i + 1 {
    if self[i] != prefix[i] {
      return false
    }
  }
  true
}

test "starts_with" {
  let arr = [3, 4, 5]
  @assertion.assert_true(arr.starts_with([3, 4]))?
  @assertion.assert_true(arr.starts_with([3, 4, 5]))?
  @assertion.assert_false(arr.starts_with([3, 4, 5, 6]))?
}

/// Check if the array ends with a given suffix.
/// 
/// # Example
/// ```
/// let v = [3, 4, 5]
/// v.ends_with([5]) // true
/// ```
pub fn ends_with[T : Eq](self : Array[T], suffix : Array[T]) -> Bool {
  let self_len = self.length()
  let suf_len = suffix.length()
  if suf_len > self_len {
    return false
  }
  for i = 0; i < suf_len; i = i + 1 {
    if self[self_len - suf_len + i] != suffix[i] {
      return false
    }
  }
  true
}

test "ends_with" {
  let arr = [3, 4, 5]
  @assertion.assert_true(arr.ends_with([4, 5]))?
  @assertion.assert_true(arr.ends_with([3, 4, 5]))?
  @assertion.assert_false(arr.ends_with([2, 3, 4, 5]))?
}

/// Convert array to list.
/// 
/// # Example
///
/// ```
/// [1, 2, 3, 4, 5].to_list()
/// ```
pub fn to_list[T](self : Array[T]) -> List[T] {
  for i = self.length() - 1, list = List::Nil; i >= 0; {
    continue i - 1, List::Cons(self[i], list)
  } else {
    list
  }
}

fn deep_clone[T](arr : Array[T]) -> Array[T] {
  let len = arr.length()
  if len == 0 {
    []
  } else {
    let result = Array::make(len, arr[0])
    for i = 0; i < len; i = i + 1 {
      result[i] = arr[i]
    }
    result
  }
}

pub fn op_add[T](self : Array[T], other : Array[T]) -> Array[T] {
  let slen = self.length()
  let nlen = other.length()
  if slen == 0 {
    deep_clone(other)
  } else if nlen == 0 {
    deep_clone(self)
  } else {
    let result = Array::make(slen + nlen, self[0])
    for i = 1; i < slen; i = i + 1 {
      result[i] = self[i]
    }
    for i = 0; i < nlen; i = i + 1 {
      result[i + slen] = other[i]
    }
    result
  }
}

test "to_list" {
  let ls = [1, 2, 3, 4, 5].to_list()
  @assertion.assert_eq(ls, Cons(1, Cons(2, Cons(3, Cons(4, Cons(5, Nil))))))?
}

test "op_equal" {
  inspect([1, 2] == [1], ~content="false")?
  inspect(starts_with([1, 2, 3], [1, 3]), ~content="false")?
}

test "op_add" {
  inspect(([] : Array[Int])+[], ~content="[]")?
  inspect([] + [1, 2, 3, 4, 5], ~content="[1, 2, 3, 4, 5]")?
  inspect([1, 2, 3, 4, 5] + [], ~content="[1, 2, 3, 4, 5]")?
  inspect(
    [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10],
    ~content="[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]",
  )?
}
